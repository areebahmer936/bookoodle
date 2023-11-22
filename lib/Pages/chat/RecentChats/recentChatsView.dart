import 'package:bookoodle/Pages/chat/ChatView/ChatView.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentChatsView extends StatefulWidget {
  const RecentChatsView({super.key});

  @override
  State<RecentChatsView> createState() => _RecentChatsViewState();
}

class _RecentChatsViewState extends State<RecentChatsView> {
  Future GetData(docData) async {
    if (docData['Users'][0] == FirebaseAuth.instance.currentUser!.uid) {
      return await FirebaseFirestore.instance
          .collection("Users")
          .doc(docData["Users"][1])
          .get();
    } else {
      print("condition 2");
      return await FirebaseFirestore.instance
          .collection("Users")
          .doc(docData["Users"][0])
          .get();
    }
  }

  void navigateToChatView(BuildContext context,
      Map<String, dynamic> remoteUserData, String? currentChatRoomId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChatView(
                  remoteUserData: remoteUserData,
                  currentChatRoomId: currentChatRoomId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: peach,
        title: const Text("Recent Chats"),
      ),
      body: Container(
        color: peach.withOpacity(0.3),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatRoom")
              .where("Users",
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  collectionSnapshot) {
            if (collectionSnapshot.hasData) {
              return ListView(
                children: collectionSnapshot.data!.docs
                    .map((DocumentSnapshot<Map<String, dynamic>> document) {
                  Map docData = document.data() as Map;
                  return FutureBuilder(
                    future: GetData(docData),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () {
                            navigateToChatView(
                                context,
                                {
                                  "fName": snapshot.data["fName"],
                                  "uid": snapshot.data["uid"]
                                },
                                document.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          color: dpeach.withOpacity(0.4),
                                          blurStyle: BlurStyle.outer)
                                    ],
                                    borderRadius: BorderRadius.circular(17),
                                    color: Colors.white),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300),
                                      child: snapshot.data['profilePicture'] ==
                                              ''
                                          ? const Center(
                                              child: Icon(Icons.person))
                                          : Image.network(
                                              snapshot.data['profilePicture'],
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data['fName'],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "Last message: ${docData['lastMessage']}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ]),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      } else {
                        return const Center(child: SizedBox());
                      }
                    },
                  );
                }).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

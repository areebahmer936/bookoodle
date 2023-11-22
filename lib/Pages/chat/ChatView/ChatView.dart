import 'package:bookoodle/Pages/chat/widget/myChatContainer.dart';
import 'package:bookoodle/Pages/chat/widget/otherChatContainer.dart';
import 'package:bookoodle/models/message.dart';
import 'package:bookoodle/models/remoteUser.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ChatView extends StatefulWidget {
  final Map<String, dynamic> remoteUserData;
  final String? currentChatRoomId;
  const ChatView(
      {super.key, required this.remoteUserData, this.currentChatRoomId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController chatMessageController = TextEditingController();
  RemoteUser? remoteUser;
  String currentChatRoomId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentChatRoomId = widget.currentChatRoomId ?? "";
    onInitalize(widget.remoteUserData, currentChatRoomId);
  }

  onBack(BuildContext context) {
    chatMessageController.clear();
    Navigator.pop(context);
  }

  onInitalize(
      Map<String, dynamic> doctorData, String? currentChatRoomId) async {
    remoteUser = RemoteUser.fromJson(doctorData);
    if (currentChatRoomId == null) {
      await getChatRoomIDIfExist();
    } else {
      this.currentChatRoomId = currentChatRoomId;
    }
    setState(() {});
  }

  sendMessage() async {
    if (chatMessageController.text.isNotEmpty) {
      Message message = Message(
        uid: FirebaseAuth.instance.currentUser!.uid,
        content: chatMessageController.text,
        time: DateTime.now(),
        isRead: false,
      );
      chatMessageController.clear();

      // if chat room id is empty then create a new chat room
      if (currentChatRoomId.isEmpty) {
        await FirebaseFirestore.instance.collection("chatRoom").add({
          "Users": [FirebaseAuth.instance.currentUser!.uid, remoteUser!.uid],
          "lastMessage": message.content
        }).then((value) {
          currentChatRoomId = value.id;
        });
      }
      // add message to chat room
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId)
          .collection("chats")
          .add(message.toJson());

      // update last message in chat room
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId)
          .update({"lastMessage": message.content});
    }
    setState(() {});
  }

  Future<void> getChatRoomIDIfExist() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("chatRoom")
        .where("Users", arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      Map docData = document.data() as Map;
      if (docData["Users"][0] == remoteUser!.uid ||
          docData["Users"][1] == remoteUser!.uid) {
        currentChatRoomId = document.id;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contextSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dpeach,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, //viewModel.onBack(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(remoteUser!.fName),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/app/background.png"),
                fit: BoxFit.cover,
                opacity: 0.2)),
        child: Container(
          color: Colors.green.withOpacity(0.07),
          child: Column(
            children: [
              currentChatRoomId.isNotEmpty
                  ? Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("chatRoom")
                            .doc(currentChatRoomId)
                            .collection("chats")
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            List<QueryDocumentSnapshot> docs =
                                snapshot.data!.docs;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 0),
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: docs.length,
                                  itemBuilder: (context, index) {
                                    Message message = Message.fromJson(
                                        docs[index].data()
                                            as Map<String, dynamic>);
                                    message.id = docs[index].id;
                                    if (message.uid ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      return myChatContainer(
                                          context, message, index);
                                    } else {
                                      if (message.isRead == false) {
                                        message.updateReadStatus(
                                            currentChatRoomId, docs[index].id);
                                      }
                                      return otherPeopleChatContainer(
                                          context, message, index);
                                    }
                                  }),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    )
                  : const Spacer(),
              Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.camera_alt_outlined, color: darkBrown),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 228, 228),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: contextSize.height * 0.17),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              maxLines: null,
                              controller: chatMessageController,
                              decoration: const InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  hintText: "Write a Message",
                                  hintStyle: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 136, 136, 136),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessage();
                        },
                        icon: Icon(Icons.send_rounded, color: darkBrown))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

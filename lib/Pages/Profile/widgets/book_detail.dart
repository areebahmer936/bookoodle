import 'package:bookoodle/Pages/chat/ChatView/ChatView.dart';
import 'package:bookoodle/models/remoteUser.dart';
import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookDetail extends StatefulWidget {
  final Map arguments;
  BookDetail({super.key, required this.arguments});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final bookExchangeKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController bookName = TextEditingController();

  String? validatebookName(String? value) {
    return value!.length >= 4 ? null : "Should be at least 4 characters!";
  }

  Future<String?> getChatroomId(String otherUserUid) async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    // Query for documents where the 'users' array contains both UIDs
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('chatRoom')
        .where('Users', arrayContainsAny: [currentUid, otherUserUid]).get();

    // Iterate through the documents to find the one with both UIDs
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      List<dynamic> users = documentSnapshot['Users'];

      // Check if both UIDs are present in the 'users' array
      if (users.contains(currentUid) && users.contains(otherUserUid)) {
        // Return the document ID
        return documentSnapshot.id;
      }
    }

    // If no matching document is found, return null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
              child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(minHeight: h * 0.4),
              width: w * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Column(children: [
                SizedBox(height: h * 0.04),
                Text(
                  "Book: ${widget.arguments["bookName"]}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "by: ${widget.arguments["bookAuthor"]}",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: h * 0.02),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(9)),
                  height: h * 0.2,
                  width: h * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.arguments["bookPictureUrl"],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),
                widget.arguments['forOwned']
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Form(
                          key: bookExchangeKey,
                          child: textInputField(bookName,
                              "book you want from this user", validatebookName),
                        ),
                      ),
                widget.arguments['forOwned']
                    ? SizedBox()
                    : SizedBox(height: h * 0.01),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: peach,
                      onPressed: () async {
                        if (bookExchangeKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          DocumentSnapshot ds = await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(widget.arguments["uid"])
                              .get();
                          Map<String, dynamic> data =
                              ds.data() as Map<String, dynamic>;

                          final otherUserUid = RemoteUser.fromJson(data).uid;
                          final chatRoomId = await getChatroomId(otherUserUid);

                          setState(() {
                            isLoading = false;
                          });

                          if (widget.arguments["forOwned"]) {
                            final msg =
                                "I'm interest in exchange ${widget.arguments["bookName"]}, Let me know if you like any book from my collection";

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatView(
                                          remoteUserData: data,
                                          sendExchange: msg,
                                          currentChatRoomId: chatRoomId,
                                        )));
                          } else {
                            final msg =
                                "Are you interested for exchange? I have ${widget.arguments["bookName"]}, i want ${bookName.text} in return.";
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatView(
                                          remoteUserData: data,
                                          sendExchange: msg,
                                          currentChatRoomId: chatRoomId,
                                        )));
                          }
                        }
                      },
                      child: Text(
                        widget.arguments["forOwned"]
                            ? "Send Exchange Offer"
                            : "Send Offer",
                        style: TextStyle(
                            color: darkBrown, fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(height: h * 0.02)
              ]),
            ),
          )),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: darkBrown,
                  )),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

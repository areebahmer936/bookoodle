import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String uid;
  String content;
  DateTime time;
  bool isRead;
  String? id;

  Message(
      {required this.uid,
      required this.content,
      required this.time,
      required this.isRead,
      this.id});

  Message.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        content = json['content'],
        time = DateTime.parse(json['time']),
        isRead = json['isRead'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'content': content,
        'time': time.toIso8601String(),
        'isRead': isRead,
      };

  Future<void> updateReadStatus(String currentChatRoomId, String docID) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(currentChatRoomId)
        .collection("chats")
        .doc(docID)
        .update({"isRead": true});
  }
}

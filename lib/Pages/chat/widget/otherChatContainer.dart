import "package:bookoodle/models/message.dart";
import "package:bookoodle/widgets/widgets.dart";
import "package:flutter/material.dart";

otherPeopleChatContainer(BuildContext context, Message message, index) {
  final contextSize = MediaQuery.of(context).size;
  return GestureDetector(
    onDoubleTap: () {
      message.content = "";
    },
    child: Container(
      margin: const EdgeInsets.only(top: 0.0, right: 10, left: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: contextSize.width * 0.8,
            ),
            decoration: BoxDecoration(
                color: dpeach,
                boxShadow: [
                  BoxShadow(
                      color: peach,
                      spreadRadius: -1,
                      blurRadius: 9,
                      offset: const Offset(0, 2)),
                ],
                border: Border.all(color: darkBrown),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                )),
            child: Text(
              message.content,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

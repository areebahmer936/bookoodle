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
          Stack(
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
                          color: dpeach,
                          spreadRadius: -1,
                          blurRadius: 9,
                          offset: const Offset(0, 2)),
                    ],
                    border: Border.all(color: dpeach),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(20),
                    )),
                child: Text(
                  message.content,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
                        style: TextStyle(
                            color: darkBrown,
                            fontWeight: FontWeight.w600,
                            fontSize: 8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

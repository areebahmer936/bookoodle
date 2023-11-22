import "package:bookoodle/models/message.dart";
import "package:flutter/material.dart";

myChatContainer(BuildContext context, Message message, index) {
  final contextSize = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.only(top: 0.0, right: 15, left: 10, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(
                  maxWidth: contextSize.width * 0.8, minWidth: 90),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 14,
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(2, 3))
                  ],
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(message.content,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 28),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                    "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 10)),
              ),
            ),
            // Positioned(
            //   right: 25,
            //   bottom: 3,
            //   child: Text(
            //     "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
            //     style: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 12,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
              child: Icon(Icons.done_all,
                  color: message.isRead ? Colors.blue : Colors.grey, size: 20),
            )
          ],
        ),
      ],
    ),
  );
}

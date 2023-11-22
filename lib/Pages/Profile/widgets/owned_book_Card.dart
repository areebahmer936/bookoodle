import 'package:bookoodle/models/book.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OwnedBookCard extends StatelessWidget {
  final Book book;
  const OwnedBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    height: 75,
                    width: 80,
                    child: ClipRRect(
                      child: Image.network(book.bookPictureUrl),
                    )),
                SizedBox(width: 15),
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.bookName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 1),
                        Text("By: ${book.bookAuthor}")
                      ],
                    ))
              ],
            ),
          ),
          Container(
            height: 90,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashFactory: InkRipple.splashFactory,
                enableFeedback: true,
                onLongPress: () => print("long"),
                splashColor: peach.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
                onTap: () =>
                    Navigator.pushNamed(context, "/bookdetail", arguments: {
                  'bookName': book.bookName,
                  "bookAuthor": book.bookAuthor,
                  "bookGenre": book.bookGenre,
                  "bookPictureUrl": book.bookPictureUrl,
                  "uid": book.uid,
                  "forOwned": true
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

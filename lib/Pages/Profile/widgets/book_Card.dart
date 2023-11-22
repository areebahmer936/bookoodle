import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key});

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
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/bookoodle-79747.appspot.com/o/ProfilePictures%2Fareebahmer936%40gmail.com%2F2023-11-22T21%3A46%3A43.698219Screenshot_2023-11-20-04-00-33-485_com.instagram.android.jpg?alt=media&token=49ada8e8-9529-4f5f-becb-b4a0c0cc3148"),
                  ),
                ),
                SizedBox(width: 15),
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Harry Potter",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 1),
                        Text("By dawd")
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
                onTap: () => print(3),
              ),
            ),
          )
        ],
      ),
    );
  }
}

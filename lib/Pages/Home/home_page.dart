import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookoodle',
          style: TextStyle(fontWeight: FontWeight.w600, color: darkBrown),
        ),
        leading: BackButton(
          color: darkBrown,
        ),
        leadingWidth: 60,
        toolbarHeight: 60,
        backgroundColor: peach,
      ),
      body: Text("Daw"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
            enableFeedback: true,
            backgroundColor: Color(0xffF2A981),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {},
            child: Image.asset(
              "assets/app/exchange.png",
              width: 60,
              height: 60,
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: peach,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 66.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.mail_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle the menu button press
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Handle the search button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

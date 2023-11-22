import 'package:bookoodle/Pages/Home/widget/searchBar.dart';
import 'package:bookoodle/Pages/chat/RecentChats/recentChatsView.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: RoundedSearchBar(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, "/othersprofile",
                  arguments: {"uid": "CxayIaiizqTyTrVBu6dQaE4dNc13"}),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: peach.withOpacity(0.2)),
                child: Row(children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade300),
                      child: const Center(child: Icon(Icons.person))),
                  const SizedBox(width: 10),
                  Text(
                    "Unaiza",
                    style: TextStyle(color: darkBrown),
                  )
                ]),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
            enableFeedback: true,
            backgroundColor: Color(0xffF2A981),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              //Navigator.pushNamed(context, '/myprofile',);
              Navigator.pushNamed(
                context,
                '/myprofile',
              );
            },
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.mail_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  // DocumentSnapshot ds = await FirebaseFirestore.instance
                  //     .collection("Users")
                  //     .doc("PLkNpgdOHsZOn0s6qv4fmVl6ea33")
                  //     .get();
                  // Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RecentChatsView()));
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

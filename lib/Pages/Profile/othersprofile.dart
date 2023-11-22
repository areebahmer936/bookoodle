import 'package:bookoodle/Pages/Profile/widgets/owned_book_Card.dart';
import 'package:bookoodle/Pages/Profile/widgets/wishlist_book_Card.dart';
import 'package:bookoodle/models/book.dart';
import 'package:bookoodle/models/user.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OthersProfileView extends StatefulWidget {
  final Map userUid;
  const OthersProfileView({super.key, required this.userUid});

  @override
  State<OthersProfileView> createState() => _OthersProfileViewState();
}

class _OthersProfileViewState extends State<OthersProfileView> {
  UserModel? userData;
  bool imgSelected = false;
  late String? imgUrl;
  bool isLoading = false;
  bool isListLoading = false;

  List<Book> wishlist = [];
  List<Book> ownedBooks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgUrl = "";
    initiateProfile();
  }

  TextStyle stl =
      TextStyle(color: darkBrown, fontSize: 22, fontWeight: FontWeight.w600);

  Future<void> getBooks(String uid, {reload = false}) async {
    if (reload) {
      setState(() {
        isListLoading = true;
      });
    }
    final docRef = FirebaseFirestore.instance.collection("Books").doc(uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('wishlist')) {
        wishlist = (data['wishlist'] as List<dynamic>).map((bookData) {
          return Book.fromJson(bookData as Map<String, dynamic>);
        }).toList();
      }

      if (data.containsKey('ownedBooks')) {
        ownedBooks = (data['ownedBooks'] as List<dynamic>).map((bookData) {
          return Book.fromJson(bookData as Map<String, dynamic>);
        }).toList();
      }
    } else {
      // If the document doesn't exist, create a new one with the current user's UID
      await docRef.set({
        'wishlist': [],
        'ownedBooks': [],
      });
    }
    if (reload) {
      setState(() {
        isListLoading = false;
      });
    }
  }

  bookLists(list, mode) {
    print(list.length);
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 80),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: lGrey),
      child: isListLoading
          ? Center(
              child: CircularProgressIndicator(
              color: darkBrown,
            ))
          : list.isEmpty
              ? const Center(
                  child: Text("Theres nothing here",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    // You can customize each item here based on the index
                    if (mode == "owned") {
                      return OwnedBookCard(book: list[index]);
                    } else {
                      return WishlistBookCard(book: list[index]);
                    }
                  },
                ),
    );
  }

  initiateProfile() async {
    await getUserData();
    await getBooks(widget.userUid["uid"]);
    print(ownedBooks);

    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userUid["uid"])
        .get();
    final userData = UserModel.fromJson(ds.data() as Map<String, dynamic>);
    imgUrl = userData.profilePicture;

    print(imgUrl.toString());
    setState(() {
      isLoading = false;
      print(isLoading);
    });
    return imgUrl;
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    final userRef = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userUid["uid"])
        .get();
    UserModel user = UserModel.fromJson(userRef.data() as Map<String, dynamic>);
    setState(() {
      userData = user;
    });
  }

  showPlaceholder() {
    return ClipOval(
        child: Container(
      color: Colors.white,
      height: 150,
      width: 150,
      child: Image.asset(
        "assets/app/avatarPlaceholder.png",
        fit: BoxFit.contain,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: darkBrown,
            )),
        title: Text(
          'Profile',
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.w600),
        ),
        backgroundColor: peach,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Stack(
                            alignment: const Alignment(0, 0),
                            children: [
                              Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: peach,
                                        blurRadius: 20,
                                      )
                                    ]),
                              ),
                              imgUrl == ""
                                  ? showPlaceholder()
                                  : ClipOval(
                                      child: Container(
                                      color: Colors.white,
                                      height: 150,
                                      width: 150,
                                      child: Image.network(
                                        imgUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            userData!.fName + userData!.lName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            userData!.email,
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Wishlist",
                              style: stl,
                            ),
                          ),
                          const SizedBox(height: 8),
                          bookLists(wishlist, "wishlist"),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              " Books Owned",
                              style: stl,
                            ),
                          ),
                          const SizedBox(height: 8),
                          bookLists(ownedBooks, "owned")
                        ]),
                  ),
                ),
                isLoading
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: darkBrown,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
    );
  }
}

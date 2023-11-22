import 'dart:io';

import 'package:bookoodle/AuthService/helper_functions.dart';
import 'package:bookoodle/Pages/Profile/widgets/owned_book_Card.dart';
import 'package:bookoodle/Pages/Profile/widgets/wishlist_book_Card.dart';
import 'package:bookoodle/models/book.dart';
import 'package:bookoodle/models/user.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool imgSelected = false;
  ImagePicker imagePicker = ImagePicker();
  XFile imageFile = XFile("");
  late String? imgUrl;
  bool isLoading = false;
  bool isListLoading = false;

  List<Book> wishlist = [];
  List<Book> ownedBooks = [];

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
                    if (mode == "owned") {
                      return OwnedBookCard(book: list[index]);
                    } else {
                      return WishlistBookCard(book: list[index]);
                    }
                    // You can customize each item here based on the index
                  },
                ),
    );
  }

  Future<String?> initiateProfile() async {
    setState(() {
      isLoading = true;
      print(isLoading);
    });

    await getBooks(uid);
    print(ownedBooks);

    imgUrl = await HelperFunctions.getProfilePicture();
    if (imgUrl == '') {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userData = UserModel.fromJson(ds.data() as Map<String, dynamic>);
      imgUrl = userData.profilePicture;
    }
    print(imgUrl.toString());
    setState(() {
      isLoading = false;
      print(isLoading);
    });
    return imgUrl;
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

  addImage() async {
    showBottomSheetForPicture(context);
  }

  String email = '';
  String fullName = '';

  getNameandEmail() async {
    email = await HelperFunctions.getEmailsf() ?? "";
    fullName = await HelperFunctions.getNameSf() ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgUrl = "";
    getNameandEmail();
    initiateProfile();
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
      body: Stack(
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
                        Positioned(
                            right: 1,
                            bottom: 1,
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: dpeach),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () {
                                    addImage();
                                  },
                                ))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      fullName,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Wishlist",
                          style: stl,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/addbook',
                                  arguments: {'mode': 'wishlist'});
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: darkBrown,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(height: 8),
                    bookLists(wishlist, "wishlist"),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Books Owned",
                          style: stl,
                        ),
                        IconButton(
                            onPressed: () async {
                              var res = await Navigator.pushNamed(
                                  context, '/addbook',
                                  arguments: {'mode': 'ownedBooks'});
                              if (res == "refresh") {
                                print("yes");
                                initState();
                              }
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: darkBrown,
                              size: 30,
                            ))
                      ],
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

  showBottomSheetForPicture(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from gallery'),
              onTap: () async {
                _addImage('gallery');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                _addImage('camera');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future _addImage(String mode) async {
    imageFile = await addImages(mode);
    imgSelected = true;
    setState(() {
      isLoading = true;
    });
    await _uploadImage(imageFile).then((url) async {
      imgUrl = url;
      await HelperFunctions.setProfilePicture(url);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future _uploadImage(image) async {
    String url = "";
    final ref = FirebaseStorage.instance
        .ref()
        .child('ProfilePictures')
        .child(FirebaseAuth.instance.currentUser!.email.toString())
        .child('${DateTime.now().toIso8601String()}${image.name}');
    await ref.putFile(File(image.path));
    url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'profilePicture': url});
    return url;
  }

  addImages(String mode) async {
    if (mode == "camera") {
      final XFile? selectedImage = await imagePicker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (selectedImage != null) {
        return selectedImage;
      } else {
        return null;
      }
    } else if (mode == "gallery") {
      final XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        return selectedImage;
      } else {
        return null;
      }
    }
  }
}

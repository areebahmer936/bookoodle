import 'dart:io';

import 'package:bookoodle/Pages/Profile/widgets/genre_chips.dart';
import 'package:bookoodle/models/book.dart';
import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBook extends StatefulWidget {
  final Map<String, String> arguments;
  const AddBook({super.key, required this.arguments});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  TextEditingController bookName = TextEditingController();
  TextEditingController bookAuthor = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool imageSelected = false;
  late XFile imageFile;
  bool isLoading = false;
  bool error = false;

  ImagePicker imagePicker = ImagePicker();
  TextStyle stl =
      TextStyle(color: darkBrown, fontSize: 22, fontWeight: FontWeight.w600);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageFile = XFile("");
    if (widget.arguments['mode'] == 'ownedBook') {
      print(true);
    }
  }

  selectImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = selectedImage;
        imageSelected = true;
      });
    } else {
      return null;
    }
  }

  upload(image, genreList) async {
    setState(() {
      isLoading = true;
    });
    String url = "";
    final ref = FirebaseStorage.instance
        .ref()
        .child('ProfilePictures')
        .child(FirebaseAuth.instance.currentUser!.email.toString())
        .child('${DateTime.now().toIso8601String()}${image.name}');
    await ref.putFile(File(image.path));
    url = await ref.getDownloadURL();

    Book book = Book(
        uid: FirebaseAuth.instance.currentUser!.uid,
        bookName: bookName.text,
        bookAuthor: bookAuthor.text,
        bookPictureUrl: url,
        bookGenre: genreList);

    final doc = FirebaseFirestore.instance
        .collection("Books")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final data = await doc.get();
    if (data.exists) {
      await doc.update({
        widget.arguments['mode'] as String:
            FieldValue.arrayUnion([book.toJson()])
      });
    } else {
      await doc.set({
        widget.arguments['mode'] as String:
            FieldValue.arrayUnion([book.toJson()])
      }, SetOptions(merge: true));
    }

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, 'refresh');
  }

  String? validatebookName(String? value) {
    return value!.length >= 4 ? null : "Should be at least 4 characters!";
  }

  String? validatebookAuthor(String? value) {
    return value!.length >= 4 ? null : "Should be at least 4 characters!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Container(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntrinsicHeight(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Form(
                          key: formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  " Add a book",
                                  style: stl.copyWith(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 15),
                                textInputField(bookName, "Name of the book",
                                    validatebookName),
                                textInputField(bookAuthor, "Name of the Author",
                                    validatebookAuthor),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                      text: " Genre(s)",
                                      style: stl,
                                      children: [
                                        TextSpan(
                                            text: "   (select 1 to 3 genres)",
                                            style: TextStyle(
                                              color: Colors.brown.shade300,
                                              fontSize: 15,
                                            ))
                                      ]),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 238, 238, 238),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    height: MediaQuery.of(context).size.height *
                                        0.22,
                                    width: double.infinity,
                                    child: ClipRRect(
                                        child: GenreChips(
                                            key: GenreChips.genreChipsKey))),
                                const SizedBox(height: 8),
                                Text(
                                  " Add a picture",
                                  style: stl,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    imageSelected
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.grey.shade300),
                                            child: Image.file(
                                              File(imageFile.path),
                                              height: 70,
                                              width: 70,
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(width: 5),
                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: MaterialButton(
                                        color: peach,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        onPressed: () {
                                          selectImage();
                                        },
                                        child: imageSelected
                                            ? const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 30,
                                              )
                                            : const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: error
                                      ? const Text(
                                          "please fille the form correctly",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : const SizedBox(),
                                )
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          onPressed: () {
                            List<String> selectedGenres = GenreChips
                                .genreChipsKey.currentState!
                                .getSelectedGenres();
                            if (formKey.currentState!.validate()) {
                              print(selectedGenres);
                              print(imageFile);
                              print(selectedGenres.length == 0);
                              print(selectedGenres.length > 3 ||
                                  selectedGenres.length == 0);
                              if (imageFile.path.isEmpty ||
                                  selectedGenres.length > 3 ||
                                  selectedGenres.length == 0) {
                                print(1);
                                setState(() {
                                  error = true;
                                });
                              } else {
                                setState(() {
                                  error = false;
                                });

                                upload(imageFile, selectedGenres);
                              }
                            }
                          },
                          color: dpeach,
                          child: Text("Add",
                              style: stl.copyWith(color: Colors.white)),
                        ))
                  ],
                ),
              ),
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
                  )),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

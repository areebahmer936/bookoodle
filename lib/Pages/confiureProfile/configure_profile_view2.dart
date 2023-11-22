import 'dart:core';

import 'package:bookoodle/AuthService/helper_functions.dart';
import 'package:bookoodle/Pages/confiureProfile/widgets/genre_chips.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfigureProfile2 extends StatefulWidget {
  final Map arguments;
  const ConfigureProfile2({super.key, required this.arguments});

  @override
  State<ConfigureProfile2> createState() => _ConfigureProfile2State();
}

class _ConfigureProfile2State extends State<ConfigureProfile2> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> selectedGenres = [];
  bool isLoading = false;
  bool errorState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.arguments["lName"]);
  }

  setPref(fName, lName) async {
    await HelperFunctions.setUserNameSf("${fName} $lName");
  }

  setUpProfile(List favGenres) async {
    setState(() {
      isLoading = true;
    });
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Users").doc(uid).update({
      "fName": capitalize(widget.arguments['fName']),
      "lName": capitalize(widget.arguments['lName']),
      "phoneNumber": widget.arguments['phoneNumber'],
      "favGenres": favGenres,
      "configured": true
    }).whenComplete(() {
      setPref(widget.arguments['fName'], widget.arguments['lName']);
      Navigator.pushNamed(context, "/alldone");
    });
    setState(() {
      isLoading = false;
    });
  }

  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const Text(
                      " Select your favourite genres! 😏",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    errorState
                        ? const Text(
                            "  Please select at least one genre!",
                            style: TextStyle(color: Colors.red),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 15),
                    GenreChips(key: GenreChips.genreChipsKey),
                  ]),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()))
              : const SizedBox(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: Row(
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: isLoading ? lightPeach : peach,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: isLoading ? brown : darkBrown,
                    size: 30,
                  ),
                )),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 60,
                child: Hero(
                  tag: 'alldone',
                  child: MaterialButton(
                      color: isLoading ? lightPeach : peach,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: isLoading
                          ? () {}
                          : () {
                              List<String> selectedGenres = GenreChips
                                  .genreChipsKey.currentState!
                                  .getSelectedGenres();
                              if (selectedGenres.isEmpty) {
                                setState(() {
                                  errorState = true;
                                });
                              } else {
                                setUpProfile(selectedGenres);
                              }
                            },
                      splashColor: isLoading ? Colors.transparent : peach,
                      enableFeedback: true,
                      highlightColor: Colors.transparent,
                      child: Text("All Done",
                          style: TextStyle(
                              color: isLoading ? brown : darkBrown,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

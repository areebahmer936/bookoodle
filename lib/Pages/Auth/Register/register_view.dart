import 'dart:async';

import 'package:bookoodle/AuthService/auth_service.dart';
import 'package:bookoodle/AuthService/helper_functions.dart';
import 'package:bookoodle/widgets/pass_Input_field.dart';
import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? validateEmail(String? value) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value!)
        ? null
        : "Enter a Correct Email!";
  }

  String? validatePassword(String? value) {
    if (value!.length < 6) {
      return 'Password should be 6 characters long';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Password should be same';
    } else if (value!.length < 6) {
      return 'Password should be 6 charachters long';
    } else {
      return null;
    }
  }

  setCredentials(uid, email, fName, lName) async {
    await HelperFunctions.setUid(uid);
    await HelperFunctions.setUserEmailSf(email);
    await HelperFunctions.setUserLoggedInStatus(true);
    await HelperFunctions.setUserNameSf("${fName} ${lName}");
  }

  Future signup() async {
    setState(() {
      isLoading = true;
    });
    await authService
        .registerUser(
            email: emailcontroller.text, password: passwordController.text)
        .then((value) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      setCredentials(uid, emailcontroller.text, "", "");
      if (value == true) {
        await FirebaseFirestore.instance.collection("Users").doc(uid).set({
          "uid": uid,
          "email": emailcontroller.text,
          "fName": "",
          "lName": "",
          "favGenres": <String>[],
          "configured": false
        }).then((e) => {Navigator.pushNamed(context, '/config')});
      } else {
        showSnackbar(context, value, Colors.red);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/app/background.png"),
                opacity: 0.7,
                fit: BoxFit.cover)),
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        blurStyle: BlurStyle.outer)
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white.withOpacity(0.9)),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          " Register",
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Ubuntu",
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 50),
                      textInputField(emailcontroller, "Email", validateEmail),
                      passwordInputField(
                          controller: passwordController,
                          label: "Password",
                          validator: validatePassword),
                      passwordInputField(
                          controller: confirmPasswordController,
                          label: "Confirm Password",
                          validator: validateConfirmPassword),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        width:
                            isLoading ? 60 : MediaQuery.of(context).size.width,
                        height: 60,
                        child: MaterialButton(
                            color: const Color(0xfff5b693),
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      signup();
                                    }
                                  },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(isLoading ? 50 : 15)),
                            child: isLoading
                                ? const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 90, 0, 9),
                                    ),
                                  )
                                : Text(
                                    "Register",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        fontFamily: "Ubuntu",
                                        color: darkBrown),
                                  )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text.rich(
                        TextSpan(
                          text: " Already have an account? ",
                          style: TextStyle(color: darkBrown, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login  ",
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

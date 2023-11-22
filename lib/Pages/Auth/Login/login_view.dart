import 'package:bookoodle/AuthService/auth_service.dart';
import 'package:bookoodle/AuthService/helper_functions.dart';
import 'package:bookoodle/models/user.dart';
import 'package:bookoodle/widgets/pass_Input_field.dart';
import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  setCredentials(uid, email, fName, lName) async {
    await HelperFunctions.setUid(uid);
    await HelperFunctions.setUserEmailSf(email);
    await HelperFunctions.setUserLoggedInStatus(true);
    await HelperFunctions.setUserNameSf("${fName} $lName");
  }

  logIn() async {
    setState(() {
      isLoading = true;
    });
    await authService
        .loginUser(
            email: emailcontroller.text, password: passwordController.text)
        .then((value) async {
      if (value == true) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot ds =
            await FirebaseFirestore.instance.collection("Users").doc(uid).get();
        final userData = UserModel.fromJson(ds.data()! as Map<String, dynamic>);
        if (userData.configured != true) {
          Navigator.pushReplacementNamed(context, '/config');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        showSnackbar(context, value, Colors.red);
      }
    });
    setState(() {
      isLoading = false;
    });
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
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " Log In",
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/passreset');
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    width: isLoading ? 60 : MediaQuery.of(context).size.width,
                    height: 60,
                    child: MaterialButton(
                        color: const Color(0xfff5b693),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            logIn();
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
                            : const Text(
                                "Log In",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    fontFamily: "Ubuntu",
                                    color: Color.fromARGB(255, 90, 0, 9)),
                              )),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: " Don't have an account?",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 90, 0, 9), fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: " Register",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.pushNamed(context, '/register');
                                Navigator.pushNamed(context, "/register");
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
    );
  }
}

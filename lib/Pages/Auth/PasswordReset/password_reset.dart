import 'package:bookoodle/AuthService/auth_service.dart';
import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  AuthService authService = AuthService();
  bool sent = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(value!)
        ? null
        : "Enter a Correct Email!";
  }

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    await authService.resetPassword(emailController.text).then((value) {
      if (value == true) {
        setState(() {
          isLoading = false;
          sent = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } else {
        showSnackbar(context, value, Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Form(
            key: formKey,
            child: IntrinsicHeight(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.1),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 15,
                              blurStyle: BlurStyle.outer)
                        ],
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: sent
                        ? Column(children: [
                            SizedBox(
                              height: 250,
                              child: Lottie.asset("assets/app/passReset.json",
                                  repeat: false, frameRate: FrameRate.max),
                            ),
                            Text(
                              "Kindly, check your email.",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: darkBrown),
                            )
                          ])
                        : Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    "  Enter your registered email.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 30),
                                  textInputField(
                                      emailController, "Email", validateEmail),
                                  const SizedBox(height: 15),
                                  const Spacer(),
                                  SizedBox(
                                    height: 60,
                                    width: double.infinity,
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: peach,
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            resetPassword();
                                          }
                                        },
                                        child: Text(
                                          "Send Password reset link",
                                          style: TextStyle(
                                              color: darkBrown,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17),
                                        )),
                                  )
                                ],
                              ),
                              isLoading
                                  ? Container(
                                      color: Colors.white.withOpacity(0.5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            color: darkBrown),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          )),
              ),
            )),
      ),
    );
  }
}

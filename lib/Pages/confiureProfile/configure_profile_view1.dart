import 'package:bookoodle/widgets/text_input_feild.dart';
import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfigureProfile extends StatefulWidget {
  const ConfigureProfile({super.key});

  @override
  State<ConfigureProfile> createState() => _ConfigureProfileState();
}

class _ConfigureProfileState extends State<ConfigureProfile> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedGenres = [];

  String? validatePhoneNo(String? value) {
    return RegExp(r"^((\+92)??(0)?)(3)([0-9]{9})$").hasMatch(value!)
        ? null
        : "Enter Correct Phone Number!";
  }

  String? validateName(String? value) {
    return value!.length > 4 ? null : "Should be at least 4 characters!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const Text(
              "  Set up your profile! 😃",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            textInputField(fName, "First Name", validateName),
            textInputField(lName, "Last Name", validateName),
            textInputField(phoneNumber, "Phone Number", validatePhoneNo),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Hero(
            tag: 'alldone',
            child: MaterialButton(
              color: peach,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, '/config2', arguments: {
                    "fName": fName.text,
                    "lName": lName.text,
                    "phoneNumber": phoneNumber.text
                  });
                }
              },
              child: Text(
                "Next",
                style: TextStyle(
                    color: darkBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

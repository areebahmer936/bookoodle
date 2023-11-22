import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.normal,
  fontSize: 15,
  color: Color(0xff006a00),
);

Color darkBrown = const Color.fromARGB(255, 90, 0, 9);
Color brown = Color.fromARGB(255, 107, 102, 105);
Color peach = const Color(0xfff5b693);
Color dpeach = const Color.fromARGB(255, 245, 158, 111);
Color lightPeach = const Color.fromARGB(255, 238, 212, 198);

void showSnackbar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

const formFeildColorFill = Color.fromARGB(255, 240, 240, 240);

const boxShadow = [
  BoxShadow(
    offset: Offset(0, 1.5),
    blurRadius: 1,
    color: Colors.black26,
  )
];

final boxdeco = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    image: const DecorationImage(image: AssetImage(''), fit: BoxFit.fill),
    boxShadow: const [
      BoxShadow(
        offset: Offset(0, 1.5),
        blurRadius: 2,
        color: Colors.black26,
      )
    ]);

MaterialButton commonCustomButton = MaterialButton(
  onPressed: () {},
);

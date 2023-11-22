import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllDone extends StatefulWidget {
  const AllDone({super.key});

  @override
  State<AllDone> createState() => _AllDoneState();
}

class _AllDoneState extends State<AllDone> {
  bool _showAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showAnimation = true;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 3500), () {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "All Set !",
              style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w600, color: dpeach),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showAnimation
                  ? SizedBox(
                      width: MediaQuery.of(context).size.height * 0.25,
                      child: Lottie.asset(
                        "assets/app/allDone.json",
                        repeat: false,
                        frameRate: FrameRate.max,
                      ))
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

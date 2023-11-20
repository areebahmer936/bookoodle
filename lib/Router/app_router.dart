import 'dart:ui';

import 'package:bookoodle/Pages/Auth/Login/login_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}

PageRouteBuilder createRouteBlurredBackground(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15 * animation.value,
              sigmaY: 15 * animation.value,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.2), // Transparent background
            ),
          ),
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          )
        ],
      );
    },
  );
}

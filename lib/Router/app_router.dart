import 'dart:ui';

import 'package:bookoodle/Pages/Auth/Login/login_view.dart';
import 'package:bookoodle/Pages/Auth/PasswordReset/password_reset.dart';
import 'package:bookoodle/Pages/Auth/Register/register_view.dart';
import 'package:bookoodle/Pages/Home/home_page.dart';
import 'package:bookoodle/Pages/Profile/add_book.dart';
import 'package:bookoodle/Pages/Profile/othersprofile.dart';
import 'package:bookoodle/Pages/Profile/profile_view.dart';
import 'package:bookoodle/Pages/Profile/widgets/book_detail.dart';
import 'package:bookoodle/Pages/confiureProfile/all_done.dart';
import 'package:bookoodle/Pages/confiureProfile/configure_profile_view1.dart';
import 'package:bookoodle/Pages/confiureProfile/configure_profile_view2.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/register':
        return createRouteWithSwipe(const RegisterView());
      case '/passreset':
        return createRouteBlurredBackground(const PasswordReset());
      case '/bookdetail':
        return createRouteBlurredBackground(BookDetail(
          arguments: settings.arguments as Map<String, dynamic>,
        ));
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/alldone':
        return MaterialPageRoute(builder: (_) => const AllDone());
      case '/myprofile':
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case '/othersprofile':
        return MaterialPageRoute(
            builder: (_) => OthersProfileView(
                  userUid: settings.arguments as Map<String, String>,
                ));
      case '/addbook':
        return createRouteBlurredBackground(
            AddBook(arguments: settings.arguments as Map<String, String>));
      case '/config':
        return createRouteWithSwipe(const ConfigureProfile());
      case '/config2':
        return createRouteWithSwipe(ConfigureProfile2(
            arguments: settings.arguments as Map<String, String>));
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

PageRouteBuilder createRouteWithSwipe(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

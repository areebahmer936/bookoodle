import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginUser({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Send a password reset email
  Future resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUser({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future signOut(context) async {
    try {
      // await HelperFunctions.setUserLoggedInStatus(false);
      // await HelperFunctions.setUserEmailSf("");
      // await HelperFunctions.setUserNameSf("");
      // await HelperFunctions.setProfilePicture("");
      // await HelperFunctions.setUid('');

      await firebaseAuth.signOut();
      // nextScreenReplacement(context, LoginView());
    } catch (e) {
      return null;
    }
  }

  Future<void> updateCurrentUserName({required String name}) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
  }

  Future<String> getUserRoles({required String uid}) async {
    DocumentSnapshot documentReferenceAdmin =
        await FirebaseFirestore.instance.collection("Admin").doc(uid).get();
    if (documentReferenceAdmin.exists) {
      return "Admin";
    } else {
      return "Users";
    }
  }
}

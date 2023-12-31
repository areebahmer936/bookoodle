// import 'dart:io';

// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = 'USERLOGGEDINSTATUS';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'EMAILKEY';
  static String userRoleKey = '';
  static String userEmailVerificationKey = 'EMAILVERIFIED';
  static String userApprovedKey = '';
  static String profileImageUrl = '';
  static String myUid = '';
  // Set
  static Future<bool?> setUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool?> setUserNameSf(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool?> setProfilePicture(String imageUrl) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(profileImageUrl, imageUrl);
  }

  static Future<bool?> setUid(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(myUid, uid);
  }

  static Future<bool?> setUserEmailSf(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> setUserRole(String role) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRoleKey, role);
  }

  static Future<bool?> setEmailVerificatiedStatus(bool status) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userEmailVerificationKey, status);
  }

  // Get
  static Future<String?> getUserRole() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(userRoleKey);
  }

  static Future<String?> getNameSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(userNameKey);
  }

  static Future<String?> getUid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(myUid);
  }

  static Future<String?> getEmailsf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(userEmailKey);
  }

  static Future<String?> getProfilePicture() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(profileImageUrl);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<bool?> getApprovalStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userApprovedKey);
  }

  static Future<bool?> getEmailVerifiedStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userEmailVerificationKey);
  }

  // static Future<List<String>> saveNetworkFilesLocally(
  //     List<String> fileUrls) async {
  //   List<String> filePaths = [];
  //   for (var i = 0; i < fileUrls.length; i++) {
  //     final url = fileUrls[i];
  //     final uri = Uri.parse(url);
  //     final filename = url.split('-').last;
  //     final directory = await getTemporaryDirectory();
  //     final file = File('${directory.path}/$filename');
  //     final response = await http.get(uri);
  //     final savedFile = await file.writeAsBytes(response.bodyBytes);
  //     filePaths.add(savedFile.path);
  //   }
  //   return filePaths;
  // }
}

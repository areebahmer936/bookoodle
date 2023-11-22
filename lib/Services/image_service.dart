import 'dart:async';
import 'dart:io';

import 'package:bookoodle/AuthService/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker imagePicker = ImagePicker();
  XFile ImageFile = XFile("");
  bool imgSelected = false;
  String imageUrl = "";
  AuthService authService = AuthService();

  showBottomSheetForPicture(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from gallery'),
              onTap: () async {
                _addImage('gallery');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                _addImage('camera');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future _addImage(String mode) async {
    ImageFile = await addImages(mode);
    imgSelected = true;
    await _uploadImage(ImageFile).then((url) {
      imageUrl = url;
    });
  }

  Future _uploadImage(image) async {
    String url = "";
    final ref = FirebaseStorage.instance
        .ref()
        .child('ProfilePictures')
        .child(FirebaseAuth.instance.currentUser!.email.toString())
        .child('${DateTime.now().toIso8601String()}${image.name}');
    await ref.putFile(File(image.path));
    url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'profilePicture': url});
    return url;
  }

  addImages(String mode) async {
    if (mode == "camera") {
      final XFile? selectedImage = await imagePicker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (selectedImage != null) {
        return selectedImage;
      } else {
        return null;
      }
    } else if (mode == "gallery") {
      final XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        return selectedImage;
      } else {
        return null;
      }
    }
  }
}

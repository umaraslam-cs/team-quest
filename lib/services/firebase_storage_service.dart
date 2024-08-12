import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FireStorageService {
  Future<String> uploadImageToFirebase(
      BuildContext context, String imagePath, bool isLoading) async {
        
    try {
      String fileName = basename(imagePath);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/$fileName');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': fileName});

      firebase_storage.TaskSnapshot uploadTask;
      //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      uploadTask = await ref
          .putFile(io.File(imagePath), metadata)
          .whenComplete(() => {});

      String downloadURL = await uploadTask.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return "";
    }
  }
}

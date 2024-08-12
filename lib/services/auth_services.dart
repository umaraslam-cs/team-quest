import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_quest/configs/toast_message.dart';
import 'package:team_quest/model/user_model.dart';
import 'package:team_quest/view_model/services/storage/shared_pref_handler.dart';

mixin AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseHandler databaseHandler = DatabaseHandler();

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    UserModel? userModel; // Declare the UserModel variable

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        debugPrint(userCredential.toString());

        // Fetch the user document from Firestore
        DocumentSnapshot documentSnapshot =
            await _db.collection('users').doc(user.uid).get();

        if (documentSnapshot.exists) {
          if (!user.emailVerified) {
            user.sendEmailVerification();
            ShowMessage.onError(
                'Please verify your email, verification link sent to your email address');
          } else {
            userModel = UserModel.fromFirestore(documentSnapshot);
          }
        } else {
          ShowMessage.onError("No User Found");
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Exception : ${e.code}");
      // Handle specific FirebaseAuth errors
      if (e.code == 'invalid-credential') {
        ShowMessage.onError("Invalid Credentials!");
      } else if (e.code == 'user-not-found') {
        ShowMessage.onError("No User Found");
      }
    } catch (e) {
      if (e.toString().split("]").isNotEmpty) {
        if (e.toString().split("]").last.contains("The password is invalid")) {
          ShowMessage.onError("Invalid Credentials!");
        } else {
          ShowMessage.onError(e.toString().split("]").last);
        }
      }
    }

    // Return the initialized UserModel, or throw an error if it's null
    if (userModel != null) {
      return userModel;
    } else {
      throw Exception("Failed to sign in and initialize UserModel");
    }
  }

  Future<bool> registerWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    bool result = false;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      var data = {
        'email': email,
        'uid': user!.uid,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
      // create a new document for the user with the uid
      await _db.collection('users').doc(user.uid).set(data);

      // send email verification
      if (!user.emailVerified) {
        await user.sendEmailVerification().then((value) {
          result = true;
        });
        ShowMessage.onSuccess("Verification sent to email address");
      }
    } catch (e) {
      debugPrint(e.toString());
      if (e.toString().split("]").isNotEmpty) {
        ShowMessage.onError(e.toString().split("]").last);
      }
    }
    return result;
  }

  Future<bool> setLanguageService(
      {required String language, required String uid}) async {
    bool result = false;
    try {
      var data = {
        'language': language,
      };
      // update the existing document for the user with the uid
      await _db.collection('users').doc(uid).update(data).then((value) async {
        await databaseHandler.setToken(uid);
        result = true;
      });

      ShowMessage.onSuccess("Language set successfully");
    } catch (e) {
      debugPrint(e.toString());
      ShowMessage.onError(e.toString());
    }
    return result;
  }

  Future<bool> onLogOut() async {
    bool result = false;
    try {
      await _auth.signOut();
      databaseHandler.setToken("");
      databaseHandler.setCurrentUser({});

      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }
}

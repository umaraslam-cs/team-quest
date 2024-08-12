import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.email,
    required this.language,
  });

  String email;
  String language;
  String uid;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      language: data['language'] ?? '',
    );
  }
}

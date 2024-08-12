import 'dart:async';
import 'package:flutter/material.dart';
import 'package:team_quest/view_model/services/storage/shared_pref_handler.dart';
import '../../../configs/routes/routes_name.dart';

class SplashServices {
  void checkAuthentication(BuildContext context) async {
    String uid = await DatabaseHandler().getToken();

    if (uid.isNotEmpty) {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.home, (route) => false),
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.login, (route) => false),
      );
    }
  }
}

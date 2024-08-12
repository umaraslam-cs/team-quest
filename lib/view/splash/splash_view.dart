import 'package:flutter/material.dart';
import 'package:team_quest/configs/extensions.dart';
import 'package:team_quest/view_model/services/splash/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    splashServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        height: context.mediaQueryHeight,
        width: context.mediaQueryWidth,
        "assets/images/splash.png",
        fit: BoxFit.cover,
      ),
    );
  }
}

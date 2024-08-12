import 'package:flutter/material.dart';
import 'package:team_quest/configs/routes/routes_name.dart';
import 'package:team_quest/view/auth/registration_view.dart';
import 'package:team_quest/view/auth/select_language_view.dart';
import 'package:team_quest/view/home/create_event_screen.dart';
import 'package:team_quest/view/home/home_view.dart';
import 'package:team_quest/view/auth/login_view.dart';
import 'package:team_quest/view/splash/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());

      case RoutesName.registration:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegistrationView());
      case RoutesName.selectLanguage:
        return MaterialPageRoute(
            builder: (BuildContext context) => SelectLanguageScreen(
                  uid: (settings.arguments as List).first,
                ));
      case RoutesName.createEvent:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateEventScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}

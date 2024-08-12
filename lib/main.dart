import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/view_model/home/home_view_model.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/routes/routes.dart';
import 'configs/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // initializing all the view model crated with Provider to used them across the app
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Team Quest',
        theme: ThemeData(
          fontFamily: "Urbanist",
          scaffoldBackgroundColor: AppColors.whiteColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.blackColor,
            primary: AppColors.blackColor,
          ),
        ),
        // this is the initial route indicating from where our app will start
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

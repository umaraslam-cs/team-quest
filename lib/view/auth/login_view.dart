import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/configs/extensions.dart';
import 'package:team_quest/configs/routes/routes_name.dart';
import 'package:team_quest/configs/toast_message.dart';
import 'package:team_quest/configs/utils.dart';
import 'package:team_quest/configs/validator/app_validator.dart';
import 'package:team_quest/view/auth/widgets/input_email_widget.dart';
import 'package:team_quest/view/auth/widgets/input_password_widget.dart';
import 'package:team_quest/view/auth/widgets/login_button_widget.dart';
import 'package:team_quest/view/auth/widgets/rounded_oulined_button.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';
import 'package:team_quest/view_model/services/storage/shared_pref_handler.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  late AuthViewModel authViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Hello there 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter your username/email and password to sign in.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Username / Email',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InputEmailWidget(
                    focusNode: emailFocusNode,
                    passwordFocusNode: passwordFocusNode),
                const SizedBox(height: 12),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InputPasswordWidget(focusNode: passwordFocusNode),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          value: true,
                          onChanged: (value) {},
                          checkColor: AppColors.whiteColor,
                          activeColor: AppColors.blackColor,
                        ),
                        const Text("Remember me",
                            style: TextStyle(color: AppColors.blackColor)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.blackColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedOutlineButtonWithImage(
                      imagePath: "assets/images/google.png",
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    RoundedOutlineButtonWithImage(
                      imagePath: "assets/images/apple.png",
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    RoundedOutlineButtonWithImage(
                      imagePath: "assets/images/facebook.png",
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  title: "Sign In",
                  onPress: () async {
                    if (authViewModel.email.isEmpty) {
                      ShowMessage.onError('Please enter email');
                    } else if (!AppValidator.emailValidator(
                        authViewModel.email.toString())) {
                      ShowMessage.onError('Please enter valid email');
                    } else if (authViewModel.password.isEmpty) {
                      ShowMessage.onError('Please enter password');
                    } else if (authViewModel.password.length < 6) {
                      ShowMessage.onError('Please enter 6 digit password');
                    } else {
                      authViewModel
                          .signIn(
                              email: authViewModel.email.toString(),
                              password: authViewModel.password.toString())
                          .then((value) async {
                        print(value);
                        if (value.language.isNotEmpty) {
                          await DatabaseHandler().setToken(value.uid);
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, RoutesName.home, (route) => false);
                          }
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesName.selectLanguage,
                              arguments: [value.uid],
                              (route) => false);
                        }
                      }).onError((error, stackTrace) {
                        ShowMessage.onError(error.toString());
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RoutesName.registration),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style:
                          TextStyle(fontSize: 14, color: AppColors.blackColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

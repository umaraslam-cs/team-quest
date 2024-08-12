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
import 'package:team_quest/view/auth/widgets/input_repeat_password_widget.dart';
import 'package:team_quest/view/auth/widgets/login_button_widget.dart';
import 'package:team_quest/view/auth/widgets/rounded_oulined_button.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final repeatPasswordFocusNode = FocusNode();

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
                      "Sign up",
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
                  "Please enter your username/email and password to sign up.",
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
                const SizedBox(height: 12),
                const Text(
                  'Repeat Password',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InputRepeatPasswordWidget(focusNode: repeatPasswordFocusNode),
                const SizedBox(height: 20),
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
                  title: "Sign Up",
                  onPress: () {
                    if (authViewModel.email.isEmpty) {
                      ShowMessage.onError('Please enter email');
                    } else if (!AppValidator.emailValidator(
                        authViewModel.email.toString())) {
                      ShowMessage.onError('Please enter valid email');
                    } else if (authViewModel.password.isEmpty) {
                      ShowMessage.onError('Please enter password');
                    } else if (authViewModel.password.length < 6) {
                      ShowMessage.onError('Please enter 6 digit password');
                    } else if (authViewModel.confirmPassword.isEmpty) {
                      ShowMessage.onError('Please enter confirm password');
                    } else if (authViewModel.password !=
                        authViewModel.confirmPassword) {
                      ShowMessage.onError('Passwords do not match');
                    } else {
                      authViewModel
                          .signUp(
                              email: authViewModel.email.toString(),
                              password: authViewModel.password.toString(),
                              context: context)
                          .then((value) {
                        if (value == true) {
                          Navigator.pop(context);
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
                        Navigator.pushNamed(context, RoutesName.login),
                    child: const Text(
                      "Already have an account? Sign In",
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

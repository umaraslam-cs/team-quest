import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';
import '../../../configs/components/round_button.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const PrimaryButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, provider, child) {
      return RoundButton(
        title: title,
        loading: provider.loginLoading ? true : false,
        onPress: onPress,
      );
    });
  }
}

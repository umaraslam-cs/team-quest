import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/view_model/auth/auth_view_model.dart';

import '../../../configs/utils.dart';

class InputEmailWidget extends StatelessWidget {
  final FocusNode focusNode, passwordFocusNode;
  const InputEmailWidget(
      {Key? key, required this.focusNode, required this.passwordFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, provider, child) {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: focusNode,
        decoration: const InputDecoration(
          hintText: 'Andrew.john@yourdomain.com',
          hintStyle: TextStyle(fontSize: 14),
          labelStyle: TextStyle(
              fontSize: 16,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onFieldSubmitted: (value) {
          Utils.fieldFocusChange(context, focusNode, passwordFocusNode);
        },
        onChanged: (value) {
          provider.setEmail(value);
        },
      );
    });
  }
}

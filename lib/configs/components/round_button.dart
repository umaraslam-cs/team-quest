import 'package:flutter/material.dart';
import '../color/color.dart';

//custom round button component, we will used this widget show to show button
// this widget is generic, we can change it and this change will appear across the app
class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const RoundButton({
    Key? key,
    required this.title,
    this.loading = false,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(90)),
        child: Center(
            child: loading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.whiteColor,
                    strokeWidth: 1.4,
                  )
                : Text(
                    title,
                    style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )),
      ),
    );
  }
}

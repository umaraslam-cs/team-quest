
import 'package:flutter/material.dart';

class RoundedOutlineButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedOutlineButtonWithImage({
    Key? key,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        side: BorderSide(width: 0.8, color: Colors.grey.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      onPressed: onPressed,
      child: Center(
        child: Image.asset(
          imagePath,
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}

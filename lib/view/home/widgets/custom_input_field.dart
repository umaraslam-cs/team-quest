import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText, labelText;
  final TextEditingController controller;
  final int? maxLines;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

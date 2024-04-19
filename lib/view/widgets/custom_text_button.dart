import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;

  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.color,
    this.fontSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? const Color(0xFF329494),
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

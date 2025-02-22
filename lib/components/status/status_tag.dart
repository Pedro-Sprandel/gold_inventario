import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isSmall;

  const StatusTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return isSmall
        ? Container(
            padding: text.isNotEmpty
                ? const EdgeInsets.symmetric(horizontal: 6, vertical: 3)
                : const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24)),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : Container(
            padding: text.isNotEmpty
                ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                : const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24)),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }
}

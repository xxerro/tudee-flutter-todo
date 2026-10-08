import 'package:flutter/material.dart';

class TextStartWidget extends StatelessWidget {
  final String text_s;
  const TextStartWidget({super.key, required this.text_s});

  @override
  Widget build(BuildContext context) {
    return Text(
      text_s,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}

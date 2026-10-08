import 'package:flutter/material.dart';

class LogInWidget extends StatelessWidget {
  final String name;

  const LogInWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

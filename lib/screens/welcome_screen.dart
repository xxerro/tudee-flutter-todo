import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tudee/screens/home_screen.dart';
import 'package:tudee/widgets/field_text_widget.dart';
import 'package:tudee/widgets/log_in_widget.dart';
import 'package:tudee/widgets/text_start_widget.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tudee",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "cherrybomb",
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextStartWidget(text_s: "Let's get started"),
            SizedBox(height: 26),
            Text(
              "What should we call you?",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            FieldTextWidget(name: "Your name", nameController: nameController),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                await prefs.setString('name', nameController.text);

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: LogInWidget(name: "Save"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tudee/widgets/field_text_widget.dart';
import 'package:tudee/widgets/log_in_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tudee/Haiv_servies/Todo.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskController = TextEditingController();

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
            const Text(
              "Add Task ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 35),
            FieldTextWidget(
              name: "What needs to be done?",
              nameController: taskController,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final box = Hive.box<Todo>('tasksBox');
                final todo = Todo(title: taskController.text);
                await box.add(todo);
                Navigator.pop(context);
              },

              child: const LogInWidget(name: "Save"),
            ),
          ],
        ),
      ),
    );
  }
}

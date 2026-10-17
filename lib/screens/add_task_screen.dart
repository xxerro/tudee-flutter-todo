import 'package:flutter/material.dart';
import 'package:tudee/services/todo_service.dart';
import 'package:tudee/widgets/field_text_widget.dart';
import 'package:tudee/widgets/log_in_widget.dart';
import 'package:tudee/services/Todo.dart';

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
                final title = taskController.text.trim();

                if (title.isEmpty) return;

                try {
                  final todo = Todo(title: title);

                  await TodoService().addTodo(todo);

                  if (!mounted) return;

                  Navigator.pop(context, true);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save task: $e')),
                  );
                }
              },

              child: const LogInWidget(name: "Save"),
            ),
          ],
        ),
      ),
    );
  }
}

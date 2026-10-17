import 'package:flutter/material.dart';
import 'package:tudee/services/todo_service.dart';
import 'package:tudee/widgets/log_in_widget.dart';
import 'package:tudee/services/Todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditTaskScreen extends StatefulWidget {
  final Todo todo;
  final dynamic taskKey;

  const EditTaskScreen({super.key, required this.todo, required this.taskKey});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController taskController = TextEditingController();
  @override
  void initState() {
    super.initState();

    taskController.text = widget.todo.title;
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit Task",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
                  },
                ),
              ],
            ),
            const SizedBox(height: 35),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: "What needs to be done?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 23),

            InkWell(
              onTap: () async {
                final title = taskController.text.trim();

                if (title.isEmpty) return;

                final updatedTodo = Todo(
                  id: widget.todo.id,
                  title: title,
                  isComplete: widget.todo.isComplete,
                );

                try {
                  await TodoService().updateTodo(updatedTodo);

                  if (!mounted) return;
                  Navigator.pop(context, true);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update task: $e')),
                  );
                }
              },

              child: LogInWidget(name: "Save changes"),
            ),
          ],
        ),
      ),
    );
  }
}

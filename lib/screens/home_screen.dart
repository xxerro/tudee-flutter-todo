import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tudee/Haiv_servies/Todo.dart';
import 'package:tudee/screens/add_task_screen.dart';
import 'package:tudee/screens/edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _loadName();
    _loadTodos();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? '';
    });
  }

  void _loadTodos() {
    final box = Hive.box<Todo>('tasksBox');

    setState(() {
      todos = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = todos.where((todo) => todo.isComplete).length;

    final pendingCount = todos.where((todo) => !todo.isComplete).length;

    return Scaffold(
      backgroundColor: Colors.grey[200],

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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

        child: Column(
          children: [
            // =========================
            // Statistics
            // =========================
            Container(
              height: 163,
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Welcome $name",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: Row(
                      children: [
                        // Completed
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),

                                Text(
                                  completedCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                const Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Pending
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.pending_actions_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),

                                Text(
                                  pendingCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                const Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // =========================
            // Tasks Area
            // =========================
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),

                child: todos.isEmpty
                    // Empty state
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              "No tasks for today!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Add a task to get started.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    // Tasks list
                    : ListView.builder(
                        itemCount: todos.length,

                        itemBuilder: (context, index) {
                          final todo = todos[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),

                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F0FA),

                              borderRadius: BorderRadius.circular(14),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),

                                  blurRadius: 4,

                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),

                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),

                              // =========================
                              // Edit Task
                              // =========================
                              onTap: () async {
                                final box = Hive.box<Todo>('tasksBox');

                                final key = box.keyAt(index);

                                await Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(
                                      todo: todo,
                                      taskKey: key,
                                    ),
                                  ),
                                );

                                _loadTodos();
                              },

                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 2,
                                ),

                                // Task title
                                title: Text(
                                  todo.title,

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,

                                    decoration: todo.isComplete
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,

                                    color: todo.isComplete
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),

                                // Checkbox + Delete
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    // Checkbox
                                    Checkbox(
                                      value: todo.isComplete,

                                      onChanged: (value) async {
                                        final newValue = value ?? false;

                                        final updatedTodo = Todo(
                                          title: todo.title,
                                          isComplete: newValue,
                                        );

                                        final box = Hive.box<Todo>('tasksBox');

                                        final key = box.keyAt(index);

                                        await box.put(key, updatedTodo);

                                        setState(() {
                                          todos[index] = updatedTodo;
                                        });
                                      },
                                    ),

                                    // Delete
                                    IconButton(
                                      icon: const Icon(Icons.delete),

                                      onPressed: () async {
                                        final box = Hive.box<Todo>('tasksBox');

                                        final key = box.keyAt(index);

                                        await box.delete(key);

                                        setState(() {
                                          todos.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // Add Task Button
            // =========================
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTask()),
            );

            _loadTodos();
          },

          backgroundColor: Colors.blue,

          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

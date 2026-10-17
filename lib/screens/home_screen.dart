import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tudee/services/Todo.dart';
import 'package:tudee/screens/add_task_screen.dart';
import 'package:tudee/screens/edit_task_screen.dart';
import 'package:tudee/services/todo_service.dart';

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

  // void _loadTodos() {
  //   // final box = Hive.box<Todo>('tasksBox');

  //   // setState(() {
  //   //   todos = box.values.toList();
  //   // });
  //   // Temporarily disabled while migrating to Firebase.
  // }

  Future<void> _loadTodos() async {
    try {
      final loadedTodos = await TodoService().getTodos();

      if (!mounted) return;

      setState(() {
        todos = loadedTodos;
      });
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
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

            ElevatedButton(
              onPressed: () async {
                try {
                  final service = TodoService();
                  await service.testAddTodo();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully!')),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Test Firebase'),
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
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(
                                      todo: todo,
                                      taskKey: null,
                                    ),
                                  ),
                                );

                                if (!mounted) return;
                                await _loadTodos();
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
                                        final updatedTodo = Todo(
                                          id: todo.id,
                                          title: todo.title,
                                          isComplete: value ?? false,
                                        );

                                        try {
                                          await TodoService().updateTodo(
                                            updatedTodo,
                                          );
                                          await _loadTodos();
                                        } catch (e) {
                                          debugPrint('Error updating task: $e');
                                        }
                                      },
                                    ),

                                    // Delete
                                    IconButton(
                                      icon: const Icon(Icons.delete),

                                      onPressed: () async {
                                        final id = todo.id;
                                        if (id == null) return;

                                        try {
                                          await TodoService().deleteTodo(id);
                                          await _loadTodos();
                                        } catch (e) {
                                          debugPrint('Error deleting task: $e');
                                        }
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

            if (!mounted) return;
            await _loadTodos();
          },

          backgroundColor: Colors.blue,

          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

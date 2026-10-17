import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:tudee/Haiv_servies/Todo.dart';
// import 'package:tudee/Haiv_servies/todo_adapter.dart';
import 'package:tudee/screens/add_task_screen.dart';
import 'package:tudee/screens/home_screen.dart';
import 'package:tudee/screens/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // Hive.registerAdapter(TodoAdapter());
  // await Hive.openBox<Todo>('tasksBox');
  // await Hive.openBox('settingsBox');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => Welcome(),
        '/add_task': (context) => AddTask(),
        '/home': (context) => HomeScreen(),
        // '/edit_task': (context) => EditTaskScreen(todo: Todo, taskKey: taskKey);
      },
    );
  }
}

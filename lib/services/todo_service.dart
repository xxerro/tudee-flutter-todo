import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tudee/services/Todo.dart';

class TodoService {
  final CollectionReference<Map<String, dynamic>> _todos = FirebaseFirestore
      .instance
      .collection('todos');

  Future<String> addTodo(Todo todo) async {
    final docRef = await _todos.add(todo.toMap());
    return docRef.id;
  }

  Future<void> testAddTodo() async {
    try {
      final todo = Todo(title: 'My first Firebase task');

      print('Firebase project: ${Firebase.app().options.projectId}');

      final id = await addTodo(todo);

      print('Task added successfully!');
      print('Document ID: $id');

      final doc = await _todos.doc(id).get();
      print('Document exists: ${doc.exists}');
      print('Document data: ${doc.data()}');
    } catch (e, stackTrace) {
      print('Failed to add task: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<List<Todo>> getTodos() async {
    final snapshot = await _todos.get();

    return snapshot.docs.map((doc) {
      return Todo.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Future<void> updateTodo(Todo todo) async {
    if (todo.id == null) {
      throw Exception('Todo ID is missing');
    }

    await _todos.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await _todos.doc(id).delete();
  }
}

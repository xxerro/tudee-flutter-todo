import 'package:hive_flutter/hive_flutter.dart';
import 'Todo.dart';

class HiveService {
  static const String boxName = 'task';

  /// تهيئة Hive وفتح الصندوق
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// الحصول على مرجع الـ Box المفتوح
  Box get box => Hive.box(boxName);

  /// إضافة مهمة جديدة
  Future<void> addTask(Todo todo) async {
    await box.add({'title': todo.title, 'isComplete': todo.isComplete});
  }

  /// جلب جميع المهام
  List<Todo> getTasks() {
    final List<Todo> tasks = [];

    for (int i = 0; i < box.length; i++) {
      final rawData = box.getAt(i);
      if (rawData != null) {
        // تحويل النمط بآمان لحماية التطبيق من Crash
        final taskData = Map<String, dynamic>.from(rawData as Map);

        tasks.add(
          Todo(
            title: taskData['title'] ?? '',
            isComplete: taskData['isComplete'] ?? false,
          ),
        );
      }
    }

    return tasks;
  }

  /// تحديث حالة المهمة (تغيير إكمال المهمة)
  Future<void> updateTaskStatus(int index, bool isComplete) async {
    final rawData = box.getAt(index);
    if (rawData != null) {
      final taskData = Map<String, dynamic>.from(rawData as Map);
      taskData['isComplete'] = isComplete;
      await box.putAt(index, taskData);
    }
  }

  /// حذف مهمة محددة عبر الـ Index
  Future<void> deleteTask(int index) async {
    await box.deleteAt(index);
  }

  /// حذف جميع المهام
  Future<void> clearAll() async {
    await box.clear();
  }
}

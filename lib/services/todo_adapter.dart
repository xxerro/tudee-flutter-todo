import 'package:hive/hive.dart';

import 'Todo.dart';

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final title = reader.readString();
    final isComplete = reader.readBool();

    return Todo(title: title, isComplete: isComplete);
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.writeString(obj.title);
    writer.writeBool(obj.isComplete);
  }
}

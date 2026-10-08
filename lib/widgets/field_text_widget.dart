import 'package:flutter/material.dart';

class FieldTextWidget extends StatefulWidget {
  final String name;
  final TextEditingController nameController;
  FieldTextWidget({
    super.key,
    required this.name,
    required this.nameController,
  });

  @override
  State<FieldTextWidget> createState() => _FieldTextWidgetState();
}

class _FieldTextWidgetState extends State<FieldTextWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.nameController,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),

      // 2. تغيير ستايل إطار وشكل الحقل
      decoration: InputDecoration(
        hintText: widget.name, // النص التوضيحي
        hintStyle: TextStyle(color: Colors.grey), // ستايل النص التوضيحي

        filled: true,
        fillColor: Colors.grey[100], // لون خلفية الحقل

        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),

        // الحدود عند ضغط المستخدم داخل الحقل (Focus)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),

        // الحدود في حال وجود خطأ (إذا كنت تستخدم TextFormField)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

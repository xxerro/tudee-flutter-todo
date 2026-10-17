class Todo {
  final String? id;
  final String title;
  final bool isComplete;

  Todo({this.id, required this.title, this.isComplete = false});

  // Convert Todo object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {'title': title, 'isComplete': isComplete};
  }

  // Create a Todo object from Firestore data
  factory Todo.fromMap(Map<String, dynamic> map, String documentId) {
    return Todo(
      id: documentId,
      title: map['title'] as String,
      isComplete: map['isComplete'] as bool? ?? false,
    );
  }
}

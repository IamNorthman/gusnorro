import 'dart:ffi';

class Todo {
  final String title;
  bool done;

  Todo(this.title, this.done);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['title'], json['done'] ?? false);
  }
}

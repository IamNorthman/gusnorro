/*import 'dart:convert';
import 'package:http/http.dart' as http;
import './models.dart';

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

class Todo {
  final String id;
  final String title;
  final String done;

  Todo(this.id, this.title, this.done);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['id'], json['title'], json['done']);
  }
}

Future<List<Todo>> getTodo() async {
  http.Response response = await http.get(
      Uri.parse('$ENDPOINT/todos?key=b8dd8852-87e6-48ee-b08e-f7733f28df09'));
  String body = response.body;
  Map<String, dynamic> jsonResponse = jsonDecode(body);
  List todoJson = jsonResponse['todos'];
  return todoJson.map((json) => Todo.fromJson(json)).toList();
}

Future<void> addTodo(Todo todo) async {
  await http.post(
    Uri.parse('$ENDPOINT/todos?key=b8dd8852-87e6-48ee-b08e-f7733f28df09'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(todo.toJson()),
  );
}
*/
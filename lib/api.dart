/*import 'dart:convert';
import 'package:http/http.dart' as http;
import './models.dart';

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

Future<List<Todo>> getTodo() async {
  http.Response response = await http.get(
      Uri.parse('$ENDPOINT/todos?key=b8dd8852-87e6-48ee-b08e-f7733f28df09'));
  String body = response.body;
  Map<String, dynamic> jsonResponse = jsonDecode(body);
  List todoJson = jsonResponse['todos'];
  return todoJson.map((json) => Todo.fromJson(json)).toList();
}

Future<void> addTodo(Todo todo) async {
  // ignore: unused_local_variable
  http.Response response = await http.post(
    Uri.parse('$ENDPOINT/todos?key=b8dd8852-87e6-48ee-b08e-f7733f28df09'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(todo.toJson()),
  );
}
*/
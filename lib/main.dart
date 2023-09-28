import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//API endpoint
const String API_ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

//Start the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'To-Do App',
        home: MyHomePage(),
      ),
    ),
  );
}

//Build main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
      ),
      body: TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTodoDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

//Build the to dos
class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return ListView.builder(
          itemCount: todoProvider.todos.length,
          itemBuilder: (context, index) {
            final todo = todoProvider.todos[index];
            return ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) {
                  todoProvider.toggleTodoStatus(index);
                },
              ),
              title: Text(todo.title),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  todoProvider.removeTodo(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}

//Dialog window to add to do
class AddTodoDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a To-Do'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter your to-do',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newTodoTitle = _controller.text;
            if (newTodoTitle.isNotEmpty) {
              context.read<TodoProvider>().addTodo(Todo(title: newTodoTitle));
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

//Creating providers to access
class Todo {
  final String id;
  final String title;
  bool done;

  Todo(
      {required this.title,
      this.done = false,
      this.id = 'dc0c1faf-887c-4816-b6f8-e699b12e8c8f'});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 'dc0c1faf-887c-4816-b6f8-e699b12e8c8fe',
      title: json['title'],
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
    };
  }
}

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    http.Response response = await http.get(Uri.parse(
        '$API_ENDPOINT/todos?key=dc0c1faf-887c-4816-b6f8-e699b12e8c8f'));
    String body = response.body;

    Map<String, dynamic> jsonResponse = jsonDecode(body);
    List todosJson = jsonResponse['todos'];
    return todosJson.map((json) => Todo.fromJson(json)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('$API_ENDPOINT/todos'),
      headers: {"Content-Type": "application/json", 'Charset': 'utf-8'},
      body: json.encode(todo.toJson()),
    );
    fetchTodos();
  }

  Future<void> removeTodo(int index) async {
    final todo = _todos[index];
    final response = await http.delete(
      Uri.parse('$API_ENDPOINT'),
    );
    fetchTodos();
  }

  void toggleTodoStatus(int index) {
    _todos[index].done = !_todos[index].done;
    notifyListeners();
  }
}

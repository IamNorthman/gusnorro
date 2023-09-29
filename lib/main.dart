import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//variable for the API url
final Uri $ENDPOINT = Uri.parse(
    'https://todoapp-api.apps.k8s.gu.se/todos?key=337ea463-c7eb-4899-a047-160e113d2fbb');

void main() => runApp(MyApp());

class Todo {
  final String id;
  final String title;
  bool done;

  Todo({
    required this.id,
    required this.title,
    required this.done,
  });
}

//to get the app running
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

//Adding an enum filter
enum TodoFilter { All, Done, NotDone }

//Creating class to handle the to dos and list of them
class _TodoListState extends State<TodoList> {
  late List<Todo> todos;
  TodoFilter filter = TodoFilter.All;

  @override
  void initState() {
    super.initState();
    todos = [];
    fetchData();
  }

  //Fetching todos
  Future<void> fetchData() async {
    final response = await http.get($ENDPOINT);
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      todos = responseData
          .map((data) => Todo(
                id: data["id"],
                title: data["title"],
                done: data["done"],
              ))
          .toList();
    });
  }

  //Function to be able to add new to do to both app and API
  Future<void> addTodo(String title) async {
    final response = await http.post(
      $ENDPOINT,
      body: json.encode({"title": title, "done": false}),
      headers: {"Content-Type": "application/json"},
    );
    fetchData();
  }

  //Function to delete todo
  Future<void> deleteTodo(String id) async {
    final String endpoint =
        'https://todoapp-api.apps.k8s.gu.se/todos/$id?key=337ea463-c7eb-4899-a047-160e113d2fbb';

    final response = await http.delete(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
      },
    );
    todos.removeWhere((todo) => todo.id == id);
    setState(() {});
  }

  //Function to update the status on the to do so when checkbox is checked it updates "done" in the API as well
  Future<void> updateTodoStatus(String id, String title, bool done) async {
    final String endpoint =
        'https://todoapp-api.apps.k8s.gu.se/todos/$id?key=337ea463-c7eb-4899-a047-160e113d2fbb';

    await http.put(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"id": id, "title": title, "done": done}),
    );

    print('Todo status updated successfully');
  }

  //Function to be able to filter the to dos
  List<Todo> getFilteredTodos() {
    switch (filter) {
      case TodoFilter.Done:
        return todos.where((todo) => todo.done).toList();
      case TodoFilter.NotDone:
        return todos.where((todo) => !todo.done).toList();
      default:
        return todos;
    }
  }

  //Building the UI for the app
  @override
  Widget build(BuildContext context) {
    final TextEditingController todoController = TextEditingController();
    List<Todo> filteredTodos = getFilteredTodos();
    return Scaffold(
      appBar: AppBar(
        title: Text('To do'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = TodoFilter.All;
                  });
                },
                child: Text('All'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = TodoFilter.Done;
                  });
                },
                child: Text('Done'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = TodoFilter.NotDone;
                  });
                },
                child: Text('Not Done'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.done,
                    onChanged: (bool? value) {
                      setState(() {
                        todo.done = value ?? false;
                        updateTodoStatus(todo.id, todo.title, todo.done);
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('New Todo'),
                content: TextField(
                  controller: todoController,
                  decoration:
                      InputDecoration(hintText: 'Enter what you need to do'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      var todoTitle = todoController.text;
                      addTodo(todoTitle);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

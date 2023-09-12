import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 0, 96, 223),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

//Innehållet på To Do list sidan
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('To do'),
        ),
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            _toDoItems('Gör en to do lista'),
            _toDoItems('Lägg in saker i to do'),
            _toDoItems('Great success'),
            ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.add,
                    color: Color.fromARGB(255, 81, 177, 255), size: 42.0))
          ],
        ));
  }
}

//Widget till att göra en ny To Do punkt
Widget _toDoItems(String toDo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.square_outlined,
          color: Color.fromARGB(255, 81, 177, 255), size: 42.0),
      Expanded(child: Text(toDo, style: TextStyle(fontSize: 24))),
      Icon(Icons.close,
          color: const Color.fromARGB(255, 81, 177, 255), size: 42),
      Padding(padding: EdgeInsets.symmetric(vertical: 40))
    ],
  );
}

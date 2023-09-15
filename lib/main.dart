import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/Extras/Tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//Build the start of the app
class _MyAppState extends State<MyApp> {
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

//Build the ground of homepage
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List toDoList = [
    ['Testing', false]
  ];

  //To be able to change the state of the checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  //Function to create a new to do post
  void saveNewToDO() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  //Function to delete selected to do post via the slider
  void deleteToDo(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  //Text controller
  final _controller = TextEditingController();

  //Building the dialog pop out when adding a new to do
  void newToDo() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 200,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        fillColor: Colors.blueGrey,
                        hintText: 'Add your to do'),
                  ),
                  MaterialButton(
                      onPressed: saveNewToDO,
                      color: Color.fromARGB(255, 0, 65, 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.only(
                          left: 80, right: 80, top: 10, bottom: 10),
                      child: Text('Add')),
                ],
              ),
            ),
          );
        });
  }

  //Building the UI of to do's that is on the list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('To do'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: newToDo,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return ToDoBlock(
              toDoName: toDoList[index][0],
              toDoDone: toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteToDo: (context) => deleteToDo(index),
            );
          },
        ));
  }
}

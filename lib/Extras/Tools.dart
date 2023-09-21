import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoBlock extends StatelessWidget {
  final String toDoName;
  final bool toDoDone;
  Function(bool?)? onChanged;

  Function(BuildContext)? deleteToDo;

  ToDoBlock(
      {super.key,
      required this.toDoName,
      required this.toDoDone,
      required this.onChanged,
      required this.deleteToDo});

  //Build each container that holds every to do
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: (EdgeInsets.only(left: 10, right: 10, top: 20)),
        child: Slidable(
            endActionPane: ActionPane(motion: StretchMotion(), children: [
              SlidableAction(
                onPressed: deleteToDo,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(30),
              )
            ]),
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 53, 53, 53),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Checkbox(value: toDoDone, onChanged: onChanged),
                  Text(
                    toDoName,
                    style: TextStyle(
                        fontSize: 24,
                        decoration: toDoDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ],
              ),
            )));
  }
}

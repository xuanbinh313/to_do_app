import 'package:flutter/material.dart';
import 'package:todolist/Database/database.dart';
import 'package:todolist/Models/task.dart';
import 'package:todolist/Screens/add_screen.dart';

class MainScreen extends StatefulWidget {
  static const id = 'main_screen';

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Task> taskList = [];

  Future getTasks() async {
    final db = DatabaseTask();
    taskList = await db.getDB();
    setState(() {});
  }

  Future deleteTask(int id) async {
    final db = DatabaseTask();
    await db.deleteDB(id);
    taskList = await db.getDB();
//    getTasks();
    setState(() {});
  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO APP'),
      ),
      body: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, position) {
            return ListTile(
              title: Text(taskList[position].name),
              subtitle: Text(taskList[position].description),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('Delete'),
                    )
                  ];
                },
                onSelected: (i) async {
                  if (i == 0) {
                    final _result = await Navigator.pushNamed(
                        context, AddTask.id,
                        arguments: taskList[position]);
                    if (_result == true) getTasks();
                  } else if (i == 1) {
                    //Hiện Dialog
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm you deletion'),
                            content: Text('Are you sure to delete this task?'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('CANCEL'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  deleteTask(taskList[position].id);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final _result = await Navigator.pushNamed(context, AddTask.id);
          if (_result == true) getTasks();
        },
      ),
    );
  }
}

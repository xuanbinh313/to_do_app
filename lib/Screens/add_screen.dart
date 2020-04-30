import 'package:flutter/material.dart';
import 'package:todolist/Database/database.dart';
import 'package:todolist/Models/task.dart';

class AddTask extends StatefulWidget {
  static const id = 'add_screen';

  final Task task;

  AddTask(this.task);

  @override
  State<StatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  final _ctrName = TextEditingController();
  final _ctrDesc = TextEditingController();
  bool _inSync = false;
  String _errorText;

  @override
  void initState() {
    Task task = widget.task;
    //Nếu có task truyền vào thì đó là update
    if (task != null) {
      _ctrName.text = task.name;
      _ctrDesc.text = task.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: !_inSync
                ? () {
                    Navigator.pop(context);
                  }
                : null),
        title: Text('add or edit'),
        actions: <Widget>[
          !_inSync
              ? IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    widget.task == null ? _addTask() : _updateTask();
                  },
                )
              : Icon(Icons.refresh),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: 'Please enter name task here',
                  labelText: 'Name:',
                  errorText: _errorText),
              controller: _ctrName,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Please add more info about your task',
                labelText: 'Description:',
              ),
              controller: _ctrDesc,
            )
          ],
        ),
      ),
    );
  }

  void _addTask() async {
    //check name co trống hay ko
    if (_ctrName.text.isEmpty) {
      setState(() {
        _errorText = 'Please enter Task here!!!!';
      });
      return;
    }
    setState(() {
      _errorText = null;
      _inSync = true;
    });

    final db = DatabaseTask();
    final task =
        Task(name: _ctrName.text.trim(), description: _ctrDesc.text.trim());
    //them dữ liệu vào database
    await db.insertDB(task);

    setState(() {
      _inSync = false;
    });
    //Trở về màn hình chính với giá trị true để update lại dữ liệu từ Database
    Navigator.pop(context, true);
  }

  void _updateTask() async {
    if (_ctrName.text.isEmpty) {
      setState(() {
        _errorText = 'Please enter Task here!!!!';
      });
      return;
    }
    setState(() {
      _inSync = true;
      _errorText = null;
    });
    final db = DatabaseTask();
    final task =
        Task(name: _ctrName.text.trim(), description: _ctrDesc.text.trim());
    await db.updateDB(task);

    setState(() {
      _inSync = false;
    });
    Navigator.pop(context, true);
  }
}

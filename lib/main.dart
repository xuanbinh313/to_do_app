import 'package:flutter/material.dart';
import 'package:todolist/Screens/main_screen.dart';
import 'Models/task.dart';
import 'Screens/add_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id : (context) => MainScreen(),
      },
      onGenerateRoute: (settings){
        if (settings.name == AddTask.id){
          return MaterialPageRoute(
            builder: (context){
              if(settings.arguments != null){
                Task task = settings.arguments;
                return AddTask(task);
              }
              return AddTask(null);
            }
          );
        }
        return null;
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tabsName = ["New Tasks", "Done Tasks", "Archived Tasks"];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  int currentPosition = 0;
  Database? database = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabsName[currentPosition],
          style: TextStyle(color: Colors.white),
        ),
        elevation: 25,
        backgroundColor: Colors.amberAccent,
      ),
      body: screens[currentPosition],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          createDatabase();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: tabsName[0]),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
              ),
              label: tabsName[1]),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive_outlined,
              ),
              label: tabsName[2]),
        ],
        onTap: (value) {
          setState(() {
            currentPosition = value;
          });
        },
        currentIndex: currentPosition,
      ),
    );
  }

  void createDatabase() async {
// open the database
    database = await openDatabase("todo.db",
        version: 1,
        onCreate: (Database database, int version) async {
          print("database created");
          // When creating the db, create the table
          await database.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT , status TEXT)').then((value) =>
          print("TABLE created"));
        },
        onOpen: (db) {
          print("database opened");
        },
        );
  }

  void insetRowIntoDatabase(){

  }

  void deleteRowFromDatabase(){

  }

  void updateRowInDatabase(){

  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks_screen.dart';
import 'package:todo/shared/components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tabsName = ["New Tasks", "Done Tasks", "Archived Tasks"];

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];

  int currentPosition = 0;
  Database? database ;
  bool isBottomSheetOpen = false;
  IconData floatIcon = Icons.edit;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var date = '';
  var time = '';

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        onPressed: () {
          if (isBottomSheetOpen) {
            if (formKey.currentState?.validate() == true) {
              insetRowIntoDatabase(titleController.text.toString(),time,date,"new").then((value){
                Navigator.pop(context);
                isBottomSheetOpen = false;
                setState(() {
                  floatIcon = Icons.edit;
                });
              });

            }
          } else {
            scaffoldKey.currentState?.showBottomSheet(
                (context) => createAddNewTaskBottomSheet(context),
                backgroundColor: Colors.white,
            elevation: 1.0,);
            isBottomSheetOpen = true;
            setState(() {
              floatIcon = Icons.add;
            });
          }
        },
        child: Icon(floatIcon),
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
    database = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (Database database, int version) async {
        print("database created");
        // When creating the db, create the table
        await database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT , status TEXT)')
            .then((value) => print("TABLE created"));
      },
      onOpen: (db) {
        print("database opened");
      },
    );
  }

  Future<void> insetRowIntoDatabase(String title, String time, String date,String status) async {
    await database?.transaction((txn) => txn.rawInsert(
      'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date","$status")'
    )).then((value) {
      print("row $value inserted successfully");
    }).catchError(
     (error){
       print('Error when inset row ${error.toString()}');
     }
    );
  }

  void deleteRowFromDatabase() {}

  void updateRowInDatabase() {}

  Widget createAddNewTaskBottomSheet(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add new Task",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextFormField(
                controller: titleController,
                labelText: "Title",
                prefixIcon: Icon(Icons.title),
                type: TextInputType.text,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Must enter Title";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              defaultTextFormField(
                  controller: timeController,
                  labelText: "Time",
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  type: TextInputType.datetime,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Must enter Time";
                    } else {
                      return null;
                    }
                  },
                  onTab: () {
                    showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      timeController.text = value!.format(context).toString();
                      time = value.format(context).toString();
                    });
                  },
                  isReadOnly: true),
              const SizedBox(
                height: 15,
              ),
              defaultTextFormField(
                  controller: dateController,
                  labelText: "Date",
                  prefixIcon: const Icon(Icons.date_range_outlined),
                  type: TextInputType.datetime,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Must enter Date";
                    } else {
                      return null;
                    }
                  },
                  onTab: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse("2024-12-12"))
                        .then((value) {
                      date = DateFormat.yMMMd().format(value!);
                      dateController.text = DateFormat.yMMMd().format(value);
                    });
                  },
                  isReadOnly: true),
            ],
          ),
        ),
      ),
    );
  }
}

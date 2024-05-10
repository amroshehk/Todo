import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks_screen.dart';
import 'package:todo/shared/components/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(IntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentPosition = 0;

  List<String> tabsName = ["New Tasks", "Done Tasks", "Archived Tasks"];

  List<Widget> screens = [
    NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];

  void changeBottomNavigationTab(currentPosition){
    this.currentPosition = currentPosition;
    emit(AppBottomNavigationState());
  }

  bool isBottomSheetOpen = false;
  IconData floatIcon = Icons.edit;

  void changeBottomSheetState(isBottomSheetOpen,floatIcon){
    this.isBottomSheetOpen = isBottomSheetOpen;
    this.floatIcon = floatIcon;
    emit(AppChangeBottomSheetState());
  }

  Database? database ;

  void createDatabase() {
// open the database
    openDatabase(
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
        emit(AppDatabaseLoaderDataState());
        getDataFromDatabase(db).then((value) =>
            emit(GetDataFromDatabaseState()));
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  void insetRowIntoDatabase(String title, String time, String date,String status) {
    database?.transaction((txn) => txn.rawInsert(
        'INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date","$status")'
    )).then((value) {
      print("row $value inserted successfully");
      emit(InsetRowIntoDatabaseState());
      emit(AppDatabaseLoaderDataState());
      getDataFromDatabase(database).then((value) =>
          emit(GetDataFromDatabaseState()));
    }).catchError(
            (error){
          print('Error when inset row ${error.toString()}');
        }
    );
  }

  List<Map> tasks = [];

  Future<void> getDataFromDatabase(database) async {
    tasks = await database?.rawQuery('SELECT * from Tasks');
    print(tasks);
  }

}
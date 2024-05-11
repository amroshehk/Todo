import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/Archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/cubit.dart';
import 'package:todo/shared/components/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});




  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var date = '';
  var time = '';

  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) { return AppCubit()..createDatabase(); },
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {

          if(state is InsetRowIntoDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder:(context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.tabsName[cubit.currentPosition],
                style: TextStyle(color: Colors.white),
              ),
              elevation: 25,
              backgroundColor: Colors.amberAccent,
            ),
            body: ConditionalBuilder(
              condition:state is! AppDatabaseLoaderDataState,
              builder: (context) => cubit.screens[cubit.currentPosition],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetOpen) {
                  if (formKey.currentState?.validate() == true) {
                    cubit.insetRowIntoDatabase(titleController.text.toString(),time,date,Status.newTask.name);
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => createAddNewTaskBottomSheet(context),
                    backgroundColor: Colors.white,
                    elevation: 1.0,).closed.then((value){
                    cubit.changeBottomSheetState(false,Icons.edit);
                  });
                  cubit.changeBottomSheetState(true,Icons.add);
                }
              },
              child: Icon(cubit.floatIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: cubit.tabsName[0]),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: cubit.tabsName[1]),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: cubit.tabsName[2]),
              ],
              onTap: (value) {
                // setState(() {
                cubit.changeBottomNavigationTab(value);
                // });
              },
              currentIndex: cubit.currentPosition,
            ),
          );
        }   ,
      ),
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

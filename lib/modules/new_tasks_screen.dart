import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
      return taskItem(tasks[index]);
    }, separatorBuilder: (context, index) =>
     Padding(
       padding: const  EdgeInsetsDirectional.only(start: 20.0),
       child: Container(
          color: Colors.yellow,
         child: SizedBox(
           width: double.infinity,
           height: 1,
         ),
        ),
     )
    , itemCount: tasks.length);
  }
}

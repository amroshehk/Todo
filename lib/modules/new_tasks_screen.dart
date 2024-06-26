import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/cubit.dart';
import 'package:todo/shared/components/states.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state) {  },

      builder: (BuildContext context, AppStates state) {
        var task = AppCubit.get(context).tasksNew;
        return taskBuilder(task,messageNoTask);
      },
    );
  }
}

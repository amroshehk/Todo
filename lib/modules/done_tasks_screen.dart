import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/cubit.dart';
import 'package:todo/shared/components/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state) {  },

      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return ListView.separated(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return taskItem(cubit.tasksDone[index],context);
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
            , itemCount: cubit.tasksDone.length);
      },
    );
  }
}

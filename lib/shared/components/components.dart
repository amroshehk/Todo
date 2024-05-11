import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/shared/components/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'constants.dart';

Widget defaultButton({
  required String title,
  Color color = Colors.indigoAccent,
  double radius = 10.0,
  required VoidCallback function,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      height: 46,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          "$title",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextFormField(
        {required TextEditingController controller,
        required String labelText,
        required Icon prefixIcon,
        IconButton? suffixIcon = null,
        bool obscureText = false,
        bool isReadOnly = false,
        required TextInputType type,
        required FormFieldValidator validator,
        GestureTapCallback? onTab}) =>
    TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon),
      keyboardType: type,
      onTap: onTab,
      readOnly: isReadOnly,
    );

Widget taskItem(Map task, BuildContext context) {
  return Dismissible(
    key: Key(task['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.amber,
            child: Text(
              "${task["time"]}",
              style: const TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                      "${task["title"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateDataInDatabase(
                                Status.done.name, task["id"]);
                          },
                          icon: const Icon(
                            Icons.check_box,
                            size: 25,
                            color: CupertinoColors.activeGreen,
                          )),
                    ),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).updateDataInDatabase(
                                Status.archive.name, task["id"]);
                          },
                          icon: const Icon(
                            Icons.archive_outlined,
                            color: CupertinoColors.darkBackgroundGray,
                          )),
                    ),
                  ],
                ),
                Container(
                    width: double.infinity,
                    child: Text("${task["date"]}",
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis)))
              ],
            ),
          )
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).removeDataInDatabase(context, task['id']);
    },
  );
}

Widget taskBuilder(List<Map> task, String messageNoTask) {
  return ConditionalBuilder(
    condition: task.isNotEmpty,
    builder: (context) => ListView.separated(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return taskItem(task[index], context);
        },
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20.0),
              child: Container(
                color: Colors.yellow,
                child: SizedBox(
                  width: double.infinity,
                  height: 1,
                ),
              ),
            ),
        itemCount: task.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              messageNoTask,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

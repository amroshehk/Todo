
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/shared/components/cubit.dart';

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
          prefixIcon: prefixIcon
          ,
          suffixIcon:suffixIcon),
      keyboardType: type,
      onTap: onTab,
      readOnly: isReadOnly,

    );

Widget taskItem(Map task,BuildContext context ){
  return  Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(child: Text("${task["time"]}",style: TextStyle(fontSize:15,color: Colors.white),),radius: 45,backgroundColor: Colors.amber,),
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                       child: Text("${task["title"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,),)),
                    Container(
                      child: IconButton(onPressed:() {
                        AppCubit.get(context).updateDataInDatabase(Status.done.name, task["id"]);
                      }, icon: Icon(Icons.done_outline,color: CupertinoColors.activeGreen,)),
                    ),
                    Container(
                      child: IconButton(onPressed: () {
                        AppCubit.get(context).updateDataInDatabase(Status.archive.name, task["id"]);
                      }, icon: Icon(Icons.archive_outlined,color: CupertinoColors.quaternaryLabel,)),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.max,
                ),
              ),
              Container(
                  width: double.infinity,
                  child: Text("${task["date"]}", maxLines: 1,style: TextStyle(fontWeight: FontWeight.w400,fontSize:15,color: Colors.grey, overflow: TextOverflow.ellipsis)))
            ],
          ),
        )
      ],
    ),
  );
}


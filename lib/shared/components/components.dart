
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Widget taskItem(Map task){
  return  Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      children: [
        CircleAvatar(child: Text("${task["time"]}",style: TextStyle(fontSize:15,color: Colors.white),),radius: 45,backgroundColor: Colors.amber,),
        SizedBox(width: 10.0,),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${task["title"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20,),),
            Text("${task["date"]}", style: TextStyle(fontWeight: FontWeight.w400,fontSize:15,color: Colors.grey))
          ],
        )
      ],
    ),
  );
}


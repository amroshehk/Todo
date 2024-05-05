
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



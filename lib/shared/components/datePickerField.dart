import 'package:flutter/material.dart';

class DateTimePickerField extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const DateTimePickerField({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.grey.shade500),
            const SizedBox(width: 16),
            Text(widget.title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
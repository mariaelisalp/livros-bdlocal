import 'package:flutter/material.dart';


class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.error,
    required this.controller,
    required this.selectedValue,
  });

  final List<String> controller;
  final bool error;
  final String hintText;
  final Function(String?) onChanged;
  final String? selectedValue;  

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: DropdownButtonFormField<String>(
        value: widget.selectedValue, 
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: widget.error == true ? Colors.red : Colors.teal.shade300, width: 2.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: widget.error == true ? Colors.red : Colors.teal.shade700, width: 2.5),
          ),
          fillColor: const Color(0x96FFFFFF),
          filled: true,
          hintText: widget.hintText,
        ),
        items: widget.controller.map((String genre) {
          return DropdownMenuItem<String>(
            value: genre,
            child: Text(genre),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}

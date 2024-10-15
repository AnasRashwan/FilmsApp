import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;

  final TextEditingController myController;

  final bool secure;
  final String? Function(String?)? validator;

  const CustomTextForm(
      {super.key,
      required this.hintText,
      required this.myController,
      required this.secure,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: secure,
      controller: myController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}

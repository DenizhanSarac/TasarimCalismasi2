import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0,),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(   
          prefixIcon: const Icon(Icons.account_box,color: Color.fromARGB(255, 79,91,107),),      
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey[300],
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),),
      ),
    );
  }
}
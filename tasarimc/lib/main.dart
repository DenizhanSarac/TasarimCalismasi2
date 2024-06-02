import 'package:flutter/material.dart';
import 'package:tasarimc/screens/Dashboard.dart';
import 'package:tasarimc/screens/LoginScreen.dart';
import 'package:tasarimc/screens/TechnicalAdd.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

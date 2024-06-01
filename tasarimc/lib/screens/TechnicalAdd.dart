import 'package:flutter/material.dart';

class Technical extends StatelessWidget {
const Technical({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
	// Material App
	return MaterialApp(

		// Scaffold Widget
		home: Scaffold(
	appBar: AppBar(
		// AppBar takes a Text Widget
		// in it's title parameter
		title: const Text('GFG'),
	),
	body: const Center(child: Text('Hello World')),
	));
}
}

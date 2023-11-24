//import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

void main() {
  //widgetsApp MaterialApp CupertinoApp
  runApp(MaterialApp(
    home: Homepage(),
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}

class Homepage extends StatelessWidget {
  //const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome App"),
      ),
      body: Container(child: Text("Hi flutter")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/drawer_a.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  //const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color.fromARGB(255, 174, 241, 98),
        title: const Text("Halo"),
      ),
      /*body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
         
        ),
      ),*/
      drawer: const Mydrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ScaffoldDay7 extends StatelessWidget {
  const ScaffoldDay7({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // App Bar Bagian Atas
        appBar: AppBar(
          actions: [Text("Keluar")],
          centerTitle: true,
          title: const Text("Latihan APP Developer Day 7"),
        ),

        // Konten Utama
        body: const Center(child: Text("hai, kamu")),

        //FloatingActionButton
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),

        backgroundColor: const Color.fromARGB(255, 47, 105, 49),
      ),
    );
  }
}

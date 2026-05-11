import 'package:flutter/material.dart';

class LayoutProfil extends StatelessWidget {
  const LayoutProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RUAS: Ruang Napas"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Center(child: Text("Aplikasi Kualitas Udara")),
          Column(children: [Container(padding: EdgeInsets.all(2))]),
        ],
      ),
    );
  }
}

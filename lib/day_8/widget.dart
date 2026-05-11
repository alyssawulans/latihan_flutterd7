import 'package:flutter/material.dart';

class Latihan2dart extends StatelessWidget {
  const Latihan2dart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gojek"),
        backgroundColor: Color.fromARGB(244, 40, 145, 8),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),

      // membuat kontainer
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(16),
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("latihan_flutterd7\assets\images\kucing.jpg"),
              ),
              color: const Color.fromARGB(206, 3, 131, 163),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          margin: EdgeInsets.all(1),
                          height: 90,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 10),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.percent,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        "GOPAY",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),

                              Text(
                                "Rp10.000",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 1),

                              Text(
                                "Saldo Sisa Sedikit",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Column(children: [Icon(Icons.payment), Text("Bayar")]),
                    Column(children: [Icon(Icons.touch_app), Text("Top Up")]),
                    Column(children: [Icon(Icons.search), Text("Eksplor")]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

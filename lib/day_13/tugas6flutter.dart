import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_12/tugas5flutter.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';

class Tugas6flutter extends StatefulWidget {
  const Tugas6flutter({super.key});

  @override
  State<Tugas6flutter> createState() => _Tugas6flutterState();
}

class _Tugas6flutterState extends State<Tugas6flutter> {
  bool back = false;
  bool masuk = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F8FB),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Masuk",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFF4F8FB),
      ),

      // body: Column(
      //   children: [
      //     SizedBox(height: 10),

      //     // Text.rich(
      //     //   TextSpan(
      //     //     text: "Selamat Datang",
      //     //     style: TextStyle(fontSize: 40),
      //     //     children: [
      //     //       TextSpan(
      //     //         style: TextStyle(
      //     //           fontWeight: FontWeight.bold,
      //     //           decoration: TextDecoration.underline,
      //     //           decorationColor: Colors.blue,
      //     //           color: Colors.blue,
      //     //           fontSize: 18,
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           "Selamat Datang",
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //         Text(
      //           " Kembali",
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //       ],
      //     ),
      //     Text("Masuk untuk melanjutkan ke aplikasi RUAS"),
      //     SizedBox(height: 10),
      //     Container(
      //       padding: EdgeInsets.all(double.infinity),
      //       decoration: BoxDecoration(
      //         color: Colors.grey[200],
      //         borderRadius: BorderRadius.circular(16),
      //         boxShadow: const [
      //           BoxShadow(blurRadius: 5, color: Colors.black12),
      //         ],
      //       ),

      //       child: Column(
      //         children: [
      //           Text("Email atau Nomor Telepon"),
      //           SizedBox(height: 10),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Selamat Datang",

                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Kembali !",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 15),

                    Text(
                      "Masuk untuk melanjutkan ke aplikasi RUAS",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(blurRadius: 1, color: Colors.black12),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email atau Nomor Telepon",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Masukkan Email atau Nomor Telepon",
                        hintStyle: TextStyle(fontSize: 12),

                        filled: true,
                        fillColor: const Color.fromARGB(1, 220, 231, 232),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email Tidak Boleh Kosong";
                        } else if (value.contains("@")) {
                          return "Format Tidak Lengkap";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Kata Sandi",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        hintText: "Masukkan Password",
                        hintStyle: TextStyle(fontSize: 13),
                        filled: true,
                        fillColor: const Color.fromARGB(1, 220, 231, 232),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: Icon(Icons.visibility_outlined),

                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email Tidak Boleh Kosong";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    SizedBox(
                      child: Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                          print("Sudah memenuhi syarat");
                        ) ,
                        child: Text("Masuk"),
  },
                      ),
                    ),

                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[350]),
                        ),
                        SizedBox(width: 10),
                        Text("atau"),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[350]),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Masuk dengan Google",
                        labelStyle: TextStyle(fontSize: 13),

                        filled: true,
                        fillColor: const Color.fromARGB(1, 220, 231, 232),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.laptop_windows),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      decoration: InputDecoration(
                        labelText: "Masuk dengan Apple",
                        labelStyle: TextStyle(fontSize: 13),

                        filled: true,
                        fillColor: const Color.fromARGB(1, 220, 231, 232),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.apple),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text.rich(
                TextSpan(
                  text: "Belum Punya Akun?",

                  style: TextStyle(fontSize: 14),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(Tugas5flutter()),
                      text: " Daftar Sekarang",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        decorationColor: Colors.teal[600],
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

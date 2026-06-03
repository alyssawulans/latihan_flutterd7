import 'dart:convert';

class UserModelSql {
  final int? id;
  final String nama;
  final String email;
  final String phone;
  final String password;
  final String alamat;

  UserModelSql({
    this.id,
    required this.nama,
    required this.email,
    required this.phone,
    required this.password,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'email': email,
      'phone': phone,
      'password': password,
      'alamat': alamat,
    };
  }

  factory UserModelSql.fromMap(Map<String, dynamic> map) {
    return UserModelSql(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      alamat: map['alamat'] as String,
    );
  }

  String toJson() => json.encode(toMap());
  factory UserModelSql.fromJson(String source) =>
      UserModelSql.fromMap(json.decode(source) as Map<String, dynamic>);
}

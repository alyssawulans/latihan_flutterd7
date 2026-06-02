class UserModelSql {
  final int? id;
  final String email;
  final String? phone;
  final String password;
  final String? alamat;

  UserModelSql({
    this.id,
    required this.email,
    this.phone,
    required this.password,
    this.alamat,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'email': email,
      'phone': phone,
      'password': password,
      'alamat': alamat,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory UserModelSql.fromMap(Map<String, dynamic> map) {
    return UserModelSql(
      // Aman untuk id: jika di SQLite bertipe int, casting ini sudah benar
      id: map['id'] as int?,

      // Menggunakan .toString() untuk menghindari crash jika tipenya tercampur di DB
      email: map['email']?.toString() ?? '',

      // Jika data null, biarkan null. Jika ada isinya (int/String), ubah ke String
      phone: map['phone']?.toString(),

      password: map['password']?.toString() ?? '',

      alamat: map['alamat']?.toString(),
    );
  }
}

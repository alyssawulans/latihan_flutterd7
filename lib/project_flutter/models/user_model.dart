class UserModel {
  final int? id;
  final String nama;
  final String email;
  final String nomorTelp;
  final String password;
  final String tanggalDaftar;
  final String tempatLahir;
  final String tanggalLahir;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.nomorTelp,
    required this.password,
    required this.tanggalDaftar,
    this.tempatLahir = '',
    this.tanggalLahir = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nomor_telp': nomorTelp,
      'password': password,
      'tanggal_daftar': tanggalDaftar,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      nomorTelp: map['nomor_telp'] ?? '',
      password: map['password'] ?? '',
      tanggalDaftar: map['tanggal_daftar'] ?? '',
      tempatLahir: map['tempat_lahir'] ?? '',
      tanggalLahir: map['tanggal_lahir'] ?? '',
    );
  }
}

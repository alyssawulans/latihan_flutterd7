class UserModel {
  final int? id;
  final String nama;
  final String email;
  final String nomorTelp;
  final String password;
  final String tanggalDaftar;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.nomorTelp,
    required this.password,
    required this.tanggalDaftar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nomor_telp': nomorTelp,
      'password': password,
      'tanggal_daftar': tanggalDaftar,
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
    );
  }
}

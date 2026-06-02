import 'dart:developer';

import 'package:latihan_flutterd7/day_20/models/user_model_sql.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ppkd.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            phone TEXT,
            password TEXT,
            alamat TEXT
          )
        ''');
      },
    );
  }

  // Fungsi Register CREATE
  Future<bool> registerUser(UserModelSql pengguna) async {
    final db = await database;
    try {
      await db.insert('users', pengguna.toMap());
      return true;
    } catch (e) {
      log("Error Register: ${e.toString()}");
      return false;
    }
  }

  // Fungsi Login GET
  Future<UserModelSql?> loginUser(UserModelSql user) async {
    final db = await database; // Pastikan getter database aman

    // Menggunakan query untuk mencari email dan password yang cocok
    final List<Map<String, dynamic>> maps = await db.query(
      'users', // Pastikan nama tabel sesuai dengan yang kamu buat saat onCreate
      where: 'email = ? AND password = ?',
      whereArgs: [user.email, user.password],
    );

    if (maps.isNotEmpty) {
      return UserModelSql.fromMap(
        maps.first,
      ); // Atau sesuaikan dengan factory modelmu
    }
    return null;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<UserModelSql>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('users');

    return results.map((map) => UserModelSql.fromMap(map)).toList();
  }

  // Fungsi untuk menghapus user berdasarkan ID
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk memperbarui data user
  Future<bool> updateUser(UserModelSql pengguna) async {
    final db = await database;

    // PENTING: Pastikan id pengguna tidak null sebelum melakukan update
    if (pengguna.id == null) {
      log("Error Update: ID pengguna null, tidak bisa update data.");
      return false;
    }

    try {
      int count = await db.update(
        'users',
        pengguna.toMap(),
        where: 'id = ?',
        whereArgs: [pengguna.id],
      );
      return count > 0;
    } catch (e) {
      log("Error Update: ${e.toString()}");
      return false;
    }
  }
}

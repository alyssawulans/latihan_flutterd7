import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_20/database/db_helper.dart';
import 'package:latihan_flutterd7/day_20/models/user_model_sql.dart';
import 'package:latihan_flutterd7/extension/navigator.dart';
import 'package:sqlite_viewer2/sqlite_viewer.dart';

class HomeScreenDay20 extends StatefulWidget {
  const HomeScreenDay20({super.key});

  @override
  State<HomeScreenDay20> createState() => _HomeScreenDay20State();
}

class AppImage {
  static const String logo = 'assets/images/logo_ruas.png';
  static const String avatar = 'assets/images/profile.webp';
}

class _HomeScreenDay20State extends State<HomeScreenDay20> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModelSql(
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      alamat: alamatController.text.trim(),
    );

    bool success = await DBHelper().registerUser(user);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat')));
      // Bersihkan form setelah input sukses
      namaController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      alamatController.clear();
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF0F4C43);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol burger menu otomatis muncul di sini untuk membuka Drawer internal Katalog
        iconTheme: const IconThemeData(color: primaryTeal),
        title: Row(
          children: [
            Image.asset(
              AppImage.logo,
              height: 26,
              width: 26,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.blur_on_rounded, size: 26);
              },
            ),
            SizedBox(width: 8),

            Text(
              "RUAS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTeal,
                fontSize: 19,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                'assets/images/profile.webp',
              ), // Menggunakan avatar lokal
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Kelola Pengguna',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      textFormConst(
                        controller: namaController,
                        hintText: "Masukkan Nama",
                        prefixIcon: Icons.person_outlined,
                        validator: (v) =>
                            v!.isEmpty ? "Nama wajib diisi" : null,
                      ),

                      const SizedBox(height: 6),
                      textFormConst(
                        controller: emailController,
                        hintText: "Masukkan Email",
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email tidak boleh kosong";
                          } else if (!value.contains('@')) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 6),
                      textFormConst(
                        controller: phoneController,
                        hintText: "Masukkan Nomor Telepon",
                        prefixIcon: Icons.phone_android_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "No Telp tidak boleh kosong";
                          } else if (value.length < 10) {
                            return "No Telp minimal 10 digit";
                          } else if (value.length > 14) {
                            return "No Telp maksimal 14 digit";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 6),
                      textFormConst(
                        controller: passwordController,
                        hintText: "Masukkan Password",
                        obscureText: obscurePassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() {
                            obscurePassword = !obscurePassword;
                          }),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password tidak boleh kosong";
                          } else if (value.length < 6) {
                            return "Password minimal 6 karakter";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 6),
                      textFormConst(
                        controller: alamatController,
                        hintText: "Masukkan Alamat",
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) =>
                            v!.isEmpty ? "Alamat wajib diisi" : null,
                      ),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: DefaultButton(
                          text: "Tambah Pengguna",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              register();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, thickness: 2, color: Color(0xFF7A8B9E)),
            SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Daftar Pengguna Terdaftar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2E44),
                  ),
                ),
              ),
            ),

            // Bagian List View Data
            Expanded(
              flex: 2,
              child: FutureBuilder<List<UserModelSql>>(
                future: DBHelper().getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada data pengguna.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final daftarPengguna = snapshot.data!;

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: daftarPengguna.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    itemBuilder: (context, index) {
                      final user = daftarPengguna[index];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFFEAEAEA),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFEAF6F6),
                            child: Icon(Icons.person, color: Colors.teal),
                          ),
                          title: Text(
                            user.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A2E44),
                            ),
                          ),
                          subtitle: Text(
                            'Telp: ${user.phone} | Alamat: ${user.alamat}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.teal,
                              size: 26,
                            ),
                            onPressed: () => _showBottomSheet(context, user),
                          ),
                          onTap: () => _showBottomSheet(context, user),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Tombol SQLite Viewer
            Padding(
              // Ganti padding bawah menjadi lebih besar (misal 80) agar tidak mepet/tertutup bottom nav
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 80.0,
              ),
              child: Transform.translate(
                offset: const Offset(
                  0,
                  -60,
                ), // Menggeser tombol ke atas sejauh 60 piksel secara paksa
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.storage_rounded,
                        color: Color(0xFF1A2E44),
                      ),
                      label: const Text(
                        "Lihat Database (SQLite Viewer)",
                        style: TextStyle(
                          color: Color(0xFF1A2E44),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        // Padding vertikal di dalam tombol biar text & icon pas di tengah
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(
                          color: Color(0xFF1A2E44),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push(DatabaseList()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, UserModelSql user) {
    final editIdController = TextEditingController(text: "ID Unik: ${user.id}");
    final editNamaController = TextEditingController(text: user.nama);
    final editEmailController = TextEditingController(text: user.email);
    final editPhoneController = TextEditingController(text: user.phone);
    final editPasswordController = TextEditingController(text: user.password);
    final editAlamatController = TextEditingController(text: user.alamat);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kelola Pengguna',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2E44),
                ),
              ),
              const SizedBox(height: 16),

              textTitleForm("ID Pengguna (Read only)"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editIdController,
                hintText: "ID",
                prefixIcon: Icons.fingerprint_rounded,

                validator: (v) => null,
              ),
              const SizedBox(height: 12),

              textTitleForm("Nama"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editNamaController,
                hintText: "Nama",
                prefixIcon: Icons.person_2_outlined,

                validator: (v) => null,
              ),
              const SizedBox(height: 12),

              textTitleForm("Email"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editEmailController,
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                validator: (v) => null,
              ),
              const SizedBox(height: 12),

              textTitleForm("No. Telepon"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editPhoneController,
                hintText: "Nomor Telepon",
                prefixIcon: Icons.phone_android_outlined,
                validator: (v) => null,
              ),
              const SizedBox(height: 12),

              textTitleForm("Password"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editPasswordController,
                hintText: "Password",
                prefixIcon: Icons.lock_outline_rounded,
                validator: (v) => null,
              ),
              const SizedBox(height: 12),

              textTitleForm("Alamat"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editAlamatController,
                hintText: "Alamat",
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => null,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (user.id != null) {
                          await DBHelper().deleteUser(user.id!);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data berhasil dihapus'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.save_as_outlined),
                      label: const Text(
                        'Perbarui',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (user.id != null) {
                          final updatedUser = UserModelSql(
                            id: user.id,
                            nama: editNamaController.text.trim(),
                            email: editEmailController.text.trim(),
                            phone: editPhoneController.text.trim(),
                            password: editPasswordController.text,
                            alamat: editAlamatController.text.trim(),
                          );

                          bool success = await DBHelper().updateUser(
                            updatedUser,
                          );
                          if (!context.mounted) return;
                          if (success) {
                            Navigator.pop(context);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil diperbarui'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    ).then((_) {
      // editIdController.dispose();
      // editNamaController.dispose();
      // editEmailController.dispose();
      // editPhoneController.dispose();
      // editPasswordController.dispose();
      // editAlamatController.dispose();
    });
  }

  TextFormField textFormConst({
    required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController controller,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    bool enabled = true, // Sudah ada
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      enabled: enabled, // <-- 1. WAJIB TAMBAHKAN BARIS INI!
      // 2. Buat warna teks sedikit memudar jika field-nya di-disable (seperti field ID)
      style: TextStyle(
        color: enabled ? const Color(0xFF1A2E44) : Colors.black45,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        // 3. Ubah background jadi abu-abu tipis kalau disabled biar estetik
        fillColor: enabled ? const Color(0xFFF8FAF9) : const Color(0xFFEEEEEE),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: enabled ? const Color(0xFF1A2E44) : Colors.grey,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: borderConst(),
        focusedBorder: borderConst(color: Colors.teal, width: 1.5),
        errorBorder: borderConst(color: Colors.red, width: 1),
        focusedErrorBorder: borderConst(color: Colors.red, width: 1.5),
        // 4. Tambahkan border khusus saat field dalam posisi terkunci
        disabledBorder: borderConst(),
        border: borderConst(),
      ),
    );
  }

  OutlineInputBorder borderConst({
    Color color = Colors.transparent,
    double width = 0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }

  Widget textTitleForm(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1A2E44),
    ),
  );
}

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DefaultButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A2E44),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

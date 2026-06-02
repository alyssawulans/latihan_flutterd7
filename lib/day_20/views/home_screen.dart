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

class _HomeScreenDay20State extends State<HomeScreenDay20> {
  final _formKey = GlobalKey<FormState>();

  // Controller Utama
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
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final pass = passwordController.text;
    final alamat = alamatController.text.trim();

    final user = UserModelSql(
      email: email,
      phone: phone.isEmpty ? null : phone,
      password: pass,
      alamat: alamat.isEmpty ? null : alamat,
    );

    bool success = await DBHelper().registerUser(user);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil ditambahkan')),
      );

      // Reset form utama setelah berhasil input
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      alamatController.clear();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sudah terdaftar atau terjadi kesalahan!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kelola Data RUAS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2E44),
          ),
        ),
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
                      // const SizedBox(height: 6),
                      // textFormConst(
                      //   controller: namaController,
                      //   hintText: "Masukkan Email",
                      //   prefixIcon: Icons.email_outlined,
                      //   validator: (value) {
                      //     if (value == null || value.trim().isEmpty) {
                      //       return "Email tidak boleh kosong";
                      //     } else if (!value.contains('@')) {
                      //       return "Format email tidak valid";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // textTitleForm("Email *"),
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
                      const SizedBox(height: 12),
                      // textTitleForm("No. Telepon"),
                      const SizedBox(height: 6),
                      textFormConst(
                        controller: phoneController,
                        hintText: "Masukkan Nomor Telepon (Opsional)",
                        prefixIcon: Icons.phone_android_outlined,
                        validator: (v) => null,
                      ),
                      const SizedBox(height: 12),
                      // textTitleForm("Password *"),
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
                      const SizedBox(height: 12),
                      // textTitleForm("Alamat"),
                      const SizedBox(height: 6),
                      textFormConst(
                        controller: alamatController,
                        hintText: "Masukkan Alamat (Opsional)",
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) => null,
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

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
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
                              color: Color(0xFF1A2E44),
                            ),
                          ),
                          subtitle: Text(
                            'Telp: ${user.phone ?? "-"} | Alamat: ${user.alamat ?? "-"}',
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
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, UserModelSql user) {
    // Inisialisasi pengontrol edit dengan data pengguna terpilih
    final editIdController = TextEditingController(
      text: user.id != null ? "ID: ${user.id}" : "",
    );
    final editEmailController = TextEditingController(text: user.email);
    final editPhoneController = TextEditingController(text: user.phone ?? "");
    final editPasswordController = TextEditingController(text: user.password);
    final editAlamatController = TextEditingController(text: user.alamat ?? "");

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

              textTitleForm("ID Pengguna"),
              const SizedBox(height: 6),
              textFormConst(
                controller: editIdController,
                hintText: "ID",
                prefixIcon: Icons.fingerprint_rounded,

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
                          // Bersih dari int.parse yang redundan karena user.id sudah int?
                          await DBHelper().deleteUser(user.id!);
                          if (context.mounted) {
                            Navigator.pop(context);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil dihapus'),
                              ),
                            );
                          }
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
                            email: editEmailController.text.trim(),
                            phone: editPhoneController.text.trim().isEmpty
                                ? null
                                : editPhoneController.text.trim(),
                            password: editPasswordController.text,
                            alamat: editAlamatController.text.trim().isEmpty
                                ? null
                                : editAlamatController.text.trim(),
                          );

                          bool success = await DBHelper().updateUser(
                            updatedUser,
                          );
                          if (success && context.mounted) {
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
      // Membersihkan controller lokal setelah bottom sheet ditutup
      editEmailController.dispose();
      editPhoneController.dispose();
      editPasswordController.dispose();
      editAlamatController.dispose();
    });
  }

  TextFormField textFormConst({
    required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController controller,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF8FAF9),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF1A2E44)),
        suffixIcon: suffixIcon,
        enabledBorder: borderConst(),
        focusedBorder: borderConst(color: Colors.teal, width: 1.5),
        errorBorder: borderConst(color: Colors.red, width: 1),
        focusedErrorBorder: borderConst(color: Colors.red, width: 1.5),
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

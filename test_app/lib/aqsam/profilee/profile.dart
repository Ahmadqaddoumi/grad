import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:test_app/aqsam/profilee/helppage.dart';
import 'package:test_app/aqsam/profilee/settingspage.dart';
import 'package:test_app/login/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  String? accountType;
  bool isLoading = true;
  File? _pickedImage;
  String? networkImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          username = data['username'];
          email = data['email'];
          accountType = data['accountType'];
          networkImageUrl = data['profileImage'];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      setState(() {
        _pickedImage = file;
      });

      final uploadUrl = Uri.parse(
        "https://api.cloudinary.com/v1_1/de40nspy3/image/upload",
      );
      final request =
          http.MultipartRequest('POST', uploadUrl)
            ..fields['upload_preset'] = 'flutter_unsigned'
            ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (jsonResponse['secure_url'] != null) {
        final downloadUrl = jsonResponse['secure_url'];
        final uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImage': downloadUrl,
        });

        setState(() {
          networkImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ تم رفع الصورة وتحديث الحساب بنجاح")),
        );
      } else {
        throw Exception("فشل رفع الصورة");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ فشل رفع الصورة: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68316D),
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color(0xFF68316D),
                                  backgroundImage:
                                      _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : (networkImageUrl != null
                                                  ? NetworkImage(
                                                    networkImageUrl!,
                                                  )
                                                  : null)
                                              as ImageProvider?,
                                  child:
                                      (_pickedImage == null &&
                                              networkImageUrl == null)
                                          ? const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                              ),

                              // ✅ زر الحذف إذا في صورة محمّلة
                              if (_pickedImage != null ||
                                  networkImageUrl != null)
                                Positioned(
                                  top: 0,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final uid =
                                          FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid;
                                      if (uid == null) return;

                                      try {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .update({
                                              'profileImage':
                                                  FieldValue.delete(),
                                            });

                                        setState(() {
                                          _pickedImage = null;
                                          networkImageUrl = null;
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "✅ تم حذف الصورة بنجاح",
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("❌ فشل الحذف: $e"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),

                              // ✅ أيقونة الكاميرا
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Color(0xFF68316D),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Text(
                            username ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email ?? "",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "نوع الحساب: ${accountType ?? ''}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                    _buildOption(
                      Icons.lock,
                      "تغيير كلمة المرور",
                      _changePassword,
                    ),
                    _buildOption(Icons.settings, "الإعدادات", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    }),
                    _buildOption(Icons.help_outline, "المساعدة", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpPage()),
                      );
                    }),
                    _buildOption(Icons.phone, "اتصل بنا", () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("رقم الهاتف"),
                              content: const Text("0795466670"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("إغلاق"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      const ClipboardData(text: "0795466670"),
                                    );
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("تم نسخ الرقم بنجاح"),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text("نسخ الرقم"),
                                ),
                              ],
                            ),
                      );
                    }),
                    const Divider(height: 40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF68316D),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LogInPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "تسجيل الخروج",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  void _changePassword() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("تغيير كلمة المرور"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    hintText: "كلمة المرور الحالية",
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    hintText: "كلمة المرور الجديدة",
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("إلغاء"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("تأكيد"),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final cred = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: oldPasswordController.text.trim(),
                  );
                  try {
                    await user.reauthenticateWithCredential(cred);
                    await user.updatePassword(
                      newPasswordController.text.trim(),
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("تم تغيير كلمة المرور بنجاح"),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("فشل التحقق أو التحديث: $e")),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF68316D)),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

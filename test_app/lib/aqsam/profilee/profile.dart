import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/aqsam/profilee/helppage.dart';
import 'package:test_app/login/login.dart';
import 'package:url_launcher/url_launcher.dart'; // تأكد من وجود هذه الصفحة

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
          isLoading = false;
        });
      }
    }
  }

  void _launchWhatsApp() async {
    const phone = '962790000000'; // اكتب رقمك مع مفتاح الدولة بدون +
    final message = Uri.encodeComponent(
      "مرحبًا، أحتاج إلى المساعدة في التطبيق.",
    );
    final url = Uri.parse("https://wa.me/$phone?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تعذر فتح واتساب")));
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFF68316D),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
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
                  _buildOption(Icons.lock, "تغيير كلمة المرور", () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final passwordController = TextEditingController();
                        return AlertDialog(
                          title: const Text("تغيير كلمة المرور"),
                          content: TextField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: "كلمة المرور الجديدة",
                            ),
                            obscureText: true,
                          ),
                          actions: [
                            TextButton(
                              child: const Text("إلغاء"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("تأكيد"),
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.currentUser!
                                      .updatePassword(
                                        passwordController.text.trim(),
                                      );
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "تم تغيير كلمة المرور بنجاح",
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("حدث خطأ: $e")),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),

                  _buildOption(Icons.settings, "الإعدادات", () {}),
                  _buildOption(Icons.help_outline, "المساعدة", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  }),
                  _buildOption(
                    Icons.phone,
                    "اتصل بنا عبر واتساب",
                    _launchWhatsApp,
                  ),

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
                            builder: (context) => const LogInPage(),
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

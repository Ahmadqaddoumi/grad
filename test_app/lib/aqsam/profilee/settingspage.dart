import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/aqsam/profilee/contentpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF68316D),
        title: const Text("الإعدادات", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _buildTile(context, "عن التطبيق", Icons.info, _aboutAppContent),
          _buildTile(
            context,
            "سياسة الخصوصية",
            Icons.privacy_tip,
            _privacyContent,
          ),
          _buildTile(
            context,
            "اتفاقية الاستخدام",
            Icons.article,
            _termsContent,
          ),
          _buildDeleteAccountTile(context),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF68316D)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContentPage(title: title, content: content),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.delete_forever, color: Colors.red),
        title: const Text(
          "حذف الحساب",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.red,
        ),
        onTap: () {
          final passwordController = TextEditingController();
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("تأكيد الحذف"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("أدخل كلمة المرور لتأكيد حذف الحساب:"),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "كلمة المرور",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("إلغاء"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text(
                        "حذف",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        final email = user?.email;
                        final password = passwordController.text.trim();

                        if (user != null &&
                            email != null &&
                            password.isNotEmpty) {
                          try {
                            final cred = EmailAuthProvider.credential(
                              email: email,
                              password: password,
                            );
                            await user.reauthenticateWithCredential(cred);

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .delete();

                            if (context.mounted) {
                              Navigator.of(context).pop();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("تم حذف الحساب بنجاح"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              await Future.delayed(const Duration(seconds: 2));

                              await user.delete();

                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              }
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("فشل حذف الحساب: $e")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يرجى إدخال كلمة المرور"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }

  static const String _aboutAppContent = '''
مهمتنا

أن نقوم بربط المستخدمين والجمعيات مع بعضهم البعض من خلال منصة مريحة وفعالة تسمح بتنفيذ المهام بأسرع وقت 

عن التطبيق

هذا التطبيق يساعد الجمعيات على نشر إعلانات تطوعية، والمتطوعين على التفاعل معها بسهولة.
تم تطويره لدعم المجتمعات وتشجيع العمل التطوعي.
''';

  static const String _privacyContent = '''
سياسة الخصوصية

نوضح في هذه السياسة كيف يتم التعامل مع بياناتك:
- لا يتم مشاركة معلوماتك مع أطراف خارجية.
- يتم استخدام البيانات فقط لتحسين الخدمة وتخصيص المحتوى.
- يمكنك حذف حسابك أو تعديل بياناتك في أي وقت من خلال الإعدادات.
''';

  static const String _termsContent = '''
شروط الاستخدام

بتسجيلك في هذا التطبيق، فإنك توافق على:
- احترام شروط المنصة.
- عدم نشر محتوى مسيء أو غير قانوني.
- إدارة الجمعيات مسؤولة عن الإعلانات الخاصة بها.
تاريخ اعتماد هذه الشروط: 2025/5/12
''';
}

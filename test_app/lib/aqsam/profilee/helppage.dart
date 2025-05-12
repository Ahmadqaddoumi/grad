import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        title: const Text("المساعدة"),
        centerTitle: true,
        backgroundColor: const Color(0xFF68316D),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "الأسئلة الشائعة",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildHelpItem(
            Icons.lock,
            "كيف أغير كلمة المرور؟",
            "من صفحة الملف الشخصي، اختر تغيير كلمة المرور.",
          ),
          _buildHelpItem(
            Icons.campaign,
            "كيف أنشئ إعلانًا؟",
            "إذا كنت جمعية، اضغط على زر + في الهوم.",
          ),
          _buildHelpItem(
            Icons.category,
            "كيف أرى إعلانات الأقسام؟",
            "اضغط على القسم وسيتم عرض الإعلانات حسب نوع حسابك.",
          ),
          _buildHelpItem(
            Icons.people,
            "ما الفرق بين المتطوع والجمعية؟",
            "المتطوع يطّلع على الإعلانات، والجمعية تنشرها.",
          ),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF68316D)),
            title: const Text("راسلنا عبر البريد"),
            subtitle: const Text("teamworkk@gmail.com"),
            onTap: () {
              // future: open email app (اختياري)
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF68316D)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/login/login.dart';
import 'package:test_app/login/regester/admin/allusers.dart';
import 'package:test_app/login/regester/admin/userstatespage.dart';
import 'package:test_app/login/regester/admin/alladsadminpage.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  Future<void> addIsActiveToOldUsers(BuildContext context) async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    int updatedCount = 0;

    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      if (!data.containsKey('isActive')) {
        await doc.reference.update({'isActive': true});
        updatedCount++;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم تحديث $updatedCount حساب قديم ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "لوحة تحكم الأدمن",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "مرحبًا بك يا أدمن 👑\nهنا يمكنك إدارة التطبيق.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff68316d),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.group, color: Color(0xff68316d)),
            title: const Text("عرض جميع المستخدمين"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllUsersPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: Color(0xff68316d)),
            title: const Text("إحصائيات المستخدمين"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersStatsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement, color: Color(0xff68316d)),
            title: const Text("عرض جميع الإعلانات"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllAdsAdminPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.update, color: Color(0xff68316d)),
            title: const Text("تحديث الحسابات القديمة"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => addIsActiveToOldUsers(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xff68316d)),
            title: const Text("تسجيل الخروج"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LogInPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

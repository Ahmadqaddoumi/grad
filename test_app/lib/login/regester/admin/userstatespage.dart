import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersStatsPage extends StatelessWidget {
  const UsersStatsPage({super.key});

  Future<Map<String, int>> getStatistics() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final allUsers = snapshot.docs;

    int total = allUsers.length;
    int charities = 0;
    int volunteers = 0;
    int active = 0;
    int inactive = 0;

    for (var doc in allUsers) {
      final data = doc.data();
      final type = data['accountType'];
      final isActive = data['isActive'] ?? true;

      if (type == 'Charity') charities++;
      if (type == 'Volunteer') volunteers++;
      if (isActive == true) {
        active++;
      } else {
        inactive++;
      }
    }

    return {
      'total': total,
      'charities': charities,
      'volunteers': volunteers,
      'active': active,
      'inactive': inactive,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "إحصائيات المستخدمين",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: getStatistics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatTile("👥 إجمالي المستخدمين", stats['total']!),
              _buildStatTile("🏢 عدد الجمعيات", stats['charities']!),
              _buildStatTile("🙋‍♂️ عدد المتطوعين", stats['volunteers']!),
              _buildStatTile("✅ حسابات مفعّلة", stats['active']!),
              _buildStatTile("🔒 حسابات موقوفة", stats['inactive']!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatTile(String title, int value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdDetailsPage extends StatelessWidget {
  final DocumentSnapshot ad;

  const AdDetailsPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final data = ad.data() as Map<String, dynamic>;

    final allAnswers = <String, dynamic>{};
    if (data['answersFirstPage'] != null) {
      allAnswers.addAll(Map<String, dynamic>.from(data['answersFirstPage']));
    }
    if (data['answersSecondPage'] != null) {
      allAnswers.addAll(Map<String, dynamic>.from(data['answersSecondPage']));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68316D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          data['initiativeName']?.toString() ?? "تفاصيل الإعلان",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoCard(
              "📍 الموقع",
              data['location']?.toString() ?? 'غير محدد',
            ),

            buildInfoCard(
              "📝 وصف الإعلان",
              data['note']?.toString() ?? 'لا يوجد وصف',
            ),

            if ((data['supporter']?.toString().isNotEmpty ?? false))
              buildInfoCard(
                "🏛️ الجهة الداعمة",
                data['supporter']?.toString() ?? 'غير محدد',
              ),

            buildInfoCard(
              "🎯 نوع المبادرة",
              data['initiativeType']?.toString() ?? 'غير محدد',
            ),

            if ((data['initiativeGoal']?.toString().isNotEmpty ?? false))
              buildInfoCard(
                "🎯 الهدف من المبادرة",
                data['initiativeGoal']?.toString() ?? 'غير محدد',
              ),

            const SizedBox(height: 20),
            const Text(
              "🧾 تفاصيل الحملة",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF68316D),
              ),
            ),
            const SizedBox(height: 10),
            ...allAnswers.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(entry.value.toString()),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String content) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: Text(content, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdDetailsPage extends StatelessWidget {
  final DocumentSnapshot ad;

  const AdDetailsPage({super.key, required this.ad});

  Future<String> getUsernameFromUid(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? (doc.data()?['username'] ?? 'غير محدد') : 'غير محدد';
  }

  @override
  Widget build(BuildContext context) {
    final data = ad.data() as Map<String, dynamic>;
    final imageUrls = List<String>.from(data['imageUrls'] ?? []);

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
            if (imageUrls.isNotEmpty)
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final url = imageUrls[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => Dialog(
                                backgroundColor: Colors.black,
                                child: InteractiveViewer(
                                  child: Image.network(url),
                                ),
                              ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            width: 140,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),

            FutureBuilder<String>(
              future: getUsernameFromUid(data['uid']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  );
                }
                final supporter = snapshot.data ?? 'غير محدد';
                return buildInfoCard("🏛 الجهة المنظمة", supporter);
              },
            ),
            buildInfoCard(
              "📍 المحافظة",
              data['governorate']?.toString() ?? 'غير محددة',
            ),
            buildInfoCard(
              "📝 الملاحظات",
              data['note']?.toString() ?? 'لا يوجد وصف',
            ),

            if (data['category'] == 'فرص تطوعية عامة')
              buildInfoCard(
                "🎯 نوع المبادرة",
                data['initiativeType']?.toString() ?? 'غير محدد',
              ),

            const SizedBox(height: 20),
            const Text(
              "📋 تفاصيل النشاط:",
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

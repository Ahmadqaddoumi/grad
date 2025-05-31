import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/aqsam/adv/editadpage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final Map<String, bool> expandedCards = {};
  String? supporterUsername;

  @override
  void initState() {
    super.initState();
    fetchSupporterUsername();
  }

  Future<void> fetchSupporterUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          supporterUsername = doc.data()?['username'] ?? 'غير محدد';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (supporterUsername == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إعلاناتي",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('ads')
                .where('uid', isEqualTo: uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا يوجد إعلانات حتى الآن.'));
          }

          final ads = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              final docId = ad.id;
              final name = ad['initiativeName'] ?? 'بدون اسم';
              final governorate =
                  ad.data().toString().contains('governorate')
                      ? ad['governorate']
                      : 'غير محددة';
              final note = ad['note'] ?? 'لا توجد ملاحظات';
              final date = (ad['date'] as Timestamp?)?.toDate();
              final answers1 =
                  ad['answersFirstPage'] as Map<String, dynamic>? ?? {};
              final answers2 =
                  ad['answersSecondPage'] as Map<String, dynamic>? ?? {};
              final imageUrls =
                  ad.data().toString().contains('imageUrls')
                      ? List<String>.from(ad['imageUrls'])
                      : [];

              final isExpanded = expandedCards[docId] ?? false;

              return Card(
                color: const Color(0xfff8f0fa),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expandedCards[docId] = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.campaign,
                              color: Color(0xff68316d),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff68316d),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: const Text("تأكيد الحذف"),
                                            content: const Text(
                                              "هل أنت متأكد من حذف هذا الإعلان؟",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text("إلغاء"),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text("حذف"),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm == true) {
                                      await FirebaseFirestore.instance
                                          .collection('ads')
                                          .doc(docId)
                                          .delete();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("تم حذف الإعلان"),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditAdPage(
                                              adId: docId,
                                              adData:
                                                  ad.data()
                                                      as Map<String, dynamic>,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('🏛 الجهة الداعمة: $supporterUsername'),
                        Text('🏙 المحافظة: $governorate'),
                        if (ad['category'] == 'فرص تطوعية عامة')
                          Text(
                            '📌 نوع المبادرة: ${ad['initiativeType'] ?? "غير محددة"}',
                          ),
                        Text(
                          '📅 التاريخ: ${date != null ? "${date.day}/${date.month}/${date.year}" : "غير محدد"}',
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 8),
                          Text('📝 الملاحظات: $note'),
                          const Divider(height: 20, thickness: 1),
                          const Text(
                            '📋 تفاصيل النشاط:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff68316d),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...[...answers1.entries, ...answers2.entries].map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "• ${entry.key}: ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: entry.value),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (imageUrls.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Text(
                              '🖼 صور الإعلان:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xff68316d),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageUrls.length,
                                itemBuilder: (context, imgIndex) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrls[imgIndex],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

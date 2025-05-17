import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllAdsAdminPage extends StatefulWidget {
  const AllAdsAdminPage({super.key});

  @override
  State<AllAdsAdminPage> createState() => _AllAdsAdminPageState();
}

class _AllAdsAdminPageState extends State<AllAdsAdminPage> {
  List<bool> expanded = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "جميع الإعلانات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ads').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final ads = snapshot.data!.docs;

          if (expanded.length != ads.length) {
            expanded = List.filled(ads.length, false);
          }

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              final data = ad.data() as Map<String, dynamic>;

              final initiativeName = data['initiativeName'] ?? 'بدون اسم';
              final charity = data['supporter'] ?? 'جمعية غير معروفة';
              final timestamp =
                  data['timestamp']?.toDate().toString().split(' ')[0] ??
                  'تاريخ غير معروف';

              final location = data['location'] ?? '';
              final category = data['category'] ?? '';
              final subCategory = data['subCategory']?.toString() ?? '';
              final note = data['note'] ?? '';
              final uid = data['uid'] ?? '';

              final answersFirst = Map<String, dynamic>.from(
                data['answersFirstPage'] ?? {},
              );
              final answersSecond = Map<String, dynamic>.from(
                data['answersSecondPage'] ?? {},
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expanded[index] = !expanded[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "📌 $initiativeName",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("🏢 الجمعية: $charity"),
                                  Text("🕒 التاريخ: $timestamp"),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: const Text("تأكيد الحذف"),
                                        content: Text(
                                          "هل تريد حذف المبادرة '$initiativeName'؟",
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
                                            child: const Text(
                                              "حذف",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('ads')
                                      .doc(ad.id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "تم حذف الإعلان '$initiativeName'",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        // Expandable Section
                        if (expanded[index]) ...[
                          const Divider(),
                          _infoRow("📍 الموقع", location),
                          _infoRow("📁 القسم", "$category / $subCategory"),
                          _infoRow("📝 الملاحظات", note),
                          _infoRow("🆔 UID", uid),
                          const SizedBox(height: 10),

                          const Text(
                            "❓ الأسئلة والإجابات:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),

                          ...[
                            ...answersFirst.entries,
                            ...answersSecond.entries,
                          ].map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "❓ ${entry.key}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "📌 ${entry.value}",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}

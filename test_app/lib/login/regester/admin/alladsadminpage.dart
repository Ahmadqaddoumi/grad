import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllAdsAdminPage extends StatefulWidget {
  const AllAdsAdminPage({super.key});

  @override
  State<AllAdsAdminPage> createState() => _AllAdsAdminPageState();
}

class _AllAdsAdminPageState extends State<AllAdsAdminPage> {
  List<bool> expanded = [];
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "جميع الإعلانات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "ابحث عن اسم المبادرة...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchTerm = '';
                            });
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('ads').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rawAds = snapshot.data!.docs;

                final ads =
                    rawAds.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title =
                          (data['initiativeName'] ?? '')
                              .toString()
                              .toLowerCase();
                      return title.contains(searchTerm);
                    }).toList();

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
                    final imageUrls = List<String>.from(
                      data['imageUrls'] ?? [],
                    );

                    final answersFirst = Map<String, dynamic>.from(
                      data['answersFirstPage'] ?? {},
                    );
                    final answersSecond = Map<String, dynamic>.from(
                      data['answersSecondPage'] ?? {},
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                              if (expanded[index]) ...[
                                const Divider(),
                                _infoRow("📍 الموقع", location),
                                _infoRow(
                                  "📁 القسم",
                                  "$category / $subCategory",
                                ),
                                _infoRow("📝 الملاحظات", note),
                                _infoRow("🆔 UID", uid),
                                if (imageUrls.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  const Text(
                                    "🖼 صور الإعلان:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imageUrls.length,
                                      itemBuilder: (context, imgIndex) {
                                        final url = imageUrls[imgIndex];
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => Dialog(
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: InteractiveViewer(
                                                      child: Image.network(url),
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stack) =>
                                                        const Icon(
                                                          Icons.broken_image,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "❓ ${entry.key}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("📌 ${entry.value}"),
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
          ),
        ],
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

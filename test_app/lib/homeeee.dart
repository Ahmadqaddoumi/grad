import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/aqsam/agsam.dart';
import 'package:test_app/aqsam/favourite/favouriteadv.dart';
import 'package:test_app/image/classimage.dart';
import 'package:test_app/nothome/notifications.dart';
import 'package:test_app/sectionsadspage.dart';

class HomePage extends StatefulWidget {
  final String userRole;

  const HomePage({super.key, required this.userRole});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  final List<String> images = [
    'image/assets/a.jpg',
    'image/assets/b.jpg',
    'image/assets/c.jpg',
    'image/assets/d.jpg',
    'image/assets/q.jpg',
  ];

  final List<Map<String, dynamic>> allSections = [
    {"title": "احتياجات الجمعيات", "icon": Icons.business_sharp},
    {"title": "بيئي", "icon": Icons.spa},
    {
      "title": "الفعاليات والمساعدات الإجتماعية",
      "icon": Icons.volunteer_activism,
    },
    {"title": "فرص تطوعية عامة", "icon": Icons.handshake},
  ];

  List<Map<String, dynamic>> get filteredSections {
    final query = _controller.text.trim();
    if (query.isEmpty) return allSections;
    return allSections
        .where((section) => section['title'].contains(query))
        .toList();
  }

  void openSection(String sectionName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SectionAdsPage(
              category: sectionName,
              userRole: widget.userRole,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "إحسان",
                  style: TextStyle(
                    fontFamily: 'ahmad',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF68316D),
                  ),
                ),
                const Spacer(),
                if (widget.userRole == "Volunteer")
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Favouriteadv()),
                      );
                    },
                    child: const Icon(
                      Icons.favorite_sharp,
                      color: Colors.red,
                      size: 30,
                    ),
                  )
                else
                  const SizedBox(width: 30),
                const SizedBox(width: 8),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('notifications')
                          .where(
                            'toUserId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .where('read', isEqualTo: false)
                          .snapshots(),
                  builder: (context, snapshot) {
                    final hasUnread =
                        snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                    return Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Notifications(),
                              ),
                            );
                          },
                        ),
                        if (hasUnread)
                          const Positioned(
                            top: 4,
                            left: 4,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.red,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 200, child: Ahmad(l: images)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "البحث",
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed:
                                () => setState(() => _controller.clear()),
                          )
                          : const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "الاقسام",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 140,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children:
                    filteredSections.map((section) {
                      return Agsam(
                        title: section['title'],
                        icon: section['icon'],
                        onchange: () => openSection(section['title']),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

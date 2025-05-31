import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/addetailspage.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/chat/chatpage2.dart';

class SectionAdsPage extends StatefulWidget {
  final String category;
  final String userRole;

  const SectionAdsPage({
    super.key,
    required this.category,
    required this.userRole,
  });

  @override
  State<SectionAdsPage> createState() => _SectionAdsPageState();
}

class _SectionAdsPageState extends State<SectionAdsPage> {
  String selectedGovernorate = 'الكل';
  String selectedSubcategory = 'الكل';

  final List<String> governorates = [
    'الكل',
    'عمان',
    'الزرقاء',
    'إربد',
    'العقبة',
    'البلقاء',
    'المفرق',
    'جرش',
    'الطفيلة',
    'الكرك',
    'معان',
    'مأدبا',
    'عجلون',
  ];

  final Map<String, List<String>> categorySubcategories = {
    'احتياجات الجمعيات': [
      'الكل',
      'الدعم المالي والتبرعات النقدية',
      'التبرعات العينية (ملابس وغذاء..)',
      'البحث عن متطوعين',
      'صيانة وتطوير مقرات الجمعيات',
    ],
    'بيئي': [
      'الكل',
      'التشجير وإعادة التشجير',
      "إعادة التدوير وإدارة النفايات",
      "حملات تنظيف الأماكن العامة",
    ],
    'الفعاليات و المساعدات الاجتماعية': [
      "تنظيم رحلة ترفيهية للأيتام",
      " تنظيم إفطار جماعي في رمضان",
      "مساعدة كبار السن في الوصول الى المستشفى",
      "الفعاليات والمساعدات الاجتماعية",
    ],
  };

  Future<String> getUsernameFromUid(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? (doc.data()?['username'] ?? 'غير محددة') : 'غير محددة';
  }

  void openFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1B2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final subcategories =
            categorySubcategories[widget.category] ?? ['الكل'];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر المحافظة:',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                value: selectedGovernorate,
                dropdownColor: const Color(0xFF2C2C3E),
                iconEnabledColor: Colors.white,
                isExpanded: true,
                items:
                    governorates
                        .map(
                          (g) => DropdownMenuItem(
                            value: g,
                            child: Text(
                              g,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => selectedGovernorate = val!),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر التصنيف الفرعي:',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                value: selectedSubcategory,
                dropdownColor: const Color(0xFF2C2C3E),
                iconEnabledColor: Colors.white,
                isExpanded: true,
                items:
                    subcategories
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => selectedSubcategory = val!),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('تطبيق الفلاتر'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B2F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF68316D),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.category,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: openFilterDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            if (widget.userRole == 'Charity')
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "إعلانات جمعيتك في قسم: ${widget.category}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('ads')
                        .where('category', isEqualTo: widget.category)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allAds = snapshot.data!.docs;
                  final roleFiltered =
                      widget.userRole == "Volunteer"
                          ? allAds
                          : allAds.where((doc) => doc['uid'] == uid).toList();

                  final filteredAds =
                      roleFiltered.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final subcat = data['subCategory']?.toString() ?? '';
                        final gov = data['governorate']?.toString() ?? '';

                        final matchSub =
                            selectedSubcategory == 'الكل' ||
                            subcat == selectedSubcategory;
                        final matchGov =
                            selectedGovernorate == 'الكل' ||
                            gov == selectedGovernorate;

                        return matchSub && matchGov;
                      }).toList();

                  filteredAds.sort((a, b) {
                    final aTime = a['timestamp'];
                    final bTime = b['timestamp'];
                    if (aTime is Timestamp && bTime is Timestamp) {
                      return bTime.compareTo(aTime);
                    }
                    return 0;
                  });

                  if (roleFiltered.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا يوجد إعلانات",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else if (filteredAds.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا يوجد إعلانات مطابقة",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredAds.length,
                    itemBuilder: (context, index) {
                      final ad = filteredAds[index];
                      return widget.userRole == "Volunteer"
                          ? buildVolunteerAdCard(context, ad)
                          : buildDefaultAdCard(ad, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVolunteerAdCard(BuildContext context, DocumentSnapshot ad) {
    final data = ad.data() as Map<String, dynamic>;
    final adId = ad.id;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(adId);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdDetailsPage(ad: ad)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: const Color(0xFF1E2A38),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF68316D),
                backgroundImage:
                    (data['profileImage'] != null &&
                            data['profileImage'].toString().isNotEmpty)
                        ? NetworkImage(data['profileImage'])
                        : null,
                child:
                    (data['profileImage'] == null ||
                            data['profileImage'].toString().isEmpty)
                        ? const Icon(
                          Icons.apartment,
                          color: Colors.white,
                          size: 30,
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['initiativeName'] ?? "بدون عنوان",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<String>(
                      future: getUsernameFromUid(data['uid']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "جاري تحميل الجهة الداعمة...",
                                style: TextStyle(color: Colors.white60),
                              ),
                            ],
                          );
                        }
                        final supporter = snapshot.data ?? 'غير محددة';
                        return Text(
                          "🏛 الجهة الداعمة: $supporter",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data['governorate'] != null
                          ? "📍 الموقع: ${data['governorate']}"
                          : "📍 الموقع: غير محدد",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (data['category'] == 'فرص تطوعية عامة')
                      Text(
                        "📌 نوع المبادرة: ${data['initiativeType'] ?? "غير محددة"}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.group,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data['answersSecondPage']?['كم عدد المستفيدين من الحملة؟'] ??
                              "غير معروف",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (data['date'] as Timestamp?) != null
                              ? DateFormat(
                                'yyyy-MM-dd',
                              ).format((data['date'] as Timestamp).toDate())
                              : "بدون تاريخ",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: favRef.get(),
                          builder: (context, snapshot) {
                            final isFav = snapshot.data?.exists ?? false;
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (!isFav) {
                                  await favRef.set({
                                    'adId': adId,
                                    'timestamp': Timestamp.now(),
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "تمت إضافة الإعلان إلى المفضلة ✅",
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  await favRef.delete();
                                }
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat, color: Colors.white),
                          onPressed: () {
                            final charityId = data['uid'];
                            final volunteerId =
                                FirebaseAuth.instance.currentUser!.uid;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ChatPage(
                                      currentUserId: volunteerId,
                                      otherUserId: charityId,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDefaultAdCard(DocumentSnapshot ad, BuildContext context) {
    final data = ad.data() as Map<String, dynamic>;
    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color(0xFF2E3A59),
      shadowColor: const Color.fromARGB(255, 218, 213, 213),
      shape: Border.all(color: Colors.white, width: 1),
      elevation: 5,
      child: ListTile(
        title: Text(
          data['initiativeName'] ?? 'بدون اسم',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: getUsernameFromUid(data['uid']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                final supporter = snapshot.data ?? 'غير محددة';
                return Text(
                  "🏛 الجهة الداعمة: $supporter",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              data['governorate'] != null
                  ? "📍 الموقع: ${data['governorate']}"
                  : "📍 الموقع: غير محدد",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            if (data['category'] == 'فرص تطوعية عامة')
              Text(
                "📌 نوع المبادرة: ${data['initiativeType'] ?? "غير محددة"}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        trailing: Text(
          (data['date'] as Timestamp?) != null
              ? DateFormat(
                'yyyy-MM-dd',
              ).format((data['date'] as Timestamp).toDate())
              : '',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdDetailsPage(ad: ad)),
          );
        },
      ),
    );
  }
}

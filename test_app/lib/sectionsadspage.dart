import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/addetailspage.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/chat/chatpage2.dart';

class SectionAdsPage extends StatelessWidget {
  final String category;
  final String userRole;

  const SectionAdsPage({
    super.key,
    required this.category,
    required this.userRole,
  });

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
            category,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('ads')
                  .where('category', isEqualTo: category)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final allAds = snapshot.data!.docs;
            final filteredAds =
                userRole == "Volunteer"
                    ? allAds
                    : allAds.where((doc) => doc['uid'] == uid).toList();

            filteredAds.sort((a, b) {
              final aTime = a['timestamp'];
              final bTime = b['timestamp'];
              if (aTime is Timestamp && bTime is Timestamp) {
                return bTime.compareTo(aTime);
              }
              return 0;
            });

            if (filteredAds.isEmpty) {
              return const Center(
                child: Text(
                  "لا يوجد إعلانات في هذا القسم",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userRole == "Charity")
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "إعلانات جمعيتك في قسم: $category",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAds.length,
                    itemBuilder: (context, index) {
                      final ad = filteredAds[index];
                      return userRole == "Volunteer"
                          ? buildVolunteerAdCard(context, ad)
                          : buildDefaultAdCard(ad, context);
                    },
                  ),
                ),
              ],
            );
          },
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
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/default_logo.png"),
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
                    Text(
                      data.containsKey('supporter') && data['supporter'] != null
                          ? data['supporter'].toString()
                          : "جهة غير معروفة",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
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
    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color(0xFF2E3A59),
      shadowColor: const Color.fromARGB(255, 218, 213, 213),
      shape: Border.all(color: Colors.white, width: 1),
      elevation: 5,
      child: ListTile(
        title: Text(
          ad['initiativeName'] ?? 'بدون اسم',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          ad.data().toString().contains('supporter') && ad['supporter'] != null
              ? ad['supporter'].toString()
              : 'جهة غير معروفة',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        trailing: Text(
          (ad['date'] as Timestamp?) != null
              ? DateFormat(
                'yyyy-MM-dd',
              ).format((ad['date'] as Timestamp).toDate())
              : "",
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

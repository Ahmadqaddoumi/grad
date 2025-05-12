import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/addetailspage.dart';
import 'package:intl/intl.dart';

class Favouriteadv extends StatefulWidget {
  const Favouriteadv({super.key});

  @override
  State<Favouriteadv> createState() => _FavouriteadvState();
}

class _FavouriteadvState extends State<Favouriteadv> {
  final TextEditingController _controller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF68316D),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "الإعلانات المفضلة",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF68316D),
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    suffixIcon:
                        _controller.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed:
                                  () => setState(() => _controller.clear()),
                            )
                            : const Icon(Icons.search),
                    hintText: "إبحث في إعلاناتك المفضلة",
                  ),
                  onChanged: (text) => setState(() {}),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('favourites')
                          .snapshots(),
                  builder: (context, favSnapshot) {
                    if (!favSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final favDocs = favSnapshot.data!.docs;
                    if (favDocs.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا يوجد لديك أي إعلان مفضل",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    final favIds = favDocs.map((doc) => doc.id).toList();

                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('ads')
                              .where(FieldPath.documentId, whereIn: favIds)
                              .snapshots(),
                      builder: (context, adSnapshot) {
                        if (!adSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final ads = adSnapshot.data!.docs;

                        return ListView.builder(
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index];
                            return buildVolunteerAdCard(context, ad);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
        color: const Color(0xFF2A2940),
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
                  ],
                ),
              ),
              FutureBuilder<DocumentSnapshot>(
                future: favRef.get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    );
                  }

                  final isFav = snapshot.data!.exists;
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (isFav) {
                        await favRef.delete();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تمت إزالة الإعلان من المفضلة"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        setState(() {});
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

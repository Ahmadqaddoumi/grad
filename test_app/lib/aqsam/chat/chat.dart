import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/aqsam/chat/chatpage2.dart';

class MyChatsPage extends StatelessWidget {
  const MyChatsPage({super.key});

  String getOtherUserId(String chatId, String currentUserId) {
    final ids = chatId.split('_');
    return ids[0] == currentUserId ? ids[1] : ids[0];
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('دردشاتي', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF68316D),
      ),
      backgroundColor: const Color(0xFFF3E9F3),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats =
              snapshot.data!.docs
                  .where((doc) => doc.id.contains(currentUserId))
                  .toList();

          if (chats.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد محادثات بعد",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final otherUserId = getOtherUserId(chatDoc.id, currentUserId);

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(otherUserId)
                        .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const ListTile(
                      title: Text("جارٍ تحميل المستخدم..."),
                    );
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final username = userData['username'] ?? 'مستخدم';
                  final accountType = userData['accountType'] ?? 'حساب';

                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text("محادثة مع: $username"),
                    subtitle: Text("نوع الحساب: $accountType"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatPage(
                                currentUserId: currentUserId,
                                otherUserId: otherUserId,
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

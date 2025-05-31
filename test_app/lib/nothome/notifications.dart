import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/chat/chatpage2.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  Future<void> deleteAllNotifications(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance
            .collection('notifications')
            .where('toUserId', isEqualTo: userId)
            .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم حذف جميع الإشعارات بنجاح")),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("الإشعارات"),
        backgroundColor: const Color(0xff68316d),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "حذف كل الإشعارات",
            onPressed: () => deleteAllNotifications(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .where('toUserId', isEqualTo: userId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data?.docs ?? [];

          notifications.sort((a, b) {
            final aTimestamp = a['timestamp'] as Timestamp?;
            final bTimestamp = b['timestamp'] as Timestamp?;
            if (aTimestamp == null || bTimestamp == null) return 0;
            return bTimestamp.compareTo(aTimestamp);
          });

          if (notifications.isEmpty) {
            return const Center(child: Text("لا توجد إشعارات حالياً"));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'بدون عنوان';
              final message = data['message'] ?? '';
              final type = data['type'] ?? 'other';
              final read = data['read'] ?? false;
              final fromUserId = data['fromUserId'];
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              String formattedTime = '';
              if (timestamp != null) {
                final time = DateFormat.Hm().format(timestamp);
                final date = DateFormat('dd-MM-yyyy').format(timestamp);
                formattedTime = '🕒 $time - 📅 $date';
              }

              return FutureBuilder<Map<String, dynamic>?>(
                future:
                    type == 'message'
                        ? getUserData(fromUserId)
                        : Future.value(null),
                builder: (context, snapshot) {
                  final userData = snapshot.data;
                  final senderName = userData?['username'] ?? 'مستخدم';
                  final senderImage = userData?['profileImage'];

                  return Dismissible(
                    key: Key(doc.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("تأكيد الحذف"),
                              content: Text("هل تريد حذف الإشعار: $title؟"),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("إلغاء"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed: (_) async {
                      await doc.reference.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("🗑️ تم حذف الإشعار")),
                      );
                    },
                    child: ListTile(
                      leading:
                          type == 'message'
                              ? senderImage != null
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(senderImage),
                                  )
                                  : const CircleAvatar(
                                    child: Icon(Icons.person),
                                  )
                              : Icon(
                                type == 'admin'
                                    ? Icons.admin_panel_settings
                                    : Icons.notifications,
                                color:
                                    type == 'admin'
                                        ? Colors.deepPurple
                                        : Colors.grey,
                              ),
                      title: Text(
                        type == 'message' ? 'رسالة من $senderName' : title,
                      ),
                      subtitle: Text(formattedTime),
                      trailing: Icon(
                        read ? Icons.mark_email_read : Icons.mark_email_unread,
                        color: read ? Colors.green : Colors.red,
                      ),
                      onTap: () async {
                        if (!read) {
                          await doc.reference.update({'read': true});
                        }

                        if (type == 'message') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatPage(
                                    currentUserId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    otherUserId: fromUserId,
                                  ),
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text(title),
                                  content: Text(message),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("إغلاق"),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                    ),
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

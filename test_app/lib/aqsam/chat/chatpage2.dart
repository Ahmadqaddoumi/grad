import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  String get chatId {
    final ids = [widget.currentUserId, widget.otherUserId]..sort();
    return ids.join('_');
  }

  Future<void> ensureChatDocumentExists() async {
    final chatDoc = FirebaseFirestore.instance.collection('chat').doc(chatId);
    final exists = (await chatDoc.get()).exists;
    if (!exists) {
      await chatDoc.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  @override
  void initState() {
    super.initState();
    ensureChatDocumentExists();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("الدردشة", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF68316D),
        ),
        backgroundColor: const Color(0xFFF3E9F3),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chat')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data =
                          messages[index].data() as Map<String, dynamic>;
                      final isMe = data['senderId'] == widget.currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.purple[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(data['message'] ?? ''),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "اكتب رسالتك...",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.purple),
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isEmpty) return;

                      // أرسل الرسالة
                      await FirebaseFirestore.instance
                          .collection('chat')
                          .doc(chatId)
                          .collection('messages')
                          .add({
                            'senderId': widget.currentUserId,
                            'receiverId': widget.otherUserId,
                            'message': text,
                            'timestamp': Timestamp.now(),
                          });

                      // جلب اسم المرسل من Firestore
                      final senderDoc =
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.currentUserId)
                              .get();

                      final senderName =
                          senderDoc.data()?['username'] ?? 'مستخدم مجهول';

                      // أرسل إشعار بالإسم
                      await FirebaseFirestore.instance
                          .collection('notifications')
                          .add({
                            'toUserId': widget.otherUserId,
                            'fromUserId': widget.currentUserId,
                            'title': '📩 رسالة جديدة من $senderName',
                            'message': text,
                            'type': 'message',
                            'timestamp': Timestamp.now(),
                            'read': false,
                          });

                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

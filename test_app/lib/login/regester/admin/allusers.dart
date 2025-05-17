import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "جميع المستخدمين",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xff68316d),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "بحث عن اسم المستخدم",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allUsers = snapshot.data?.docs ?? [];

                  final filteredUsers =
                      allUsers.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final username =
                            data['username']?.toString().toLowerCase() ?? '';
                        return username.contains(searchQuery);
                      }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text("لا يوجد مستخدمين مطابقين."),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final data = user.data() as Map<String, dynamic>;

                      final username = data['username'] ?? 'بدون اسم';
                      final email = data['email'] ?? 'غير معروف';
                      final accountType = data['accountType'] ?? 'غير محدد';
                      final isActive = data['isActive'] ?? true;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(username),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("📧 $email"),
                              Text("👤 نوع الحساب: $accountType"),
                              Text(
                                "⚙️ الحالة: ${isActive ? "مفعل ✅" : "موقوف ❌"}",
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isActive ? Icons.lock_open : Icons.lock,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.id)
                                      .update({'isActive': !isActive});

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "تم ${isActive ? "إيقاف" : "تفعيل"} حساب $username",
                                      ),
                                    ),
                                  );
                                },
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
                                            "هل تريد حذف حساب $username؟",
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
                                        .collection('users')
                                        .doc(user.id)
                                        .delete();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("تم حذف حساب $username"),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
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
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/home.dart';

class ChooseAccountTypeAfterGoogle extends StatefulWidget {
  final String uid;

  const ChooseAccountTypeAfterGoogle({super.key, required this.uid});

  @override
  State<ChooseAccountTypeAfterGoogle> createState() =>
      _ChooseAccountTypeAfterGoogleState();
}

class _ChooseAccountTypeAfterGoogleState
    extends State<ChooseAccountTypeAfterGoogle> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xff68316d),
        elevation: 0,
        title: const Text(
          'اختر نوع الحساب',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xff68316d),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: const Color(0xff68316d),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      TextEditingController serialController =
                          TextEditingController();

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "الرجاء إدخال الرقم التسلسلي للمنظمة",
                            ),
                            content: TextField(
                              controller: serialController,
                              decoration: const InputDecoration(
                                hintText: "أدخل الرقم التسلسلي هنا",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("إلغاء"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  String serial = serialController.text.trim();

                                  if (serial.isNotEmpty) {
                                    DocumentSnapshot serialDoc =
                                        await FirebaseFirestore.instance
                                            .collection('serial_numbers')
                                            .doc(serial)
                                            .get();

                                    if (serialDoc.exists) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.uid)
                                          .set({
                                            'uid': widget.uid,
                                            'username':
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .displayName,
                                            'email':
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .email,
                                            'accountType': 'Charity',
                                            'serialNumber': serial,
                                          });

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const Home(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'الرقم التسلسلي غير صحيح أو غير موجود',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text("تأكيد"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "تسجيل كمنظمة",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: const Color(0xff68316d),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .set({
                            'uid': widget.uid,
                            'username':
                                FirebaseAuth.instance.currentUser!.displayName,
                            'email': FirebaseAuth.instance.currentUser!.email,
                            'accountType': 'Volunteer',
                          });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    child: const Text(
                      "تسجيل كمتطوع",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

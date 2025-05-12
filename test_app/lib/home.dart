import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_app/aqsam/addelement.dart/add.dart';
import 'package:test_app/aqsam/chat/chat.dart';
import 'package:test_app/aqsam/notification/not.dart';
import 'package:test_app/aqsam/profilee/profile.dart';
import 'package:test_app/homeeee.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String? accountType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAccountType();
  }

  Future<void> getAccountType() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          accountType = doc.data()?['accountType'];
          isLoading = false;
        });
      }
    }
  }

  Widget navItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 35, color: Colors.white),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> volunteerPages = [
      HomePage(userRole: accountType!),
      const ChatPage(),
      const ProfilePage(),
    ];

    final List<Widget> charityPages = [
      HomePage(userRole: accountType!),
      const ChatPage(),
      const AddPostPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];

    final List<Widget> currentPages =
        accountType == "Volunteer" ? volunteerPages : charityPages;

    final List<Widget> currentNavItems =
        accountType == "Volunteer"
            ? [
              navItem(Icons.home, "الرئيسية"),
              navItem(Icons.chat, "الدردشة"),
              navItem(Icons.person, "حسابي"),
            ]
            : [
              navItem(Icons.home, "الرئيسية"),
              navItem(Icons.chat, "الدردشة"),
              navItem(Icons.add, "إضافة"),
              navItem(Icons.campaign, "إعلاناتي"),
              navItem(Icons.person, "حسابي"),
            ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _selectedIndex, children: currentPages),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: const Color(0xFF68316D),
          buttonBackgroundColor: const Color(0xFF68316D),
          height: 75,
          animationDuration: const Duration(milliseconds: 300),
          index: _selectedIndex,
          items: currentNavItems,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

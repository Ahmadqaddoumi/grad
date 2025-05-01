import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:test_app/aqsam/addelement.dart/add.dart';
import 'package:test_app/aqsam/chat/chat.dart';
import 'package:test_app/aqsam/notification/not.dart';
import 'package:test_app/aqsam/profilee/profile.dart';
import 'package:test_app/homeeee.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // الصفحة الافتراضية هي الرئيسية

  List<String> images = [
    'image/assets/a.jpg',
    'image/assets/b.jpg',
    'image/assets/c.jpg',
    'image/assets/d.jpg',
  ];

  // قائمة الصفحات
  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const AddPostPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _selectedIndex, children: _pages),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: const Color(0xFF68316D),
          buttonBackgroundColor: const Color(0xFF68316D),
          height: 75,
          animationDuration: const Duration(milliseconds: 300),
          index: _selectedIndex,
          items: const <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, size: 35, color: Colors.white),
                  Text(
                    "الرئيسية",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat, size: 35, color: Colors.white),
                  Text(
                    "الدردشة",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 35, color: Colors.white),
                  Text(
                    "إضافة",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign, size: 35, color: Colors.white),
                  Text(
                    "إعلاناتي",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 35, color: Colors.white),
                  Text(
                    "حسابي",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
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

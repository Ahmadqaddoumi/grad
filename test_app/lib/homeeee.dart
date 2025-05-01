import 'package:flutter/material.dart';
import 'package:test_app/aqsam/agsam.dart';
import 'package:test_app/aqsam/favourite/favouriteadv.dart';
import 'package:test_app/image/classimage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> images = [
    'image/assets/a.jpg',
    'image/assets/b.jpg',
    'image/assets/c.jpg',
    'image/assets/d.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "إحسان",
                style: TextStyle(
                  fontFamily: 'ahmad',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF68316D),
                ),
              ),
              const Expanded(child: SizedBox()),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Favouriteadv(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.favorite_sharp,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 8,
                  right: 3,
                ),
                child: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.notifications, size: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 200, child: Ahmad(l: images)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                              });
                            },
                          )
                          : const Icon(Icons.search),
                  hintText: "البحث",
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "الاقسام",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 140,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),

              shrinkWrap: true,

              padding: const EdgeInsets.all(16),
              children: [
                Agsam(
                  title: "احتياجات الجمعيات",
                  icon: Icons.business_sharp,
                  onchange: () {},
                ),
                Agsam(title: "بيئي", icon: Icons.spa, onchange: () {}),
                Agsam(
                  title: "الفعاليات والمساعدات الاجتماعية",
                  icon: Icons.volunteer_activism,
                  onchange: () {},
                ),
                Agsam(
                  title: "فرص تطوعية عامة",
                  icon: Icons.handshake,
                  onchange: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/addagsam.dart';
import 'package:test_app/aqsam/addelement.dart/addclass.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _controller = TextEditingController();

  List<Qesem> qsm = [
    Qesem(title: "احتياجات الجمعيات", icon: Icons.business_sharp),
    Qesem(title: "بيئي", icon: Icons.spa),
    Qesem(
      title: "الفعاليات والمساعدات الاجتماعية",
      icon: Icons.volunteer_activism,
    ),
    Qesem(title: "فرص تطوعية عامة", icon: Icons.handshake),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "إختر القسم ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13),
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
                    fillColor: Colors.grey[50],
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
                    hintText: "إبحث في إعلاناتك المفضلة",
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: qsm.length,
                  itemBuilder: (context, index) {
                    return Addagsam(qsm1: qsm[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

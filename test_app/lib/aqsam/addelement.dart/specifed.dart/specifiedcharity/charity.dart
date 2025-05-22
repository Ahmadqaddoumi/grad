import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/addagsam.dart';
import 'package:test_app/aqsam/addelement.dart/addclass.dart';

class Charity extends StatefulWidget {
  const Charity({super.key});

  @override
  State<Charity> createState() => _CharityState();
}

class _CharityState extends State<Charity> {
  final TextEditingController _controller = TextEditingController();

  List<Qesem> allCharity = [
    Qesem(title: "الدعم المالي والتبرعات النقدية", icon: Icons.attach_money),
    Qesem(title: "التبرعات العينية (ملابس وغذاء..)", icon: Icons.food_bank),
    Qesem(title: "البحث عن متطوعين", icon: Icons.groups),
    Qesem(title: "صيانة وتطوير مقرات الجمعيات", icon: Icons.business_sharp),
  ];

  List<Qesem> get filteredCharity {
    final query = _controller.text.trim();
    if (query.isEmpty) return allCharity;
    return allCharity.where((item) => item.title.contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF68316D),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.business_sharp,
                      color: Color(0xffce9dd2),
                      size: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "احتياجات الجمعيات",
                        style: TextStyle(
                          color: Color(0xffce9dd2),
                          fontSize: 25,
                        ),
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
                    hintText: "البحث",
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCharity.length,
                  itemBuilder: (context, index) {
                    return Addagsam(qsm1: filteredCharity[index]);
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

import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/addagsam.dart';
import 'package:test_app/aqsam/addelement.dart/addclass.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final TextEditingController _controller = TextEditingController();

  List<Qesem> allActivities = [
    Qesem(
      title: "تنظيم رحلة ترفيهية للأيتام",
      icon: Icons.sentiment_satisfied_alt,
    ),
    Qesem(title: " تنظيم إفطار جماعي في رمضان", icon: Icons.fastfood),
    Qesem(title: "مساعدة كبار السن في الوصول الى المستشفى", icon: Icons.help),
  ];

  List<Qesem> get filteredActivities {
    final query = _controller.text.trim();
    if (query.isEmpty) return allActivities;
    return allActivities
        .where((activity) => activity.title.contains(query))
        .toList();
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
                      Icons.volunteer_activism,
                      color: Color(0xffce9dd2),
                      size: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "الفعاليات والمساعدات الاجتماعية",
                        style: TextStyle(
                          color: Color(0xffce9dd2),
                          fontSize: 20,
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
                  itemCount: filteredActivities.length,
                  itemBuilder: (context, index) {
                    return Addagsam(qsm1: filteredActivities[index]);
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

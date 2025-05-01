import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/voulnteer/customvolunteer.dart';

// ignore: must_be_immutable
class Volunteer extends StatefulWidget {
  const Volunteer({super.key});

  @override
  State<Volunteer> createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  DateTime? selectedDate;
  String formattedDate = 'اختر تاريخ النشاط';

  List<Question> publicvolunteer = [
    Question(
      questionText: 'كم عدد المستفيدين؟',
      options: [
        '👤 أقل من 50 شخصًا',
        '👥 بين 50 و200 شخص',
        '👨‍👩‍👧‍👦 أكثر من 200 شخص',
      ],
    ),
    Question(
      questionText: 'ما الفئة المستهدفة؟',
      options: ['🏠 أيتام', '👴 كبار السن', '🏚️ أسر محتاجة', '🏢 طلاب جامعات'],
    ),
    Question(
      questionText: 'ما موقع الإفطار؟',
      options: ['🕌 مسجد', '🏠 دار أيتام', '🌳 مكان عام'],
    ),
    Question(
      questionText: 'هل يحتاج المنظمون إلى متطوعين؟',
      options: ['✅ نعم، نحتاج طهاة ومتطوعين', '❌ لا، الطاقم متوفر'],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),
  ];

  // ignore: unused_element
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
                        "فرص تطوعية عامة",
                        style: TextStyle(
                          color: Color(0xffce9dd2),
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: publicvolunteer.length + 7,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Customvolunteer(nametxt: "اسم المبادرة");
                    } else if (index == 1) {
                      return const Customvolunteer(nametxt: "نوع المبادرة");
                    } else if (index == 2) {
                      return const Customvolunteer(
                        nametxt: "الهدف من المبادرة",
                      );
                    } else if (index == 3) {
                      return const Customvolunteer(
                        nametxt: "ما هو موقع النشاط",
                      );
                    } else if (index == 4) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '📅 $formattedDate',
                              style: const TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff7433d3),
                              ),
                              child: const Text(
                                'اختر التاريخ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (index <= publicvolunteer.length + 4) {
                      return Customshape(question1: publicvolunteer[index - 5]);
                    } else if (index == publicvolunteer.length + 5) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Customvolunteer(nametxt: "ملاحظات"),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {},

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF68316D),
                          ),

                          child: const Text(
                            "نشر الإعلان",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      );
                    }
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

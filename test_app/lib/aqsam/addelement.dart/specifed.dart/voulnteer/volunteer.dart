import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/voulnteer/customvolunteer.dart';
import 'package:test_app/home.dart';

class Volunteer extends StatefulWidget {
  const Volunteer({super.key});

  @override
  State<Volunteer> createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  DateTime? selectedDate;
  String formattedDate = 'اختر تاريخ النشاط';

  final _initiativeController = TextEditingController();
  final _supporterController = TextEditingController();
  final _typeController = TextEditingController();
  final _goalController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();

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

  Future<void> _submitAd() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answers = <String, String>{};

    for (var q in publicvolunteer) {
      if (q.selectedOption != null) {
        answers[q.questionText] = q.selectedOption!;
      }
    }

    if (uid == null ||
        _initiativeController.text.trim().isEmpty ||
        _supporterController.text.trim().isEmpty ||
        _typeController.text.trim().isEmpty ||
        _goalController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _noteController.text.trim().isEmpty ||
        selectedDate == null ||
        answers.length != publicvolunteer.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول بشكل كامل")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('ads').add({
      'uid': uid,
      'supporter': _supporterController.text.trim(),
      'initiativeName': _initiativeController.text.trim(),
      'initiativeType': _typeController.text.trim(),
      'initiativeGoal': _goalController.text.trim(),
      'location': _locationController.text.trim(),
      'note': _noteController.text.trim(),
      'date': selectedDate,
      'category': 'فرص تطوعية عامة',
      'subCategory': Icons.handshake.codePoint,
      'answersFirstPage': {},
      'answersSecondPage': answers,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم نشر الإعلان بنجاح ✅")));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    Customvolunteer(
                      nametxt: "اسم الجمعية",
                      controller: _supporterController,
                    ),

                    Customvolunteer(
                      nametxt: "اسم المبادرة",
                      controller: _initiativeController,
                    ),
                    Customvolunteer(
                      nametxt: "نوع المبادرة",
                      controller: _typeController,
                    ),
                    Customvolunteer(
                      nametxt: "الهدف من المبادرة",
                      controller: _goalController,
                    ),
                    Customvolunteer(
                      nametxt: "ما هو موقع النشاط",
                      controller: _locationController,
                    ),
                    Padding(
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
                    ),
                    for (var question in publicvolunteer)
                      Customshape(question1: question),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _noteController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "ملاحظات",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff7433d3),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _submitAd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF68316D),
                        ),
                        child: const Text(
                          "نشر الإعلان",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

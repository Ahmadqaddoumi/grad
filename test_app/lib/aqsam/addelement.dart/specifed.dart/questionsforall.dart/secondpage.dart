import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';
import 'package:test_app/home.dart';

class Secondpage extends StatefulWidget {
  final List<Question> questionssecond;
  final Map<String, String> answersFirstPage;
  final String nameqesem3;
  final IconData icon1;
  final String initiativeName;
  final String supporter;
  final String subCategoryName;
  final List<String> imageUrls; // ✅ جديد

  const Secondpage({
    super.key,
    required this.questionssecond,
    required this.answersFirstPage,
    required this.nameqesem3,
    required this.icon1,
    required this.initiativeName,
    required this.supporter,
    required this.subCategoryName,
    required this.imageUrls, // ✅ جديد
  });

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  final TextEditingController _noteController = TextEditingController();
  DateTime? selectedDate;
  String formattedDate = 'اختر تاريخ النشاط';

  String? selectedGovernorate;
  final List<String> jordanGovernorates = [
    'عمان',
    'الزرقاء',
    'إربد',
    'العقبة',
    'البلقاء',
    'المفرق',
    'معان',
    'الطفيلة',
    'الكرك',
    'جرش',
    'عجلون',
    'مأدبا',
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    widget.nameqesem3,
                    style: const TextStyle(
                      color: Color(0xffce9dd2),
                      fontSize: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      widget.icon1,
                      color: const Color(0xffce9dd2),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.questionssecond.length + 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'اختر المحافظة',
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
                              value: selectedGovernorate,
                              items:
                                  jordanGovernorates.map((governorate) {
                                    return DropdownMenuItem<String>(
                                      value: governorate,
                                      child: Text(governorate),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedGovernorate = value;
                                });
                              },
                            ),
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
                                    backgroundColor: const Color(0xff68316D),
                                  ),
                                  child: const Text(
                                    'اختر التاريخ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (index <= widget.questionssecond.length) {
                      return Customshape(
                        question1: widget.questionssecond[index - 1],
                      );
                    } else if (index == widget.questionssecond.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _noteController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "ملاحظات (اختياري)",
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
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final note =
                                _noteController.text.trim().isEmpty
                                    ? 'لا يوجد ملاحظات'
                                    : _noteController.text.trim();

                            final selectedAnswers = <String, String>{};
                            for (var q in widget.questionssecond) {
                              if (q.selectedOption != null) {
                                selectedAnswers[q.questionText] =
                                    q.selectedOption!;
                              }
                            }

                            final uid = FirebaseAuth.instance.currentUser?.uid;

                            if (uid == null ||
                                selectedGovernorate == null ||
                                selectedDate == null ||
                                selectedAnswers.length !=
                                    widget.questionssecond.length ||
                                widget.answersFirstPage.length !=
                                    widget.answersFirstPage.keys.length) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يرجى تعبئة جميع الحقول بشكل كامل',
                                  ),
                                ),
                              );
                              return;
                            }

                            final userDoc =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .get();
                            final profileImage =
                                userDoc.data()?['profileImage'] ?? '';

                            await FirebaseFirestore.instance
                                .collection('ads')
                                .add({
                                  'uid': uid,
                                  'category': widget.nameqesem3,
                                  'subCategory': widget.subCategoryName,
                                  'supporter': widget.supporter,
                                  'initiativeName': widget.initiativeName,
                                  'governorate': selectedGovernorate,
                                  'note': note,
                                  'date': selectedDate,
                                  'answersFirstPage': widget.answersFirstPage,
                                  'answersSecondPage': selectedAnswers,
                                  'timestamp': Timestamp.now(),
                                  'profileImage': profileImage,
                                  'imageUrls':
                                      widget.imageUrls, // ✅ حفظ الصور هنا
                                });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نشر الإعلان بنجاح'),
                              ),
                            );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                              (route) => false,
                            );
                          },
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

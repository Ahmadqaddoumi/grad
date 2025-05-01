import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Secondpage extends StatefulWidget {
  List<Question> questionssecond;
  final String nameqesem3;
  final IconData icon1;
  Secondpage({
    super.key,
    required this.questionssecond,
    required this.nameqesem3,
    required this.icon1,
  });

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  final TextEditingController _loctionController = TextEditingController();
  DateTime? selectedDate;
  String formattedDate = 'اختر تاريخ النشاط';

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
                          // حقل الموقع
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 60,
                              right: 10,
                              top: 20,
                              bottom: 10,
                            ),
                            child: TextField(
                              controller: _loctionController,

                              decoration: const InputDecoration(
                                hintText: "ما هو موقع النشاط",

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

                          // اختيار التاريخ
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
                        ],
                      );
                    } else if (index <= widget.questionssecond.length) {
                      return Customshape(
                        question1: widget.questionssecond[index - 1],
                      );
                    } else if (index == widget.questionssecond.length + 1) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          decoration: InputDecoration(
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
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // يمكنك استخدام selectedDate هنا
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

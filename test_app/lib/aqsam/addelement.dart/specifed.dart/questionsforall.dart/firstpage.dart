import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/secondpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Firstpage extends StatefulWidget {
  List<Question> questionsf;
  List<Question> questionsf2;
  final String nameqesem2;
  final IconData icon;

  Firstpage({
    super.key,
    required this.questionsf,
    required this.questionsf2,
    required this.nameqesem2,
    required this.icon,
  });

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final TextEditingController _initiativeController = TextEditingController();
  final TextEditingController _supporterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.questionsf.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 60,
                right: 10,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _supporterController,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: "اسم الجمعية",
                      hintTextDirection: TextDirection.rtl,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff7433d3),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _initiativeController,
                    decoration: const InputDecoration(
                      hintText: "اسم المبادرة",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff7433d3),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (index <= widget.questionsf.length) {
            return Customshape(question1: widget.questionsf[index - 1]);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final Map<String, String> answersFirstPage = {};
                  for (var q in widget.questionsf) {
                    if (q.selectedOption != null) {
                      answersFirstPage[q.questionText] = q.selectedOption!;
                    }
                  }

                  if (_initiativeController.text.trim().isEmpty ||
                      _supporterController.text.trim().isEmpty ||
                      answersFirstPage.length != widget.questionsf.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى تعبئة جميع الحقول قبل المتابعة'),
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Secondpage(
                          questionssecond: widget.questionsf2,
                          nameqesem3: widget.nameqesem2,
                          icon1: widget.icon,
                          supporter: _supporterController.text.trim(),

                          initiativeName: _initiativeController.text.trim(),
                          answersFirstPage: answersFirstPage,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68316D),
                ),
                child: const Text(
                  "التالي",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

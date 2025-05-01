import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/secondpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Firstpage extends StatelessWidget {
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
  final String buttontext = "التالي";
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: questionsf.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(
                left: 60,
                right: 10,
                top: 20,
                bottom: 20,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "اسم المبادرة",

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff7433d3), width: 3),
                  ),
                ),
              ),
            );
          } else if (index <= questionsf.length) {
            return Customshape(question1: questionsf[index - 1]);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Secondpage(
                          questionssecond: questionsf2,
                          nameqesem3: nameqesem2,
                          icon1: icon,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68316D),
                ),

                child: Text(
                  buttontext,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Triporg extends StatelessWidget {
  Triporg({super.key});

  List<Question> orgTripQuestions = [
    Question(
      questionText: 'ما الفئة العمرية المستهدفة؟',
      options: [
        '👶 أطفال (3-7 سنوات)',
        '👦👧 أطفال (8-12 سنة)',
        '🧑‍🎓 مراهقون (13-18 سنة)',
      ],
    ),
    Question(
      questionText: 'كم عدد الأيتام المشاركين؟',
      options: ['👤 أقل من 10', '👥 بين 10 و30', '👨‍👩‍👧‍👦 أكثر من 30'],
    ),

    Question(
      questionText: 'هل هناك حاجة لمواصلات لنقل الأيتام؟',
      options: ['✅ نعم، نحتاج باصات', '❌ لا، سيتم النقل بوسائل أخرى'],
    ),
    Question(
      questionText: 'هل سيتم توفير شهادات تطوع؟',
      options: ['✅ نعم، سيتم إصدار شهادات', '❌ لا، العمل تطوعي فقط'],
    ),
    Question(
      questionText: 'كم يستغرق النشاط من وقت؟',
      options: [
        '⏳ أقل من ساعتين',
        '⏰ من ساعتين إلى أربع ساعات',
        '🕒 أكثر من أربع ساعات',
      ],
    ),
  ];

  List<Question> orgTripQuestions2 = [
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: ['✅ نعم، يوجد دعم للمتطوعين', '❌ لا، المتطوع مسؤول عن ذلك'],
    ),

    Question(
      questionText: 'هل هناك أنشطة مبرمجة خلال الرحلة؟',
      options: ['✅ نعم، أنشطة ترفيهية وتعليمية', '❌ لا، الرحلة فقط للترفيه'],
    ),
    Question(
      questionText: 'ما الميزانية المتاحة للرحلة؟',
      options: ['💵 محددة مسبقًا', '❓ تعتمد على التبرعات'],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),

    Question(
      questionText: ' ما الهدف من تنظيم رحلة للأيتام؟',
      options: [
        '🎉 إدخال البهجة على قلوبهم',
        '🤝 دمجهم في المجتمع',
        '🌳 منحهم تجربة ترفيهية مفيدة',
        '📸 خلق ذكريات سعيدة لهم',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "الفعاليات والمساعدات الإجتماعية",
                    style: TextStyle(color: Color(0xffce9dd2), fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.volunteer_activism,
                      color: Color(0xffce9dd2),
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 80,
                  right: 10,
                  bottom: 7,
                  top: 10,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF68316D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "تنظيم رحلة ترفيهية للأيتام",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Firstpage(
                questionsf: orgTripQuestions,
                questionsf2: orgTripQuestions2,
                nameqesem2: "الفعاليات والمساعدات الإجتماعية",
                icon: Icons.volunteer_activism,
                nameqesem4: "تنظيم رحلة ترفيهية للأيتام",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

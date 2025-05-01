import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Cleanpublic extends StatelessWidget {
  Cleanpublic({super.key});

  List<Question> cleaningActivityQuestions = [
    Question(
      questionText: 'ما نوع المكان المستهدف؟',
      options: [
        '🏖️ شواطئ',
        '🌳 حدائق عامة',
        '🏙️ شوارع وأحياء سكنية',
        '🏞️ غابات ومحميات',
      ],
    ),
    Question(
      questionText: 'هل سيتم توفير أكياس القمامة والقفازات؟',
      options: [
        '✅ نعم، الجمعية ستوفر الأدوات',
        '❌ لا، على المتطوعين إحضار أدواتهم',
      ],
    ),
    Question(
      questionText: 'ما عدد المتطوعين المطلوب؟',
      options: [
        '👤 أقل من 10 متطوعين',
        '👥 من 10 إلى 30 متطوعًا',
        '👨‍👩‍👧‍👦 أكثر من 30 متطوعًا',
      ],
    ),
    Question(
      questionText: 'ما هي المخلفات المتوقع جمعها؟',
      options: [
        '🗑 نفايات منزلية',
        '♻️ مواد قابلة للتدوير',
        '⚠️ نفايات خطرة (بطاريات، زيوت...)',
      ],
    ),
    Question(
      questionText: 'هل سيتم توفير شهادات تطوع؟',
      options: ['✅ نعم، سيتم إصدار شهادات', '❌ لا، العمل تطوعي فقط'],
    ),
  ];
  List<Question> cleaningActivityQuestions2 = [
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: ['✅ نعم، يوجد دعم للمتطوعين', '❌ لا، المتطوع مسؤول عن ذلك'],
    ),

    Question(
      questionText: 'كم يستغرق النشاط من وقت؟',
      options: [
        '⏳ أقل من ساعتين',
        '⏰ من ساعتين إلى أربع ساعات',
        '🕒 أكثر من أربع ساعات',
      ],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),

    Question(
      questionText: 'ما الهدف من تنظيف الأماكن العامة؟',
      options: [
        ' تحسين مظهر الحي أو المكان',
        ' تقليل المخاطر الصحية',
        ' تعزيز ثقافة النظافة',
        ' إشراك المجتمع في العمل التطوعي',
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
                    "بيئي",
                    style: TextStyle(color: Color(0xffce9dd2), fontSize: 25),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.spa, color: Color(0xffce9dd2), size: 25),
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
                    color: const Color(0xFF68316D), // اللون البنفسجي
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.cleaning_services_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "حملة تنظيف الأماكن العامة",
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
                questionsf: cleaningActivityQuestions,
                questionsf2: cleaningActivityQuestions2,
                nameqesem2: "بيئي",
                icon: Icons.spa,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Searchvolunteer extends StatelessWidget {
  Searchvolunteer({super.key});

  List<Question> volunteerWorkQuestions = [
    Question(
      questionText: 'ما نوع العمل التطوعي المطلوب؟',
      options: [
        '🏗️ عمل ميداني',
        '💻 دعم تقني وإداري',
        '🎓 تدريب وتعليم',
        '🎉 تنظيم فعالية خاصة',
      ],
    ),
    Question(
      questionText: 'هل يحتاج المتطوع إلى مهارات خاصة؟',
      options: ['✅ نعم، مهارات محددة', '❌ لا، أي شخص يمكنه المشاركة'],
    ),
    Question(
      questionText: 'ما عدد المتطوعين المطلوب؟',
      options: [
        '👤 أقل من 5 متطوعين',
        '👥 من 5 إلى 20 متطوعًا',
        '👨‍👩‍👧‍👦 أكثر من 20 متطوعًا',
      ],
    ),
    Question(
      questionText: 'ما مدة التطوع المطلوبة؟',
      options: ['⏳ بضع ساعات', '📅 عدة أيام', '🗓️ فترة طويلة'],
    ),

    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),
  ];

  List<Question> volunteerWorkQuestions2 = [
    Question(
      questionText: 'هل سيتم توفير تدريب للمتطوعين؟',
      options: ['✅ نعم، هناك جلسة تدريبية', '❌ لا، العمل مباشرة'],
    ),
    Question(
      questionText: 'هل سيتم توفير شهادات تطوع؟',
      options: ['✅ نعم، سيتم إصدار شهادات', '❌ لا، العمل تطوعي فقط'],
    ),
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: ['✅ نعم، يوجد دعم للمتطوعين', '❌ لا، المتطوع مسؤول عن ذلك'],
    ),
    Question(
      questionText: 'هل العمل سيتم ضمن فريق أم فردي؟',
      options: ['👥 ضمن فريق', '👤 فردي'],
    ),
    Question(
      questionText: 'هل يمكن التطوع عن بعد؟',
      options: ['✅ نعم، متاح عبر الإنترنت', '❌ لا، يجب الحضور شخصيًا'],
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
                    "احتياجات الجمعيات",
                    style: TextStyle(color: Color(0xffce9dd2), fontSize: 25),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.business_sharp,
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
                        Icon(Icons.groups, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "البحث عن متطوعين",
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
                questionsf: volunteerWorkQuestions,
                questionsf2: volunteerWorkQuestions2,
                nameqesem2: "احتياجات الجمعيات",
                icon: Icons.business_sharp,
                nameqesem4: 'البحث عن متطوعين',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

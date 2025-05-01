import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Maintinance extends StatelessWidget {
  Maintinance({super.key});

  List<Question> maintenanceQuestions = [
    Question(
      questionText: 'ما نوع الصيانة المطلوبة؟',
      options: [
        '🏠 إصلاحات إنشائية',
        '💡 تركيب كهرباء وإضاءة',
        '🚰 سباكة ومياه',
        '🎨 دهان وتجديد',
      ],
    ),
    Question(
      questionText: 'هل يتطلب العمل معدات خاصة؟',
      options: ['✅ نعم، معدات مهنية', '❌ لا، أدوات يدوية فقط'],
    ),
    Question(
      questionText: 'هل سيتم توفير المواد والأدوات للمتطوعين؟',
      options: ['✅ نعم، الجمعية توفرها', '❌ لا، يفضل إحضار أدوات شخصية'],
    ),
    Question(
      questionText: 'ما حجم العمل المطلوب؟',
      options: ['🔧 إصلاحات بسيطة', '🏠 أعمال متوسطة', '🏗️ صيانة شاملة'],
    ),
    Question(
      questionText: 'ما مدة التطوع المطلوبة؟',
      options: ['⏳ بضع ساعات', '📅 عدة أيام', '🗓️ فترة طويلة'],
    ),
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: ['✅ نعم، يوجد دعم للمتطوعين', '❌ لا، المتطوع مسؤول عن ذلك'],
    ),
  ];

  List<Question> maintenanceQuestions2 = [
    Question(
      questionText: 'هل سيتم توفير تدريب للمتطوعين؟',
      options: ['✅ نعم، هناك جلسة تدريبية', '❌ لا، العمل مباشرة'],
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
      questionText: 'هل العمل داخل المقر أم في موقع خارجي؟',
      options: ['🏢 داخل مقر الجمعية', '🏠 موقع خارجي'],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),

    Question(
      questionText: 'هل سيتم توفير شهادات تطوع؟',
      options: ['✅ نعم، سيتم إصدار شهادات', '❌ لا، العمل تطوعي فقط'],
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
                    color: const Color(0xFF68316D), // اللون البنفسجي
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.business_sharp,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "صيانة وتطوير مقرات الجمعيات",
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
                questionsf: maintenanceQuestions,
                questionsf2: maintenanceQuestions2,
                nameqesem2: "احتياجات الجمعيات",
                icon: Icons.business_sharp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

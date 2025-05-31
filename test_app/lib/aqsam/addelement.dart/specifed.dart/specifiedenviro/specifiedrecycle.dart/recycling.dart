import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Recycling extends StatelessWidget {
  Recycling({super.key});

  List<Question> questions1 = [
    Question(
      questionText: 'ما نوع المواد التي سيتم إعادة تدويرها؟',
      options: [
        '🛍️ بلاستيك',
        '📄 ورق وكرتون',
        '🥫 معادن',
        '🏠 نفايات إلكترونية',
      ],
    ),
    Question(
      questionText: 'هل سيتم جمع النفايات من أماكن محددة أم نقطة مركزية؟',
      options: [
        '🚛 سيتم جمعها من أماكن محددة',
        '🏢 سيتم تجميعها في نقطة مركزية',
      ],
    ),
    Question(
      questionText: 'هل يحتاج المتطوع إلى أدوات خاصة؟',
      options: ['🧤 نعم، قفازات وأكياس خاصة', '❌ لا، الجمعية توفر كل الأدوات'],
    ),
    Question(
      questionText: 'ما هي كمية النفايات المستهدفة؟',
      options: [
        '🗑️ أقل من 100 كجم',
        '🚛 من 100 إلى 500 كجم',
        '🏭 أكثر من 500 كجم',
      ],
    ),
    Question(
      questionText: 'هل يحتاج المتطوع إلى نقل النفايات بنفسه؟',
      options: [
        '🚚 نعم، مطلوب نقلها إلى نقطة التجميع',
        '❌ لا، الجمعية ستوفر وسائل النقل',
      ],
    ),
    Question(
      questionText: 'هل سيتم توفير تدريب للمتطوعين؟',
      options: ['✅ نعم، هناك جلسة تدريبية', '❌ لا، العمل مباشرة'],
    ),

    Question(
      questionText: 'هل سيتم التعاون مع مصانع تدوير؟',
      options: [
        '✅ نعم، بالتعاون مع شركات إعادة التدوير',
        '❌ لا، سيتم تخزينها لإعادة استخدامها محليًا',
      ],
    ),
  ];

  List<Question> question2 = [
    Question(
      questionText: 'هل سيتم تقديم شهادة تطوع؟',
      options: ['✅ نعم، شهادة معتمدة', '❌ لا، شهادة داخلية فقط'],
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
      questionText: 'ما الهدف من إعادة التدوير في هذا النشاط؟',
      options: [
        '🌍 تقليل النفايات وحماية البيئة',
        '💰 توفير موارد للجمعية',
        '🏡 توعية المجتمع',
      ],
    ),
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: ['✅ نعم، يوجد دعم للمتطوعين', '❌ لا، المتطوع مسؤول عن ذلك'],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),

    Question(
      questionText: 'ما مدة التطوع المطلوبة؟',
      options: ['⏳ بضع ساعات', '📅 عدة أيام', '🗓️ فترة طويلة'],
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
                    color: const Color(0xFF68316D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.recycling, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "إعادة التدوير وإدارة النفايات",
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
                questionsf: questions1,
                questionsf2: question2,
                nameqesem2: "بيئي",
                icon: Icons.spa,
                nameqesem4: "إعادة التدوير وإدارة النفايات",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

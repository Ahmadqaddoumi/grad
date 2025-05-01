import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Ramadanfood extends StatelessWidget {
  Ramadanfood({super.key});

  List<Question> iftarEventQuestions = [
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

  List<Question> iftarEventQuestions2 = [
    Question(
      questionText: 'هل هناك داعمون للفعالية؟',
      options: ['✅ نعم، جهات راعية', '❌ لا، نعتمد على التبرعات الفردية'],
    ),
    Question(
      questionText: 'هل يتم تقديم برامج ترفيهية أو دينية بعد الإفطار؟',
      options: ['✅ نعم، سيكون هناك برنامج', '❌ لا، فقط الإفطار'],
    ),
    Question(
      questionText: 'ما الميزانية المتاحة؟',
      options: ['💰 محددة مسبقًا', '❓ تعتمد على التبرعات'],
    ),
    Question(
      questionText: 'كيف يمكن للناس المساهمة؟',
      options: ['🍲 التبرع بالطعام', '💵 تبرعات نقدية', '⏳ التطوع في التنظيم'],
    ),
    Question(
      questionText: ' ما الهدف من تنظيم إفطار جماعي؟',
      options: [
        '🕌 تعزيز قيم التكافل في رمضان',
        '👨‍👩‍👧‍👦 جمع الناس حول مائدة واحدة',
        '🥘 توفير وجبة كريمة للفقراء',
        '🙏 تشجيع على العمل الخيري',
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
                    style: TextStyle(color: Color(0xffce9dd2), fontSize: 25),
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
                    color: const Color(0xFF68316D), // اللون البنفسجي
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.fastfood, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "تنظيم إفطار جماعي في رمضان",
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
                questionsf: iftarEventQuestions,
                questionsf2: iftarEventQuestions2,
                nameqesem2: "الفعاليات والمساعدات الإجتماعية",
                icon: Icons.volunteer_activism,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

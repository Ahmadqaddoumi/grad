import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Clothesfood extends StatelessWidget {
  Clothesfood({super.key});

  List<Question> donationItemsQuestions = [
    Question(
      questionText: 'ما نوع التبرعات المطلوبة؟',
      options: [
        '👕 ملابس وأحذية',
        '🍲 مواد غذائية',
        '🏠 مستلزمات منزلية',
        '🎒 أدوات مدرسية',
      ],
    ),
    Question(
      questionText: 'هل يجب أن تكون التبرعات جديدة أم مستعملة؟',
      options: ['🎁 جديدة فقط', '🔄 يمكن قبول المستعملة بحالة جيدة'],
    ),
    Question(
      questionText: 'ما العمر المستهدف للتبرعات؟',
      options: ['👶 أطفال', '👩‍🎓 طلاب مدارس', '👨‍👩‍👧‍👦 جميع الفئات'],
    ),
    Question(
      questionText: 'هل هناك شروط خاصة للتبرعات (نوع، كمية، جودة)؟',
      options: ['✅ نعم، شروط محددة', '❌ لا، أي تبرع مرحب به'],
    ),
  ];

  List<Question> donationItemsQuestions2 = [
    Question(
      questionText: 'كيف يمكن للمتبرعين إيصال التبرعات؟',
      options: [
        '🚚 سيتم استلام التبرعات من منازلهم',
        '📍 يجب تسليمها لمقر الجمعية',
      ],
    ),
    Question(
      questionText: 'هل يتم فرز التبرعات قبل توزيعها؟',
      options: ['✅ نعم، هناك فريق لفرزها', '❌ لا، سيتم توزيعها مباشرة'],
    ),
    Question(
      questionText: 'ما حجم التبرعات المطلوبة؟',
      options: [
        '📦 كمية صغيرة (أقل من 10 صناديق)',
        '🏠 كمية متوسطة (10 - 50 صندوق)',
        '🚚 كمية كبيرة (أكثر من 50 صندوق)',
      ],
    ),
    Question(
      questionText: 'هل الجمعية بحاجة لمتطوعين للمساعدة في التوزيع؟',
      options: ['✅ نعم، نحتاج متطوعين', '❌ لا، الجمعية تتولى التوزيع'],
    ),
    Question(
      questionText: ' ما الهدف من جمع التبرعات العينية؟',
      options: [
        '👕 توفير الملابس للمحتاجين',
        '🍞 توزيع الغذاء على الأسر',
        '🧼 تأمين مستلزمات النظافة',
        '🎒 دعم الطلبة بالأدوات المدرسية',
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
                        Icon(Icons.food_bank, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "التبرعات العينية",
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
                questionsf: donationItemsQuestions,
                questionsf2: donationItemsQuestions2,
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

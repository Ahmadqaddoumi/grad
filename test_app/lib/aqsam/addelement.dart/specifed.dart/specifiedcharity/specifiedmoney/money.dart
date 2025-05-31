import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Money extends StatelessWidget {
  Money({super.key});

  List<Question> donationCampaignQuestions = [
    Question(
      questionText: 'ما الحد الأدنى للمبلغ المقبول؟',
      options: [
        '💵 أي مبلغ متاح',
        '💰 10 - 50 دولار',
        '💳 50 - 200 دولار',
        '🏦 أكثر من 200 دولار',
      ],
    ),
    Question(
      questionText: 'ما طرق التبرع المتاحة؟',
      options: [
        '🏦 تحويل بنكي',
        '💳 بطاقة ائتمان',
        '💵 تبرع نقدي مباشر',
        '📱 محفظة إلكترونية',
      ],
    ),
    Question(
      questionText: 'هل سيتم تقديم إيصالات رسمية للمتبرعين؟',
      options: [
        '✅ نعم، سيتم إصدار إيصالات رسمية',
        '❌ لا، التبرع طوعي بدون إيصالات',
      ],
    ),
    Question(
      questionText: 'هل الحملة مستمرة أم لها فترة محددة؟',
      options: ['📅 حملة مستمرة', '⏳ حملة مؤقتة'],
    ),
  ];

  List<Question> donationCampaignQuestions2 = [
    Question(
      questionText: 'هل سيتم الإعلان عن أسماء المتبرعين؟',
      options: ['✅ نعم، سيتم ذكرهم كشكر', '❌ لا، التبرعات مجهولة'],
    ),
    Question(
      questionText: 'هل يمكن لمتبرع تحديد فئة معينة للاستفادة من تبرعه؟',
      options: [
        '✅ نعم، يمكنه اختيار الفئة المستهدفة',
        '❌ لا، سيتم توزيع التبرعات حسب الحاجة',
      ],
    ),
    Question(
      questionText: 'كم عدد المستفيدين من الحملة؟',
      options: [
        '👤 أقل من 50 شخصًا',
        '👥 من 50 إلى 200 شخص',
        '👨‍👩‍👧‍👦 أكثر من 200 شخص',
      ],
    ),
    Question(
      questionText: 'ما الهدف من جمع التبرعات؟',
      options: [
        '🏡 دعم الأسر المحتاجة',
        '🎓 تمويل تعليم الطلاب',
        '🏥 توفير الرعاية الصحية',
        '📦 تأمين الغذاء والملابس',
        '🏗️ بناء أو صيانة مرافق',
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
                    color: const Color(0xFF68316D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_money, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "الدعم المالي والتبرعات النقدية",
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
                questionsf: donationCampaignQuestions,
                questionsf2: donationCampaignQuestions2,
                nameqesem2: "احتياجات الجمعيات",
                icon: Icons.business_sharp,
                nameqesem4: 'الدعم المالي والتبرعات النقدية',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Hospitalhelp extends StatelessWidget {
  Hospitalhelp({super.key});

  List<Question> medicalHelpQuestions = [
    Question(
      questionText: 'ما سبب الحاجة للمساعدة؟',
      options: [
        '🏥 موعد طبي',
        '🦽 علاج فيزيائي',
        '💉 فحص دوري',
        '🚨 حالة طارئة',
      ],
    ),
    Question(
      questionText: 'هل يحتاج المريض إلى مرافقة أثناء الفحص؟',
      options: ['✅ نعم، يحتاج شخصًا معه', '❌ لا، فقط وسيلة نقل'],
    ),
    Question(
      questionText: 'هل هناك حاجة لكرسي متحرك أو أدوات طبية؟',
      options: ['✅ نعم، نحتاج كرسيًا متحركًا', '❌ لا، لا حاجة'],
    ),
    Question(
      questionText: 'ما العمر التقريبي للشخص المحتاج؟',
      options: ['👵 60-70 سنة', '👴 70-80 سنة', '🦽 أكثر من 80 سنة'],
    ),
    Question(
      questionText: 'هل يحتاج المتطوع إلى مهارات خاصة؟',
      options: ['✅ نعم، مهارات محددة', '❌ لا،أي شخص يمكنه المشاركة'],
    ),
  ];

  List<Question> medicalHelpQuestions2 = [
    Question(
      questionText: 'هل لدى الشخص تأمين صحي؟',
      options: ['✅ نعم، لديه تأمين', '❌ لا، يحتاج لدعم مالي'],
    ),
    Question(
      questionText: 'ما نوع وسيلة النقل المطلوبة؟',
      options: ['🚗 سيارة عادية', '🚑 سيارة إسعاف'],
    ),
    Question(
      questionText: 'هل هناك حاجة لمتطوعين دائمين لهذه الخدمة؟',
      options: ['✅ نعم، نريد متطوعين دائمين', '❌ لا، فقط عند الحاجة'],
    ),
    Question(
      questionText: 'هل سيتم توفير شهادات تطوع؟',
      options: ['✅ نعم، سيتم إصدار شهادات', '❌ لا، العمل تطوعي فقط'],
    ),

    Question(
      questionText: ' ما الهدف من مساعدة كبار السن للوصول للمستشفى؟',
      options: [
        '🚗 تسهيل حصولهم على الرعاية',
        '❤️ دعمهم نفسيًا واجتماعيًا',
        '🩺 متابعة حالتهم الصحية',
        '⏱️ تقليل تأخرهم عن المواعيد الطبية',
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
                        Icon(Icons.help, size: 20, color: Colors.white),
                        SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            "مساعدة كبار السن في الوصول للمستشفى",
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
                questionsf: medicalHelpQuestions,
                questionsf2: medicalHelpQuestions2,
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

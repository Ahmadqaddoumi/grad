import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/firstpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Tree extends StatelessWidget {
  Tree({super.key});

  List<Question> questions3 = [
    Question(
      questionText: 'ما نوع الأشجار التي سيتم زراعتها؟',
      options: [
        'أشجار مثمرة (تين، ليمون، برتقال...)',
        'أشجار ظل وزينة',
        'نباتات وشجيرات صغيرة',
      ],
    ),
    Question(
      questionText: 'هل الموقع يحتاج إلى تصاريح لزراعة الأشجار؟',
      options: ['نعم، الجمعية توفر التصاريح', 'المكان متاح للزراعة'],
    ),
    Question(
      questionText: 'هل سيتم توفير الأدوات للمتطوعين؟',
      options: ['نعم، سيتم توفيرها', 'يجب على المتطوع إحضار الأدوات بنفسه'],
    ),
    Question(
      questionText: 'كم عدد الأشجار التي سيتم زراعتها؟',
      options: ['أقل من 50 شجرة', 'من 50 إلى 200 شجرة', 'أكثر من 200 شجرة'],
    ),
    Question(
      questionText: 'كم عدد المتطوعين المطلوب؟',
      options: [
        'أقل من 10 متطوعين',
        'من 10 إلى 30 متطوعاً',
        'أكثر من 30 متطوعاً',
      ],
    ),
    Question(
      questionText: 'هل سيتم توفير وجبات أو مصاريف تنقل؟',
      options: [' نعم، يوجد دعم للمتطوعين', ' لا، المتطوع مسؤول عن ذلك'],
    ),
    Question(
      questionText: 'هل سيتم تصوير النشاط ونشره؟',
      options: ['📷 نعم، سيتم التوثيق الإعلامي', '❌ لا، النشاط خاص بدون تصوير'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Question> question4 = [
      Question(
        questionText: 'هل سيتم توفير تدريب للمتطوعين قبل الزراعة؟',
        options: ['نعم، يوجد جلسة تدريبية', 'سيتم الشرح خلال العمل'],
      ),
      Question(
        questionText: 'ما نوع التربة في الموقع؟',
        options: ['تربة رملية', 'تربة طينية', 'تربة خصبة زراعية'],
      ),
      Question(
        questionText: 'هل سيتم تخصيص أماكن جلوس للمتطوعين؟',
        options: ['نعم، سيتم توفير مظلات ومقاعد', 'المكان مفتوح بدون تجهيزات'],
      ),
      Question(
        questionText: 'هل سيتم تقديم شهادة تطوع؟',
        options: ['نعم، بشهادات معتمدة', 'لا، لن يتم تقديم شهادات'],
      ),
      Question(
        questionText: 'كم يستغرق النشاط من وقت؟',
        options: [
          'أقل من ساعتين',
          'من ساعتين إلى أربع ساعات',
          'أكثر من أربع ساعات',
        ],
      ),
      Question(
        questionText: ' ما الهدف من التشجير؟',
        options: [
          ' تحسين جودة الهواء',
          ' تعزيز المساحات الخضراء',
          ' تقليل آثار التغير المناخي',
          ' تحسين جمالية الأماكن العامة',
        ],
      ),
    ];
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
                        Icon(Icons.park, size: 20, color: Colors.white),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "التشجير وإعادة التشجير",
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
                questionsf: questions3,
                questionsf2: question4,
                nameqesem2: "بيئي",
                icon: Icons.spa,
                nameqesem4: 'التشجير وإعادة التشجير',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

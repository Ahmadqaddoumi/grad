import 'package:flutter/material.dart';
import 'package:test_app/aqsam/addelement.dart/addclass.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedactivity/activity.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedactivity/specifiedhoshelp/hospitalhelp.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedactivity/specifedramdan/ramadanfood.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedactivity/specifiedtrip/triporg.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedcharity/charity.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedcharity/specifiedclothesfood/clothesfood.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedcharity/specifiedmaintinance/maintinance.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedcharity/specifiedmoney/money.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedcharity/specifiedsearch/searchvolunteer.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedenviro/specifiedclean/cleanpublic.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedenviro/enviroment.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedenviro/specifiedrecycle.dart/recycling.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/specifiedenviro/specifiedtree.dart/tree.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/voulnteer/volunteer.dart';

// ignore: must_be_immutable
class Addagsam extends StatefulWidget {
  Qesem qsm1;
  Addagsam({super.key, required this.qsm1});

  @override
  State<Addagsam> createState() => _AddagsamState();
}

class _AddagsamState extends State<Addagsam> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.qsm1.title == "احتياجات الجمعيات" ||
            widget.qsm1.title == "الدعم المالي والتبرعات النقدية" ||
            widget.qsm1.title == "التبرعات العينية (ملابس وغذاء..)" ||
            widget.qsm1.title == "البحث عن متطوعين" ||
            widget.qsm1.title == "صيانة وتطوير مقرات الجمعيات") {
          if (widget.qsm1.title == "احتياجات الجمعيات") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Charity();
                },
              ),
            );
          } else if (widget.qsm1.title == "الدعم المالي والتبرعات النقدية") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Money();
                },
              ),
            );
          } else if (widget.qsm1.title == "التبرعات العينية (ملابس وغذاء..)") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Clothesfood();
                },
              ),
            );
          } else if (widget.qsm1.title == "البحث عن متطوعين") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Searchvolunteer();
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Maintinance();
                },
              ),
            );
          }
        } else if (widget.qsm1.title == "بيئي" ||
            widget.qsm1.title == "التشجير وإعادة التشجير" ||
            widget.qsm1.title == "إعادة التدوير وإدارة النفايات" ||
            widget.qsm1.title == "حملات تنظيف الأماكن العامة") {
          if (widget.qsm1.title == "بيئي") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Enviroment();
                },
              ),
            );
          } else if (widget.qsm1.title == "التشجير وإعادة التشجير") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Tree();
                },
              ),
            );
          } else if (widget.qsm1.title == "إعادة التدوير وإدارة النفايات") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Recycling();
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Cleanpublic();
                },
              ),
            );
          }
        } else if (widget.qsm1.title == "الفعاليات والمساعدات الاجتماعية" ||
            widget.qsm1.title == "تنظيم رحلة ترفيهية للأيتام" ||
            widget.qsm1.title == " تنظيم إفطار جماعي في رمضان" ||
            widget.qsm1.title == "مساعدة كبار السن في الوصول الى المستشفى") {
          if (widget.qsm1.title == "الفعاليات والمساعدات الاجتماعية") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Activity();
                },
              ),
            );
          } else if (widget.qsm1.title == "تنظيم رحلة ترفيهية للأيتام") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Triporg();
                },
              ),
            );
          } else if (widget.qsm1.title == " تنظيم إفطار جماعي في رمضان") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Ramadanfood();
                },
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Hospitalhelp();
                },
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const Volunteer();
              },
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 7),
        child: Container(
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
            color: const Color(0xFF68316D), // اللون البنفسجي
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(widget.qsm1.icon, size: 50, color: Colors.white),
                const SizedBox(width: 60),
                Flexible(
                  child: Text(
                    widget.qsm1.title,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

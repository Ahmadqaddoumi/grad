import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditAdPage extends StatefulWidget {
  final String adId;
  final Map<String, dynamic> adData;

  const EditAdPage({super.key, required this.adId, required this.adData});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController noteController;
  late TextEditingController supporterController;
  late DateTime? selectedDate;

  final Map<String, TextEditingController> answersControllers = {};

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.adData['initiativeName'],
    );
    locationController = TextEditingController(text: widget.adData['location']);
    noteController = TextEditingController(text: widget.adData['note']);
    supporterController = TextEditingController(
      text: widget.adData['supporter'],
    );
    selectedDate = (widget.adData['date'] as Timestamp?)?.toDate();

    // Load all answer fields dynamically
    final Map<String, dynamic> answers1 =
        widget.adData['answersFirstPage'] ?? {};
    final Map<String, dynamic> answers2 =
        widget.adData['answersSecondPage'] ?? {};
    final allAnswers = {...answers1, ...answers2};

    allAnswers.forEach((key, value) {
      answersControllers[key] = TextEditingController(text: value.toString());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> updateAd() async {
    final updatedAnswers = {
      for (var entry in answersControllers.entries)
        entry.key: entry.value.text.trim(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(widget.adId)
          .update({
            'initiativeName': nameController.text.trim(),
            'location': locationController.text.trim(),
            'note': noteController.text.trim(),
            'supporter': supporterController.text.trim(),
            'date':
                selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
            'answersFirstPage': updatedAnswers,
            'answersSecondPage': {},
          });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم تحديث الإعلان بنجاح")));
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء التحديث: \$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "تعديل الإعلان",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff68316d),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "اسم المبادرة"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "الموقع"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: supporterController,
              decoration: const InputDecoration(labelText: "الجهة الداعمة"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? "التاريخ: غير محدد"
                      : "📅 التاريخ: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text("اختيار التاريخ"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "ملاحظات"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "تفاصيل الأسئلة",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...answersControllers.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff68316d),
              ),
              onPressed: updateAd,
              child: const Text(
                "تحديث الإعلان",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

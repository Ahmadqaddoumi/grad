import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditAdPage extends StatefulWidget {
  final String adId;
  final Map<String, dynamic> adData;

  const EditAdPage({super.key, required this.adId, required this.adData});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  late TextEditingController nameController;
  late TextEditingController noteController;
  late TextEditingController supporterController;
  late TextEditingController typeController;
  late DateTime? selectedDate;
  String? selectedGovernorate;

  List<String> existingImages = [];
  List<File> newImages = [];

  final List<String> jordanGovernorates = [
    'عمان',
    'الزرقاء',
    'إربد',
    'العقبة',
    'البلقاء',
    'المفرق',
    'معان',
    'الطفيلة',
    'الكرك',
    'جرش',
    'عجلون',
    'مأدبا',
  ];

  final Map<String, TextEditingController> answersControllers = {};

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.adData['initiativeName'],
    );
    noteController = TextEditingController(text: widget.adData['note']);
    supporterController = TextEditingController(
      text: widget.adData['supporter'],
    );
    typeController = TextEditingController(
      text: widget.adData['initiativeType'] ?? '',
    );
    selectedGovernorate = widget.adData['governorate'];
    selectedDate = (widget.adData['date'] as Timestamp?)?.toDate();
    existingImages = List<String>.from(widget.adData['imageUrls'] ?? []);

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

  Future<void> pickNewImages() async {
    final picked = await ImagePicker().pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (picked != null) {
      setState(() {
        newImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  Future<List<String>> uploadNewImages() async {
    const cloudName = 'de40nspy3';
    const uploadPreset = 'flutter_unsigned';
    List<String> urls = [];

    for (var image in newImages) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'ads';
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final data = json.decode(resStr);
        urls.add(data['secure_url']);
      }
    }
    return urls;
  }

  Future<void> updateAd() async {
    if (nameController.text.trim().isEmpty ||
        selectedGovernorate == null ||
        noteController.text.trim().isEmpty ||
        supporterController.text.trim().isEmpty ||
        selectedDate == null ||
        (widget.adData['category'] == 'فرص تطوعية عامة' &&
            typeController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول الأساسية")),
      );
      return;
    }

    for (var entry in answersControllers.entries) {
      if (entry.value.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("يرجى تعبئة السؤال: ${entry.key}")),
        );
        return;
      }
    }

    final updatedAnswers = {
      for (var entry in answersControllers.entries)
        entry.key: entry.value.text.trim(),
    };

    final newUploadedUrls = await uploadNewImages();
    final allImages = [...existingImages, ...newUploadedUrls];

    try {
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(widget.adId)
          .update({
            'initiativeName': nameController.text.trim(),
            'governorate': selectedGovernorate,
            'note': noteController.text.trim(),
            'supporter': supporterController.text.trim(),
            'date': Timestamp.fromDate(selectedDate!),
            'answersFirstPage': updatedAnswers,
            'answersSecondPage': {},
            'imageUrls': allImages,
            if (widget.adData['category'] == 'فرص تطوعية عامة')
              'initiativeType': typeController.text.trim(),
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
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء التحديث: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                controller: supporterController,
                decoration: const InputDecoration(labelText: "الجهة الداعمة"),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "اختر المحافظة"),
                value: selectedGovernorate,
                items:
                    jordanGovernorates
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedGovernorate = value),
              ),
              const SizedBox(height: 12),
              if (widget.adData['category'] == 'فرص تطوعية عامة')
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: "نوع المبادرة"),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    selectedDate == null
                        ? "التاريخ: غير محدد"
                        : "📅 ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF68316D),
                    ),
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
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                "📷 الصور الحالية",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children:
                    existingImages.map((url) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () =>
                                    setState(() => existingImages.remove(url)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF68316D),
                ),
                onPressed: pickNewImages,
                child: const Text("📷 إضافة صور جديدة (اختياري)"),
              ),
              Wrap(
                spacing: 8,
                children:
                    newImages
                        .map(
                          (file) => Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
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
      ),
    );
  }
}

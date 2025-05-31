import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/voulnteer/customvolunteer.dart';
import 'package:test_app/home.dart';

class Volunteer extends StatefulWidget {
  const Volunteer({super.key});

  @override
  State<Volunteer> createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  DateTime? selectedDate;
  String formattedDate = 'اختر تاريخ النشاط';

  final _initiativeController = TextEditingController();
  final _supporterController = TextEditingController();
  final _typeController = TextEditingController();
  final _noteController = TextEditingController();

  String? selectedGovernorate;
  String? supporterName;

  List<File> selectedImages = [];

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

  List<Question> publicvolunteer = [
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
      options: ['🏠 أيتام', '👴 كبار السن', '🏙 أسر محتاجة', '🏫 طلاب جامعات'],
    ),
    Question(
      questionText: 'ما موقع الإفطار؟',
      options: ['🏨 مسجد', '🏠 دار أيتام', '🌿 مكان عام'],
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

  @override
  void initState() {
    super.initState();
    fetchSupporterName();
  }

  Future<void> fetchSupporterName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
      if (doc.exists && doc.data()!.containsKey('username')) {
        setState(() {
          supporterName = doc['username'];
          _supporterController.text = supporterName!;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> pickImages() async {
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Future<List<String>> uploadImagesToCloudinary() async {
    const cloudName = 'de40nspy3';
    const uploadPreset = 'flutter_unsigned';
    List<String> uploadedUrls = [];

    for (var image in selectedImages) {
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
        uploadedUrls.add(data['secure_url']);
      }
    }
    return uploadedUrls;
  }

  Future<void> _submitAd() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final answers = <String, String>{};

    for (var q in publicvolunteer) {
      if (q.selectedOption != null) {
        answers[q.questionText] = q.selectedOption!;
      }
    }

    if (uid == null ||
        _initiativeController.text.trim().isEmpty ||
        _supporterController.text.trim().isEmpty ||
        _typeController.text.trim().isEmpty ||
        selectedGovernorate == null ||
        selectedDate == null ||
        answers.length != publicvolunteer.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع الحقول بشكل كامل")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final note =
        _noteController.text.trim().isEmpty
            ? 'لا يوجد ملاحظات'
            : _noteController.text.trim();
    final imageUrls = await uploadImagesToCloudinary();

    await FirebaseFirestore.instance.collection('ads').add({
      'uid': uid,
      'supporter': _supporterController.text.trim(),
      'initiativeName': _initiativeController.text.trim(),
      'initiativeType': _typeController.text.trim(),
      'governorate': selectedGovernorate,
      'note': note,
      'date': selectedDate,
      'category': 'فرص تطوعية عامة',
      'subCategory': Icons.handshake.codePoint,
      'answersFirstPage': {},
      'answersSecondPage': answers,
      'timestamp': Timestamp.now(),
      'imageUrls': imageUrls,
    });

    if (context.mounted) Navigator.of(context).pop();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم نشر الإعلان بنجاح ✅")));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF68316D),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child:
              supporterName == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.volunteer_activism,
                              color: Color(0xffce9dd2),
                              size: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "فرص تطوعية عامة",
                                style: TextStyle(
                                  color: Color(0xffce9dd2),
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 20),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                'اسم الجمعية: $supporterName',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF68316D),
                                ),
                              ),
                            ),
                            Customvolunteer(
                              nametxt: "اسم المبادرة",
                              controller: _initiativeController,
                            ),
                            Customvolunteer(
                              nametxt: "نوع المبادرة",
                              controller: _typeController,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 60,
                                right: 10,
                                top: 5,
                                bottom: 20,
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'اختر المحافظة',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff7433d3),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                value: selectedGovernorate,
                                items:
                                    jordanGovernorates
                                        .map(
                                          (g) => DropdownMenuItem(
                                            value: g,
                                            child: Text(g),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (val) => setState(
                                      () => selectedGovernorate = val,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '🗓️ $formattedDate',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _selectDate(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff68316D),
                                    ),
                                    child: const Text(
                                      'اختر التاريخ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: pickImages,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xff68316D),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "📷 اختر صور الإعلان (اختياري)",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(selectedImages.length, (
                                  index,
                                ) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          selectedImages[index],
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => removeImage(index),
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.black54,
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            for (var question in publicvolunteer)
                              Customshape(question1: question),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextField(
                                controller: _noteController,
                                minLines: 1,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText: "ملاحظات (اختياري)",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff7433d3),
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: _submitAd,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF68316D),
                                ),
                                child: const Text(
                                  "نشر الإعلان",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}

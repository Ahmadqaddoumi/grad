// ✅ Firstpage.dart (نسخة منسقة باحتراف لعرض الصور)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/customshape.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/secondpage.dart';
import 'package:test_app/aqsam/addelement.dart/specifed.dart/questionsforall.dart/classquestion.dart';

// ignore: must_be_immutable
class Firstpage extends StatefulWidget {
  List<Question> questionsf;
  List<Question> questionsf2;
  final String nameqesem2;
  final String nameqesem4;
  final IconData icon;

  Firstpage({
    super.key,
    required this.questionsf,
    required this.questionsf2,
    required this.nameqesem2,
    required this.nameqesem4,
    required this.icon,
  });

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final TextEditingController _initiativeController = TextEditingController();
  String? supporterName;
  List<File> _selectedImages = [];

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
      setState(() {
        supporterName = doc.data()?['username'] ?? 'جمعية غير معروفة';
      });
    }
  }

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<List<String>> uploadImagesToCloudinary() async {
    const cloudName = 'de40nspy3';
    const uploadPreset = 'flutter_unsigned';

    List<String> uploadedUrls = [];
    for (var image in _selectedImages) {
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
      } else {
        debugPrint('فشل رفع صورة: ${response.statusCode}');
      }
    }
    return uploadedUrls;
  }

  @override
  Widget build(BuildContext context) {
    if (supporterName == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widget.questionsf.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اسم الجمعية: $supporterName',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF68316D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _initiativeController,
                    decoration: const InputDecoration(
                      hintText: "اسم المبادرة",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff7433d3),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: pickImages,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xff68316D),
                      ),
                      child: const Center(
                        child: Text(
                          "📷 اختر صور الإعلان (اختياري)",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedImages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          } else if (index <= widget.questionsf.length) {
            return Customshape(question1: widget.questionsf[index - 1]);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final answersFirstPage = <String, String>{};
                  for (var q in widget.questionsf) {
                    if (q.selectedOption != null) {
                      answersFirstPage[q.questionText] = q.selectedOption!;
                    }
                  }

                  if (_initiativeController.text.trim().isEmpty ||
                      answersFirstPage.length != widget.questionsf.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى تعبئة جميع الحقول قبل المتابعة'),
                      ),
                    );
                    return;
                  }

                  List<String> uploadedImageUrls = [];
                  if (_selectedImages.isNotEmpty) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) =>
                              const Center(child: CircularProgressIndicator()),
                    );

                    uploadedImageUrls = await uploadImagesToCloudinary();

                    if (context.mounted) {
                      Navigator.of(context).pop(); // لإغلاق دائرة التحميل
                    }
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => Secondpage(
                            questionssecond: widget.questionsf2,
                            nameqesem3: widget.nameqesem2,
                            subCategoryName: widget.nameqesem4,
                            icon1: widget.icon,
                            supporter: supporterName!,
                            initiativeName: _initiativeController.text.trim(),
                            answersFirstPage: answersFirstPage,
                            imageUrls: uploadedImageUrls,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68316D),
                ),
                child: const Text(
                  "التالي",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

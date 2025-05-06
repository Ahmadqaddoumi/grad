// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:test_app/login/forgetpass/forgetpass2.dart';

// class PhoneResetPage extends StatefulWidget {
//   const PhoneResetPage({super.key});

//   @override
//   State<PhoneResetPage> createState() => _PhoneResetPageState();
// }

// class _PhoneResetPageState extends State<PhoneResetPage> {
//   final TextEditingController phoneController = TextEditingController();
//   bool isLoading = false;

//   Future<void> sendOTP() async {
//     final phoneNumber = phoneController.text.trim();

//     if (phoneNumber.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('يرجى إدخال رقم الهاتف')));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) {},
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('فشل التحقق: ${e.message}')));
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (context) =>
//                       OTPVerificationPage(verificationId: verificationId),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           backgroundColor: const Color(0xff68316d),
//           title: const Text('استعادة عن طريق الهاتف'),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 50),
//                 const Icon(
//                   Icons.phone_android,
//                   size: 100,
//                   color: Color(0xff68316d),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'أدخل رقم هاتفك لاستعادة كلمة المرور',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xff68316d),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 TextField(
//                   controller: phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(
//                       Icons.phone,
//                       color: Color(0xff68316d),
//                     ),
//                     hintText: 'مثال: +9627XXXXXXXX',
//                     hintStyle: const TextStyle(color: Colors.black54),
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(18),
//                       borderSide: const BorderSide(
//                         color: Color(0xff68316d),
//                         width: 2.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(18),
//                       borderSide: const BorderSide(
//                         color: Color(0xff68316d),
//                         width: 2.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff68316d),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   onPressed: isLoading ? null : sendOTP,
//                   child:
//                       isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                             'إرسال كود التحقق',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

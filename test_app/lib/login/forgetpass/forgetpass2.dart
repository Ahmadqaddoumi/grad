// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test_app/login/forgetpass/newpass.dart';

// class OTPVerificationPage extends StatefulWidget {
//   final String verificationId;
//   const OTPVerificationPage({required this.verificationId, Key? key})
//     : super(key: key);

//   @override
//   State<OTPVerificationPage> createState() => _OTPVerificationPageState();
// }

// class _OTPVerificationPageState extends State<OTPVerificationPage> {
//   final List<TextEditingController> controllers = List.generate(
//     6,
//     (_) => TextEditingController(),
//   );
//   final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
//   bool isLoading = false;

//   bool isAllFilled() {
//     return controllers.every((c) => c.text.isNotEmpty);
//   }

//   void verifyOTP() async {
//     String smsCode = controllers.map((c) => c.text).join();

//     if (smsCode.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى إدخال رمز التحقق كاملاً')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: smsCode,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const NewPasswordPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('رمز التحقق غير صحيح')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildOTPField(int index) {
//     return SizedBox(
//       width: 50,
//       child: TextField(
//         controller: controllers[index],
//         focusNode: focusNodes[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: const TextStyle(color: Colors.white, fontSize: 24),
//         maxLength: 1,
//         decoration: InputDecoration(
//           counterText: "",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.white, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.white, width: 2),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) {
//             FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//           } else if (value.isEmpty && index > 0) {
//             FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//           }
//           setState(() {});
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     for (var node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           backgroundColor: const Color(0xff68316d),
//           title: const Text('تحقق من الرمز'),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 const Icon(Icons.sms, size: 100, color: Color(0xff68316d)),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'أدخل رمز التحقق المرسل إلى رقم هاتفك',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xff68316d),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(6, (index) => buildOTPField(index)),
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff68316d),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 15,
//                       horizontal: 80,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   onPressed: isLoading ? null : verifyOTP,
//                   child:
//                       isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                             'تأكيد الرمز',
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

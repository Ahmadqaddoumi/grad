// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:test_app/login/login.dart'; // استورد صفحة تسجيل الدخول عند النجاح

// class NewPasswordPage extends StatefulWidget {
//   const NewPasswordPage({Key? key}) : super(key: key);

//   @override
//   State<NewPasswordPage> createState() => _NewPasswordPageState();
// }

// class _NewPasswordPageState extends State<NewPasswordPage> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _updatePassword() async {
//     final password = _passwordController.text.trim();
//     final confirmPassword = _confirmPasswordController.text.trim();

//     if (password.isEmpty || confirmPassword.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('يرجى تعبئة كل الحقول')));
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
//       );
//       return;
//     }

//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       User? user = FirebaseAuth.instance.currentUser;

//       if (user != null) {
//         await user.updatePassword(password);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
//         );

//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const LogInPage()),
//           (route) => false,
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'لم يتم العثور على مستخدم. حاول تسجيل الدخول مجدداً.',
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ: ${e.toString()}')));
//     } finally {
//       setState(() {
//         _isLoading = false;
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
//           title: const Text('كلمة مرور جديدة'),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 const Icon(
//                   Icons.lock_reset,
//                   size: 100,
//                   color: Color(0xff68316d),
//                 ),
//                 const SizedBox(height: 30),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     labelText: 'كلمة المرور الجديدة',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: _confirmPasswordController,
//                   obscureText: !_isConfirmPasswordVisible,
//                   decoration: InputDecoration(
//                     labelText: 'تأكيد كلمة المرور',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff68316d),
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     onPressed: _isLoading ? null : _updatePassword,
//                     child:
//                         _isLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                             : const Text(
//                               'تغيير كلمة المرور',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

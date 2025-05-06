// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class OTP extends StatefulWidget {
//   final FocusNode focusNode;
//   final FocusNode? previousFocusNode;

//   const OTP({super.key, required this.focusNode, this.previousFocusNode});

//   @override
//   State<OTP> createState() => _OTPState();
// }

// class _OTPState extends State<OTP> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 68,
//       width: 64,
//       child: TextFormField(
//         cursorColor: Colors.white,
//         controller: _controller,
//         focusNode: widget.focusNode,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 27,
//           fontWeight: FontWeight.w700,
//         ),
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(1),
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: InputDecoration(
//           hintText: "0",
//           hintStyle: TextStyle(
//             color: Colors.white.withOpacity(0.4),
//             fontSize: 27,
//             fontWeight: FontWeight.w700,
//           ),
//           enabledBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(18.0)),
//             borderSide: BorderSide(width: 2.5, color: Colors.white),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(18.0)),
//             borderSide: BorderSide(width: 2.5, color: Colors.white),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.length == 1) {
//             FocusScope.of(context).nextFocus();
//           } else if (value.isEmpty && widget.previousFocusNode != null) {
//             widget.previousFocusNode!.requestFocus();
//           }
//         },
//       ),
//     );
//   }
// }

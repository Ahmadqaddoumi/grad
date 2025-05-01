import 'package:flutter/material.dart';
import 'package:test_app/login/forgetpass/newpass.dart';
import 'package:test_app/login/forgetpass/otp.dart';
import 'package:test_app/login/login.dart';

class EmailCheck extends StatefulWidget {
  const EmailCheck({super.key});

  @override
  State<EmailCheck> createState() => _EmailCheckState();
}

class _EmailCheckState extends State<EmailCheck> {
  late FocusNode focus1;
  late FocusNode focus2;
  late FocusNode focus3;
  late FocusNode focus4;

  @override
  void initState() {
    super.initState();
    focus1 = FocusNode();
    focus2 = FocusNode();
    focus3 = FocusNode();
    focus4 = FocusNode();
  }

  @override
  void dispose() {
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 130, color: Color(0xff68316d)),
                  Text(
                    'تحقق من بريدك الإلكتروني',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff68316d),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    ''' لقد ارسلنا رمزاً الى بريدك الإلكتروني, استخدم هذا الرمز
                              لتأكيد حسابك''',
                    style: TextStyle(
                      color: Color(0xff68316d),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff68316d),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OTP(focusNode: focus1),
                        OTP(focusNode: focus2, previousFocusNode: focus1),
                        OTP(focusNode: focus3, previousFocusNode: focus2),
                        OTP(focusNode: focus4, previousFocusNode: focus3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "لم تحصل على الرمز؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (ctx) => Newpassword(
                                      isObsecure: true,
                                      onItemChange: () {
                                        setState(() {});
                                      },
                                    ),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xffce9dd2),
                            ),
                            padding: WidgetStatePropertyAll(EdgeInsets.all(15)),
                          ),
                          child: const Text(
                            "إعادة تعيين كلمة المرور",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 55),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const LogInPage()),
                      );
                    },
                    child: const Text(
                      "العودة إالي تسجيل الدخول",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

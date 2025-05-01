import 'package:flutter/material.dart';
import 'package:test_app/login/forgetpass/forgetpass2.dart';
import 'package:test_app/login/login.dart';

// ignore: must_be_immutable
class Newpassword extends StatefulWidget {
  final VoidCallback onItemChange;
  bool isObsecure;
  Newpassword({
    super.key,
    required this.isObsecure,
    required this.onItemChange,
  });

  @override
  State<Newpassword> createState() => _NewpasswordState();
}

class _NewpasswordState extends State<Newpassword> {
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
                  Icon(Icons.lock, size: 130, color: Color(0xff68316d)),
                  Text(
                    'إنشاء كلمة مرور جديدة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff68316d),
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "يبدأ أمان كلمة المرور بإنشاء كلمة مرور قوية",
                    style: TextStyle(
                      color: Color(0xff68316d),
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
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
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 17.0),
                      child: Text(
                        "كلمة السر الجديدة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  const TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Colors
                              .transparent, // Optional: white background for the input field
                      hintText: " أدخل كلمة السر الجديدة ",
                      hintStyle: TextStyle(color: Colors.white),
                      hintTextDirection: TextDirection.rtl,
                      suffixIcon: Icon(Icons.lock),
                      // prefixIcon: IconButton(onPressed: (){
                      //       widget.isObsecure = !widget.isObsecure;
                      //       widget.onItemChange;
                      //       setState(() {

                      //       });
                      //     },
                      // icon: widget.isObsecure ? const Icon(Icons.visibility):const Icon(Icons.visibility_off)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(width: 2.5, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(width: 2.5, color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 10,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 17.0, top: 10),
                      child: Text(
                        "تأكيد كلمة السر الجديدة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  const TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Colors
                              .transparent, // Optional: white background for the input field
                      hintText: " أدخل كلمة السر الجديدة ",
                      hintStyle: TextStyle(color: Colors.white),
                      hintTextDirection: TextDirection.rtl,
                      suffixIcon: Icon(Icons.lock, color: Colors.white),
                      prefixIcon: Icon(Icons.visibility, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(width: 2.5, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(width: 2.5, color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const EmailCheck(),
                              ),
                            );
                          }, // You can call the reset directly here
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
                  const SizedBox(height: 15),
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
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _resetPassword,
          //   child: const Text("Reset Password"),
          // ),
        ],
      ),
    );
  }
}

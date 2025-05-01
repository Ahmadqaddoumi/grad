import 'package:flutter/material.dart';
import 'package:test_app/login/login.dart';

// ignore: must_be_immutable
class CreateNewAccount extends StatefulWidget {
  final VoidCallback onItemChange;
  bool isObsecure;
  CreateNewAccount({
    super.key,
    required this.onItemChange,
    required this.isObsecure,
  });

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  bool booleanValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.7,
                  decoration: const BoxDecoration(
                    // color:Colors.green[900],
                    color: Color(0xff68316d),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 18.0, left: 18),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Expanded(child: SizedBox(height: 2)),
                    Padding(
                      padding: EdgeInsets.only(top: 18.0, right: 29),
                      child: Icon(Icons.close, color: Colors.white, size: 30),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 40.0, top: 50),
                  child: SizedBox(
                    width: 130,
                    child: Text(
                      "دعنا ننشئ حسابك",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 40,
                right: 40,
                bottom: 20,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: "اسم المستخدم",
                        suffixIcon: Icon(Icons.person),
                        hintTextDirection: TextDirection.rtl,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: "البريد الإلكتروني",
                        suffixIcon: Icon(Icons.email),
                        hintTextDirection: TextDirection.rtl,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      obscureText: widget.isObsecure,
                      decoration: InputDecoration(
                        hintText: "كلمة السر",
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: const Icon(Icons.lock),
                        prefixIcon: IconButton(
                          onPressed: () {
                            widget.isObsecure = !widget.isObsecure;
                            widget.onItemChange;
                            setState(() {});
                          },
                          icon:
                              widget.isObsecure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      obscureText: widget.isObsecure,
                      decoration: InputDecoration(
                        hintText: "تأكيد كلمة السر",
                        suffixIcon: const Icon(Icons.lock),
                        prefixIcon: IconButton(
                          onPressed: () {
                            widget.isObsecure = !widget.isObsecure;
                            widget.onItemChange;
                            setState(() {});
                          },
                          icon:
                              widget.isObsecure
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                        ),
                        hintTextDirection: TextDirection.rtl,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(0xff68316d),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: Row(
                children: [
                  Checkbox(
                    value: booleanValue,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        booleanValue = value!;
                      });
                    },
                  ),
                  const Text("I agree to the "),
                  const Text(
                    "Terms & Privacy",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xff68316d),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15),
                        child: Text(
                          "أنشئ حساب",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const LogInPage()),
                    );
                  },
                  child: const Text(
                    "سجل الدخول",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ),
                const Text(" هل لديك حساب؟", style: TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

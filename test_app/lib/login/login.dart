import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:test_app/home.dart';
import 'package:test_app/login/forgetpass/forgetpass.dart';
import 'package:test_app/login/regester/regester.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool booleanValue = false;
  // ignore: unused_field
  late Color _textColor;
  bool isObsecure = true;
  bool isFocused = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textColor = Colors.black; // Initial text color
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xff68316d),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Stack(
                children: [
                  /// Login Form Container
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Color(0xffce9dd2),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Profile Image
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "image/assets/g.jpg",
                                  ),
                                  radius: 100,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              const Text(
                                "إحسان",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "ahmad",
                                ),
                              ),

                              /// Username Field
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  top: 8,
                                ),
                                child: TextField(
                                  // onTap: (){
                                  //   setState(() {
                                  //     isFocused = true;
                                  //   });
                                  // },
                                  // onEditingComplete: () {
                                  //   setState(() {
                                  //     isFocused = false;
                                  //     });
                                  // },
                                  decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Colors.white,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.person),
                                    ),
                                    hintText: "اسم المستخدم",

                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Color(0xff68316d),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
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

                              /// Password Field
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextField(
                                  controller: textController,
                                  obscureText: isObsecure,
                                  decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Colors.white,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.lock),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        isObsecure = !isObsecure;
                                        setState(() {});
                                      },
                                      icon:
                                          isObsecure
                                              ? const Icon(Icons.visibility)
                                              : const Icon(
                                                Icons.visibility_off_outlined,
                                              ),
                                    ),
                                    hintText: "كلمة السر",
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Color(0xff68316d),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Color(0xff68316d),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// Checkbox & Forgot Password Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: MouseRegion(
                                      onEnter:
                                          (_) => setState(
                                            () =>
                                                _textColor =
                                                    const Color.fromRGBO(
                                                      8,
                                                      4,
                                                      241,
                                                      1,
                                                    ),
                                          ),
                                      onExit:
                                          (_) => setState(
                                            () => _textColor = Colors.black,
                                          ),
                                      cursor: MouseCursor.defer,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigate to forgot password screen
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (ctx) =>
                                                        const ForgotPasswordScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "نسيت كلمة السر ؟",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const Expanded(child: SizedBox()),
                                  const Text(
                                    "تذكرني",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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

                                  // const Spacer(),
                                  // Expanded(child:SizedBox()),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const Home(),
                                          ),
                                        );
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Color(0xff68316d),
                                        ),
                                      ),
                                      child: const Text(
                                        "تسجيل الدخول",
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
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "مستخدم جديد ؟ ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const Register(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      " سجل الأن",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  // TextButton(onPressed: (){},child: Text("Register Now",textAlign:TextAlign.center,style:TextStyle(fontSize: 18,)),
                                  // style: ButtonStyle(),),
                                ],
                              ),
                              // SizedBox(height: 12,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Text("or"),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //  SizedBox(height: 12,),
                              Row(
                                children: [
                                  //  Expanded(
                                  //    child: TextButton(onPressed: (){},
                                  //    style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue[900]),),
                                  //    child:Text("FaceBook",style: TextStyle(color: Colors.white,fontSize: 17),),
                                  //    ),
                                  //  ),
                                  // IconButton(onPressed:(){},icon:Icon(FontAwesomeIcons.facebook,color: Colors.blue[700],)),
                                  Expanded(
                                    child: SignInButton(
                                      text: "Sign in with Google",
                                      Buttons.google,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: SignInButton(
                                      Buttons.facebookNew,
                                      text: "Sign in with Facebook",
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: SignInButton(
                              //        mini:true,
                              //        Buttons.appleDark,
                              //        onPressed: () {},
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              //  Row(
                              //    children: [
                              //      Expanded(
                              //        child: TextButton(onPressed: (){},
                              //        style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white),),
                              //        child:Text("Google",style: TextStyle(color: Colors.black,fontSize: 17)),
                              //        ),
                              //      ),
                              //    ],
                              //  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

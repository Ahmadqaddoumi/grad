import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/home.dart';
import 'package:test_app/login/regester/admin/adminhomepage.dart';
import 'package:test_app/login/forgetpass/forgetpass.dart';
import 'package:test_app/login/regester/regester.dart';
import 'package:test_app/login/regester/regesterwithgoogle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool booleanValue = false;
  bool isObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    if (booleanValue) {
      await prefs.setString('saved_email', emailController.text.trim());
      await prefs.setString('saved_password', passwordController.text.trim());
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
    }
  }

  Future<void> _loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        booleanValue = true;
      });
    }
  }

  Future<void> signInUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تعبئة البريد الإلكتروني وكلمة السر'),
        ),
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      final uid = user!.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = userDoc.data();
      final accountType = data?['accountType'];

      // ✅ تحقق البريد فقط إذا لم يكن Admin
      if (accountType != 'Admin' && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("تأكيد البريد الإلكتروني"),
                content: const Text(
                  "لم يتم تفعيل بريدك الإلكتروني بعد.\nيرجى فحص بريدك وتأكيد الحساب قبل تسجيل الدخول.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("موافق"),
                  ),
                ],
              ),
        );
        return;
      }

      // ✅ تحقق حالة الحساب
      if (data != null && data['isActive'] == false) {
        await FirebaseAuth.instance.signOut();
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("⚠ الحساب موقوف"),
                content: const Text(
                  "تم تعطيل حسابك من قبل الإدارة.\nيرجى مراجعة الدعم عبر: teamworkk2003@gmail.com",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("موافق"),
                  ),
                ],
              ),
        );
        return;
      }

      await _saveLoginData();

      if (accountType == 'Admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminHomePage()),
        );
      } else {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الدخول بنجاح! 🎉')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم اختيار حساب جوجل.')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChooseAccountTypeAfterGoogle(uid: uid),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الدخول بجوجل: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xff68316d),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: [
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  top: 8,
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    filled: false,
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "اسم المستخدم",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Color(0xff68316d),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(18.0),
                                      ),
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
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: isObsecure,
                                  decoration: InputDecoration(
                                    filled: false,
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isObsecure = !isObsecure;
                                        });
                                      },
                                      icon: Icon(
                                        isObsecure
                                            ? Icons.visibility
                                            : Icons.visibility_off_outlined,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
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
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: signInUser,
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
                                ],
                              ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: SignInButton(
                                      Buttons.google,
                                      text: "Sign in with Google",
                                      onPressed:
                                          () => signInWithGoogle(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
////login.dart
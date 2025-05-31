import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool booleanValue = false;

  bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    ).hasMatch(email);
  }

  bool isPasswordStrong(String password) {
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$&*~]').hasMatch(password);
    final hasMinLength = password.length >= 8;

    return hasUpper && hasLower && hasDigit && hasSpecial && hasMinLength;
  }

  Future<void> registerVolunteer() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // ✅ Field is empty check
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى تعبئة جميع الحقول')));
      return;
    }

    // ✅ Email validation
    if (!isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البريد الإلكتروني غير صالح')),
      );
      return;
    }

    // ✅ Password strength
    if (!isPasswordStrong(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، '
            'وحرف كبير وصغير، ورقم، ورمز خاص (!@#\$&*)',
          ),
        ),
      );
      return;
    }

    // ✅ Password match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    // ✅ Checkbox: Must agree to terms
    if (!booleanValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على الشروط والأحكام')),
      );
      return;
    }

    // ✅ Proceed with Firebase
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user!;
      await user.sendEmailVerification();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': username,
        'email': email,
        'accountType': 'Volunteer',
        'isActive': true,
      });

      await FirebaseAuth.instance.signOut();

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("تم إنشاء الحساب"),
              content: const Text(
                "تم إرسال رابط تحقق إلى بريدك الإلكتروني.\nيرجى التحقق قبل تسجيل الدخول.",
              ),
              actions: [
                TextButton(
                  child: const Text("موافق"),
                  onPressed:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LogInPage()),
                      ),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff68316d),
          elevation: 0,
          title: const Text(
            'تسجيل كمتطوع',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 1.8,
                  decoration: const BoxDecoration(
                    color: Color(0xff68316d),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "دعنا ننشئ حسابك",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      buildTextField(
                        usernameController,
                        "اسم المستخدم",
                        Icons.person,
                      ),
                      buildTextField(
                        emailController,
                        "البريد الإلكتروني",
                        Icons.email,
                      ),
                      buildPasswordField(passwordController, "كلمة المرور"),
                      buildPasswordField(
                        confirmPasswordController,
                        "تأكيد كلمة المرور",
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: booleanValue,
                            onChanged: (value) {
                              setState(() {
                                booleanValue = value!;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "أوافق على الشروط والأحكام",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0xff68316d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: registerVolunteer,
                        child: const Text(
                          "أنشئ حساب",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => const LogInPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "سجل الدخول",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const Text(
                            " هل لديك حساب؟",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff68316d), width: 2.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff68316d), width: 2.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: widget.isObsecure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              widget.isObsecure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                widget.isObsecure = !widget.isObsecure;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff68316d), width: 2.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xff68316d), width: 2.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
//////////create_acc.dart
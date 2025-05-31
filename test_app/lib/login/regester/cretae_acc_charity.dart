import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/login/login.dart';

// ignore: must_be_immutable
class CreateAccCharity extends StatefulWidget {
  final VoidCallback onItemChange;
  bool isObsecure;

  CreateAccCharity({
    super.key,
    required this.onItemChange,
    required this.isObsecure,
  });

  @override
  State<CreateAccCharity> createState() => _CreateAccCharityState();
}

class _CreateAccCharityState extends State<CreateAccCharity> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final serialController = TextEditingController();

  bool booleanValue = false;

  bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}",
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

  Future<bool> checkSerialNumberExists(String serialNumber) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('serial_numbers')
            .doc(serialNumber.trim())
            .get();
    return doc.exists;
  }

  Future<void> registerCharity() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final serialNumber = serialController.text.trim();

    // ✅ Check for empty fields
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        serialNumber.isEmpty) {
      return _showError("يرجى تعبئة جميع الحقول");
    }

    // ✅ Email format validation
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
    ).hasMatch(email)) {
      return _showError("البريد الإلكتروني غير صالح");
    }

    // ✅ Password strength check
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

    // ✅ Password match check
    if (password != confirmPassword) {
      return _showError("كلمتا المرور غير متطابقتين");
    }

    // ✅ Serial number check
    final serialExists = await checkSerialNumberExists(serialNumber);
    if (!serialExists) {
      return _showError("الرقم التسلسلي غير صحيح");
    }

    if (!booleanValue) {
      return _showError("يجب الموافقة على الشروط والأحكام");
    }

    // ✅ Proceed with Firebase registration
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user!;
      await user.sendEmailVerification();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': username,
        'email': email,
        'accountType': 'Charity',
        'serialNumber': serialNumber,
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
      _showError('حدث خطأ: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
            'تسجيل كمنظمة',
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
                      buildTextField(
                        serialController,
                        "الرقم التسلسلي للمنظمة",
                        Icons.search,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: booleanValue,
                            onChanged: (value) {
                              setState(() => booleanValue = value!);
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
                        onPressed: registerCharity,
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
                          const Text(
                            " هل لديك حساب؟",
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap:
                                () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const LogInPage(),
                                  ),
                                ),
                            child: const Text(
                              "سجل الدخول",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
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
              setState(() => widget.isObsecure = !widget.isObsecure);
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
/////////////create_acc_charity.dart
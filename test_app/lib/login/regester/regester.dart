import 'package:flutter/material.dart';
import 'package:test_app/login/regester/create_acc.dart';
import 'package:test_app/login/regester/cretae_acc_charity.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xff68316d),
            width: MediaQuery.of(context).size.width,
            height: 200,
          ),
          const SizedBox(height: 130),
          Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => RegisterCharity(
                                      isObsecure: true,
                                      onItemChange: () {},
                                    ),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xff68316d),
                            ),
                            minimumSize: WidgetStatePropertyAll(Size(70, 70)),
                          ),
                          child: const Text(
                            "سجل دخول كمنظمة",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => CreateNewAccount(
                                      isObsecure: true,
                                      onItemChange: () {},
                                    ),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xff68316d),
                            ),
                            minimumSize: WidgetStatePropertyAll(Size(70, 70)),
                          ),
                          child: const Text(
                            "سجل دخول كمتطوع",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

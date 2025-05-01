import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: Locale('ar'), // لغة التطبيق
      supportedLocales: [
        Locale('ar'), // اللغات المدعومة
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // تعريب عناصر الماتيريال
        GlobalWidgetsLocalizations.delegate, // تعريب عناصر الواجهة
        GlobalCupertinoLocalizations.delegate, // تعريب عناصر iOS
      ],
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // أول شاشة تظهر
    );
  }
}

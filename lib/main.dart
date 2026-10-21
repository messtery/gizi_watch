import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'page1/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GiziWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3E9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6541)),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home: const OnboardingPage(),
    );
  }
}

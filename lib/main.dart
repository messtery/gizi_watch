import 'package:flutter/material.dart';

import 'pages/register_page.dart';

void main() {
  runApp(const GiziWatchApp());
}

class GiziWatchApp extends StatelessWidget {
  const GiziWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GiziWatch',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3E9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6541)),
        fontFamily: 'sans-serif',
      ),
      home: const RegisterPage(),
    );
  }
}

import 'package:flutter/material.dart';

import 'features/dashboard/home_page.dart';

class EduLearnApp extends StatelessWidget {
  const EduLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF193A36);
    const canvas = Color(0xFFF4F5EF);

    return MaterialApp(
      title: 'MASTER4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF26796D),
          surface: canvas,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: ink,
            fontFamily: 'serif',
            fontSize: 32,
            height: 1.08,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(color: Color(0xFF65716D), height: 1.45),
        ),
      ),
      home: const HomePage(),
    );
  }
}

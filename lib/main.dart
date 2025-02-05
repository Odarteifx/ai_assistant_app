import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
      title: 'Nova',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.firaCodeTextTheme().apply(bodyColor: Colors.black) ,
      ),
      home: const AiAsistantApp(),
    );
      },
    );
  }
}

class AiAsistantApp extends StatelessWidget {
  const AiAsistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AiOnboarding();
  }
}
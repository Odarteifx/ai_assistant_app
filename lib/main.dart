import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
        return ShadApp(
          debugShowCheckedModeBanner: false,
          title: 'Nova',
          theme: ShadThemeData(
              colorScheme: const ShadZincColorScheme.light(),
              brightness: Brightness.light,
              textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.firaCode)),
          darkTheme: ShadThemeData(
              colorScheme: const ShadZincColorScheme.dark(),
              brightness: Brightness.dark),
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

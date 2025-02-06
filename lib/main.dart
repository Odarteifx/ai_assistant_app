import 'package:ai_assistant_app/constants/colors.dart';
import 'package:ai_assistant_app/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'screens/onboarding_screen.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
void main()  async{
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return ShadApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Nova',
          theme: ShadThemeData(
              colorScheme: ShadZincColorScheme.light(
                  background: AppColor.backgroundColor),
              brightness: Brightness.light,
              textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.poppins)),
          darkTheme: ShadThemeData(
              colorScheme:
                  const ShadZincColorScheme.dark(background: Color(0xFF121212)),
              brightness: Brightness.dark),
          routerConfig: router,
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

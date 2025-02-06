import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AiOnboarding extends StatefulWidget {
  const AiOnboarding({super.key});

  @override
  State<AiOnboarding> createState() => _AiOnboardingState();
}

class _AiOnboardingState extends State<AiOnboarding> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () => context.go('/signin'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF66C4), Color(0xFFFFde59)],
          ),
        ),
        child: Center(
            child: Image.asset(
          AiAssets.novaIcon,
          width: 250.sp,
        )),
      ),
    );
  }
}

import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/screens/singin_screen.dart';
import 'package:flutter/material.dart';

class AiOnboarding extends StatefulWidget {
  const AiOnboarding({super.key});

  @override
  State<AiOnboarding> createState() => _AiOnboardingState();
}

class _AiOnboardingState extends State<AiOnboarding> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SigninScreen(),
          ));
    });
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
        child: Center(child: Image.asset(AiAssets.novaIcon)),
      ),
    );
  }
}

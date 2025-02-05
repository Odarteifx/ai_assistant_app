import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:flutter/material.dart';

class AiOnboarding extends StatelessWidget {
  const AiOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
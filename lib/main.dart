import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AiAsistantApp(),
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
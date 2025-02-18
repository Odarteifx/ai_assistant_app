import 'package:ai_assistant_app/screens/prompt_page.dart';
import 'package:ai_assistant_app/screens/onboarding_screen.dart';
import 'package:ai_assistant_app/screens/signup_screen.dart';
import 'package:ai_assistant_app/screens/singin_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const AiOnboarding(),
  ),
  GoRoute(
    path: '/signin',
    builder: (context, state) => const SigninScreen(),
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    path: '/mainpage',
    builder: (context, state) => const PromptPage(chatRoomId: 'Id'),
  ),
  GoRoute(
    path: '/prompt/:chatRoomId',
    builder: (context, state) {
      final chatRoomId = state.pathParameters['chatRoomId']!;
      debugPrint(chatRoomId);
      return PromptPage(
        key: ValueKey(chatRoomId), // Add this line
        chatRoomId: chatRoomId,
      );
    },
  ),
]);

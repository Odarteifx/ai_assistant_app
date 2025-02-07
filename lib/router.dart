import 'package:ai_assistant_app/screens/mainpage.dart';
import 'package:ai_assistant_app/screens/onboarding_screen.dart';
import 'package:ai_assistant_app/screens/signup_screen.dart';
import 'package:ai_assistant_app/screens/singin_screen.dart';
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
    builder: (context, state) => const Mainpage(),
  )
]);

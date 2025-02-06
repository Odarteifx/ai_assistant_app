import 'package:ai_assistant_app/screens/onboarding_screen.dart';
import 'package:ai_assistant_app/screens/singin_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AiOnboarding(),),
    GoRoute(path: '/signin', builder: (context, state) => const SigninScreen(),)
  ]
);
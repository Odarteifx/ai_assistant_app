// ignore_for_file: use_build_context_synchronously

import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/colors.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String email = '', password = '';

  final _formkey = GlobalKey<ShadFormState>();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _password = TextEditingController();

  userLogin() async {
    email = _emailAddress.text.trim();
    password = _password.text.trim();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      context.go('/mainpage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShadToaster.of(context).show(const ShadToast(
          description: Text('No user found for that email.'),
        ));
      } else if (e.code == 'wrong-password') {
        ShadToaster.of(context).show(const ShadToast(
            description: Text('Incorrect password. Please try again')));
      } else {
        ShadToaster.of(context).show(ShadToast(
          description: Text('${e.message}'),
        ));
      }
    }
  }

  @override
  void dispose() {
    _emailAddress.dispose();
    _password.dispose();
    super.dispose();
  }

  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          spacing: 5.sp,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AiAssets.novaIcon2,
                  width: 180.w,
                ),
              ],
            ),
            Text(
              'Welcome Back to Nova AI',
              style: TextStyle(
                  fontSize: AppFontSize.onboadingbody,
                  fontWeight: AppFontWeight.bold),
            ),
            Text(
              'Your gateway to intelligent solutions start here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppFontSize.subtext),
            ),
            SizedBox(
              height: 15.h,
            ),
            ShadForm(
                key: _formkey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 350.sp,
                  ),
                  child: Column(
                    spacing: 10.sp,
                    children: [
                      ShadInputFormField(
                        controller: _emailAddress,
                        keyboardType: TextInputType.emailAddress,
                        inputPadding: EdgeInsets.symmetric(vertical: 6.sp),
                        id: 'email',
                        placeholder: const Text('Enter your email address'),
                      ),
                      ShadInputFormField(
                        controller: _password,
                        id: 'password',
                        prefix: Padding(
                          padding: EdgeInsets.all(4.sp),
                          child: const Icon(LucideIcons.lock),
                        ),
                        suffix: ShadButton(
                          width: 24.w,
                          height: 24.h,
                          icon: Icon(
                              obscure ? LucideIcons.eyeOff : LucideIcons.eye),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ),
                        obscureText: obscure,
                        placeholder: const Text('Password'),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ShadButton(
                                  onPressed: () {
                                    userLogin();
                                  },
                                  height: 48.sp,
                                  backgroundColor: const Color(0xFFE344A6),
                                  pressedBackgroundColor:
                                      const Color(0xFFCA4E9A),
                                  child: const Text(
                                    'Continue with Email',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ShadButton.ghost(
                                size: ShadButtonSize.sm,
                                height: 15.sp,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontSize: AppFontSize.termsfont,
                                      color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Text('OR'),
                      Row(
                        children: [
                          Expanded(
                            child: ShadButton(
                              onPressed: () {},
                              height: 48.sp,
                              decoration: ShadDecoration(
                                  border: ShadBorder.all(
                                      color: const Color(0xFFE0E0E0),
                                      style: BorderStyle.solid,
                                      width: 1.w)),
                              backgroundColor: AppColor.backgroundColor,
                              pressedBackgroundColor: const Color(0xFFE0E0E0),
                              icon: Image.asset(
                                AiAssets.googleIcon,
                                height: 18.sp,
                              ),
                              child: const Text(
                                'Continue with Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ShadButton(
                              onPressed: () {},
                              height: 48.sp,
                              icon: Image.asset(
                                AiAssets.appleIcon,
                                height: 20.sp,
                              ),
                              child: const Text(
                                'Continue with Apple',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'By continuing, you agree to Nova\'s Consumer Terms and Usage Policy, and acknoledge their Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: AppFontSize.termsfont),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an Account?  ',
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                              onTap: () => context.go('/signup'),
                              child: const Text('Create Account',
                                  style: TextStyle(color: Color(0xFFE344A6))))
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/colors.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: AppColor.backgroundColor,
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
              style: TextStyle(fontSize: 20.sp, fontWeight: AppFontWeight.bold),
            ),
            const Text(
              'Your gateway to intelligent solutions start here.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.h,
            ),
            ShadForm(
                child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 350.sp,
              ),
              child: Column(
                spacing: 10.sp,
                children: [
                  ShadInputFormField(
                    inputPadding: EdgeInsets.symmetric(vertical: 6.sp),
                    id: 'email',
                    // label: const Text('Email address'),
                    placeholder: const Text('Enter your email address'),
                  ),
                  ShadInputFormField(
                    id: 'password',
                    prefix: Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: const Icon(LucideIcons.lock),
                    ),
                    suffix: ShadButton(
                      width: 24.w,
                      height: 24.h,
                      icon:
                          Icon(obscure ? LucideIcons.eyeOff : LucideIcons.eye),
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                    ),
                    obscureText: obscure,
                    placeholder: const Text('Password'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ShadButton(
                          onPressed: () {},
                          height: 48.sp,
                          backgroundColor: const Color(0xFFE344A6),
                          pressedBackgroundColor: const Color(0xFFCA4E9A),
                          child: const Text(
                            'Continue with Email',
                          ),
                        ),
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
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 7),
                                child: Image.asset(AiAssets.googleIcon),
                              ),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
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
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 6),
                                child: Image.asset(AiAssets.appleIcon),
                              ),
                              const Text(
                                'Continue with Apple',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'By continuing, you agree to Nova\'s Consumer Terms and Usage Policy, and acknoledge their Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../constants/ai_assets.dart';
import '../constants/typography.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final _formkey = GlobalKey<ShadFormState>();
final TextEditingController _emailAddress = TextEditingController();
final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

@override
void dispose() {
  _emailAddress.dispose();
  _password.dispose();
}

class _SignupScreenState extends State<SignupScreen> {
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
              'Welcome to Nova AI',
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
                        controller: _username,
                        keyboardType: TextInputType.emailAddress,
                        inputPadding: EdgeInsets.symmetric(vertical: 6.sp),
                        id: 'name',
                        placeholder: const Text('Full name'),
                      ),
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
                      ShadInputFormField(
                        controller: _confirmPassword,
                        id: 'Confirm password',
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
                        placeholder: const Text('Confirm Password'),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ShadButton(
                                  onPressed: () {
                                    //verification & navigate to Main Screen
                                  },
                                  height: 48.sp,
                                  backgroundColor: const Color(0xFFE344A6),
                                  pressedBackgroundColor:
                                      const Color(0xFFCA4E9A),
                                  child: const Text(
                                    'Create Account',
                                  ),
                                ),
                              ),
                            ],
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
                            'Already have an Account?  ',
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                              onTap: () => context.go('/signin'),
                              child: const Text('Log In',
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

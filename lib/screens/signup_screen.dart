// ignore_for_file: use_build_context_synchronously

import 'package:ai_assistant_app/screens/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

String name = '', email = '', password = '', confirmpassword = '';

final _formkey = GlobalKey<ShadFormState>();
final TextEditingController _emailAddress = TextEditingController();
final TextEditingController _password = TextEditingController();
final TextEditingController _username = TextEditingController();
final TextEditingController _confirmPassword = TextEditingController();

@override
void dispose() {
  _emailAddress.dispose();
  _password.dispose();
  _username.dispose();
  _confirmPassword.dispose();
}

registration(BuildContext context) async {
  if (_formkey.currentState!.validate()) {
    name = _username.text.trim();
    email = _emailAddress.text.trim();
    password = _password.text.trim();
    confirmpassword = _confirmPassword.text.trim();

    if (password == confirmpassword &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        FirebaseAuth.instance.currentUser?.updateDisplayName(name);

        await FirebaseFirestore.instance
            .collection('User')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'id': userCredential.user!.uid,
        });

        context.go('/mainpage');
        ShadToaster.of(context).show(const ShadToast(
          description: Text('Account Successfully Created'),
        ));
        
        debugPrint('Account Created!');
      } on FirebaseException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'Your password is too simple. Try adding more characters, numbers, or symbols.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Account already exists. Try logging in or use a different email.';
        } else {
          errorMessage = e.message ?? 'An unknown error occurred.';
        }
        ShadToaster.of(context).show( ShadToast(
          description: Text(errorMessage),
        ));
      } catch (e) {
        // Handle any other errors
        ShadToaster.of(context).show( ShadToast(
          description: Text('Error: ${e.toString()}'),
        ));
      }
    } else {
       ShadToaster.of(context).show( const ShadToast(
          description: Text('Passwords do not match'),
        ));
    }
  } else {
   ShadToaster.of(context).show( const ShadToast(
          description: Text('Please fill in all fields'),
        )); 
  }
}

class _SignupScreenState extends State<SignupScreen> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          spacing: 3.sp,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 12.sp,
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your full name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      ShadInputFormField(
                          controller: _emailAddress,
                          keyboardType: TextInputType.emailAddress,
                          inputPadding: EdgeInsets.symmetric(vertical: 6.sp),
                          id: 'email',
                          placeholder: const Text('Enter your email address'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          }),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a valid password';
                            } else {
                              return null;
                            }
                          }),
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter confirmation password';
                            } else {
                              return null;
                            }
                          }),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ShadButton(
                                  onPressed: () {
                                    registration(context);
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



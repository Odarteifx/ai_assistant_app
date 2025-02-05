import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../constants/colors.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          spacing: 10.sp,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.sp,
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
              style: TextStyle(fontSize: 20, fontWeight: AppFontWeight.bold),
            ),
            const Text(
              'Your gateway to intelligent solutions start here.',
              textAlign: TextAlign.center,
            ),
          
          ],
        ),
      ),
    );
  }
}

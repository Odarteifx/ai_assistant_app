import 'package:ai_assistant_app/constants/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatMenu extends StatelessWidget {
  const ChatMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      constraints: BoxConstraints(minWidth: 290.w, maxHeight: 840.h),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35.sp,
            ),
            Text(
              'Chat History',
              style: TextStyle(fontSize: AppFontSize.onboadingbody, fontWeight: AppFontWeight.bold),
            ),

            //Prompt History Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 250.sp,
                      child: const Center(
                          child: Text(
                        'No History',
                        style: TextStyle(color: Colors.grey),
                      ))),
                ],
              ),
            ),
            //Divider
            SizedBox(
              width: 250.sp,
              child: const Divider(),
            ),
            SizedBox(
              width: 250.sp,
              child: Row(
                spacing: 8.sp,
                children: [
                  ShadAvatar('', size: Size(40.sp, 40.sp)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(FirebaseAuth.instance.currentUser!.displayName
                          .toString()),
                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: TextStyle(
                            fontSize: AppFontSize.termsfont,
                            color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

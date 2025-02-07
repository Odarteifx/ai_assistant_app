import 'package:ai_assistant_app/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShadButton.ghost(
                icon: Icon(LucideIcons.menu, size: 20.sp,),
                onPressed: () {
                },
              ),
               Text('New Chat', style: TextStyle(fontSize: 16.sp),),
               ShadButton.ghost(
                icon: Icon(LucideIcons.messageSquarePlus, size: 20.sp,),
                onPressed: () {
                  
                },
              )

            ],
          )
        ],
      ),
    )
    );
  }
}
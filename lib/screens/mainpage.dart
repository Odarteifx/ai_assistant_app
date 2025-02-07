import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../ai_widgets.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

String input = '';
final TextEditingController _inputcontroller = TextEditingController();

class _MainpageState extends State<Mainpage> {
  message() async {
    input = _inputcontroller.text.trim();
  }

  @override
  dispose() {
    _inputcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShadButton.ghost(
                icon: Icon(
                  LucideIcons.menu,
                  size: 20.sp,
                ),
                onPressed: () {
                  showShadSheet(
                    side: ShadSheetSide.left,
                    context: context,
                    builder: (context) {
                      return const ChatMenu();
                    },
                  );
                },
              ),
              Text(
                'New Chat',
                style: TextStyle(fontSize: 16.sp),
              ),
              ShadButton.ghost(
                icon: Icon(
                  LucideIcons.messageSquarePlus,
                  size: 20.sp,
                ),
                onPressed: () {},
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AiAssets.novaIcon2,
                  width: 150.w,
                ),
                Text(
                  'Hi, I\'m Nova.',
                  style: TextStyle(
                      fontWeight: AppFontWeight.bold,
                      fontSize: AppFontSize.onboadingbody),
                ),
                Text(
                  'How can I help you today?',
                  style: TextStyle(
                      fontSize: AppFontSize.subtext,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 320.sp),
                child: ShadForm(
                  child: ShadInputFormField(
                    controller: _inputcontroller,
                    id: 'input',
                    placeholder: const Text('Ask Nova'),
                    keyboardType: TextInputType.text,
                    inputPadding: EdgeInsets.symmetric(vertical: 3.sp),
                    prefix: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          LucideIcons.plus,
                          size: 18.sp,
                        )),
                    suffix: GestureDetector(
                        child: Icon(
                      LucideIcons.mic,
                      size: 18.sp,
                    )),
                  ),
                ),
              ),
              ShadButton(
                onPressed: () {
                  message();
                  if (input.isEmpty) {
                    null;
                    _inputcontroller.clear();
                  } else {
                    debugPrint(input);
                    _inputcontroller.clear();
                  }
                },
                icon: Icon(
                  LucideIcons.sendHorizontal,
                  size: 20.sp,
                ),
                backgroundColor: const Color(0xFFE344A6),
                pressedBackgroundColor: const Color(0xFFCA4E9A),
              )
            ],
          )
        ],
      ),
    ));
  }
}

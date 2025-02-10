import 'package:ai_assistant_app/Services/chat_services.dart';
import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../ai_widgets.dart';

class Promptpage extends StatefulWidget {
  const Promptpage({super.key});

  @override
  State<Promptpage> createState() => _PromptpageState();
}

class _PromptpageState extends State<Promptpage> {
  String input = '';
  final TextEditingController _inputcontroller = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  String chatRoomId = '';

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    chatRoomId = await _chatServices.createChatRoom();
  }

  void sendMessage() async {
    input = _inputcontroller.text.trim();
    if (input.isNotEmpty) {
      await _chatServices.sendMessage(chatRoomId, input);
      debugPrint(input);
      _inputcontroller.clear();
    } else {
      null;
      _inputcontroller.clear();
    }
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
              StreamBuilder(
                stream: _chatServices.getMessages(chatRoomId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      'New Chat',
                      style: TextStyle(fontSize: 16.sp),
                    );
                  } else {
                    String firstMessage = snapshot.data!.docs.first['message'];
                    List<String> words = firstMessage.split('');
                    String title = words.length > 3
                        ? '${words.sublist(0, 20).join('')}...'
                        : firstMessage;
                    return Text(title);
                  }
                },
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
            child: StreamBuilder(
              stream: _chatServices.getMessages(chatRoomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
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
                  );
                } else {
                  return buildMessageList();
                }
              },
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
                    minLines: 1,
                    maxLines: 8,
                    placeholder: const Text('Ask Nova...'),
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
                  sendMessage();
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

  buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessages(chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == FirebaseAuth.instance.currentUser!.uid)
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
    var color = (data['senderId'] == FirebaseAuth.instance.currentUser!.uid)
        ? const Color(0xFFFDE8F4)
        : const Color(0xfff5f5f5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
          alignment: alignment,
          child: Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(15.sp)),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Text(data['message']),
              ))),
    );
  }
}

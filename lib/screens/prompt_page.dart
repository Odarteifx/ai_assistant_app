import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ai_widgets.dart';
import '../constants/ai_assets.dart';
import '../constants/typography.dart';
import '../services/chat_services.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  String input = '';
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatServices _chatServices = ChatServices();
  String chatRoomId = 'Id';
  bool chatRoomCreated = false;

  @override
  void initState() {
    super.initState();
    _checkIfChatRoomExists();
  }

  Future<void> _checkIfChatRoomExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('created_by', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          chatRoomId = querySnapshot.docs.first.id;
          chatRoomCreated = true;
        });
      } else {
        await _createChatRoomForUser();
      }
    }
  }

  Future<void> _createChatRoomForUser() async {
    try {
      chatRoomId = await _chatServices.createChatRoom();
      setState(() {
        chatRoomCreated = true;
      });
    } catch (e) {
      // Handle error creating chat room
      debugPrint('Error creating chat room: $e');
    }
  }

  Future<void> _initializeChatRoom() async {
    chatRoomId = await _chatServices.createChatRoom();
    setState(() {
      chatRoomCreated = true;
    });
  }

  void sendMessage() async {
    input = _inputController.text.trim();
    if (input.isNotEmpty) {
      if (!chatRoomCreated) {
        await _initializeChatRoom();
      }
      await _chatServices.sendMessage(chatRoomId, input);
      debugPrint(input);
      debugPrint('Message is written in $chatRoomId');
      _inputController.clear();
      _scrollToBottom();
    } else {
      _inputController.clear();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
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
                  icon: Icon(LucideIcons.menu, size: 20.sp),
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
                      String firstMessage =
                          snapshot.data!.docs.first['message'];
                      List<String> words = firstMessage.split(' ');
                      String title = words.length > 20
                          ? '${words.sublist(0, 20).join(' ')}...'
                          : firstMessage;
                      return Text(
                        title,
                        style: TextStyle(fontSize: 16.sp),
                      );
                    }
                  },
                ),
                ShadButton.ghost(
                  icon: Icon(
                    LucideIcons.messageSquarePlus,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    _initializeChatRoom();
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                      stream: _chatServices.getMessages(chatRoomId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
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
                      controller: _inputController,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessages(chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((document) {
            return buildMessageItem(document);
          }).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
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
            color: color,
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data['message']),
          ),
        ),
      ),
    );
  }
}

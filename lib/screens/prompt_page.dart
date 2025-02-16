import 'dart:convert';

import 'package:ai_assistant_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../ai_widgets.dart';
import '../constants/ai_assets.dart';
import '../constants/typography.dart';
import '../services/chat_services.dart';

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> with TickerProviderStateMixin {
  dynamic input = '';
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatServices _chatServices = ChatServices();
  String chatRoomId = 'Id';
  String? _deepSeekResponse;
  bool chatRoomCreated = false;
  bool _isLoading = false;

  final String apiKey = '${dotenv.env['DEEPSEEK_KEY']}';
  final String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';

  late AnimationController _animationController;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _checkIfChatRoomExists();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _dotsAnimation = IntTween(begin: 0, end: 3).animate(_animationController);
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
    final user = FirebaseAuth.instance.currentUser;
    const deepSeekId = 'DeepSeekId';
    if (input.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _deepSeekResponse = null;
      });
      _inputController.clear();

      if (!chatRoomCreated) {
        await _initializeChatRoom();
      }

      await _chatServices.sendMessage(user!.uid, chatRoomId, input);
      _scrollToBottom();

      try {
        final response = await http.post(Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode({
              'model': 'deepseek/deepseek-chat:free',
              'messages': [
                {"role": "user", "content": input}
              ],
            }));
        if (response.statusCode == 200) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          _deepSeekResponse = responseData['choices'][0]['message']['content'];

          await _chatServices.sendMessage(
              deepSeekId, chatRoomId, _deepSeekResponse!);
          _scrollToBottom();
        } else {
          _deepSeekResponse == 'Error: Unable to fetch response from DeepSeek.';
          await _chatServices.sendMessage(
              deepSeekId, chatRoomId, _deepSeekResponse);
          debugPrint('Error: ${response.statusCode} - ${response.body}');
          _scrollToBottom();
        }
      } catch (e) {
        _deepSeekResponse == 'Error: An exception occurred.';
        debugPrint('Exception: $e');
        await _chatServices.sendMessage(
            deepSeekId, chatRoomId, _deepSeekResponse!);
        _scrollToBottom();
      } finally {
        setState(() {
          _isLoading = false;
        });
        _scrollToBottom();
      }
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
    _animationController.dispose();
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
                           const int maxLength = 30;
                      String title = firstMessage.length > maxLength ? '${firstMessage.substring(0, maxLength)}...' : firstMessage;
                      return Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15.sp),
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
                      placeholder: _isLoading
                          ? AnimatedBuilder(
                              animation: _dotsAnimation,
                              builder: (context, child) {
                                String dots = '.' * _dotsAnimation.value;
                                return Text('Nova is thinking$dots');
                              },
                            )
                          : const Text('Ask Nova...'),
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
                    _isLoading
                        ? LucideIcons.circleStop
                        : LucideIcons.sendHorizontal,
                    size: 20.sp,
                  ),
                  backgroundColor: _isLoading
                      ? const Color(0xB6877B82)
                      : const Color(0xFFE344A6),
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

    var isUser = data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
    var alignment = isUser ? Alignment.bottomRight : Alignment.bottomLeft;
    var color = isUser ? const Color(0xFFFDE8F4) : AppColor.backgroundColor;
    String message = data['message'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        alignment: alignment,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isUser
                ? ShadAvatar(AiAssets.novaIcon2,
                    size: Size(32.sp, 32.sp),
                    backgroundColor: AppColor.backgroundColor,
                    shape: const CircleBorder(
                        side: BorderSide(color: Color(0xfff5f5f5))))
                : const Text(''),
            !isUser
                ? SizedBox(
                    width: 5.sp,
                  )
                : const SizedBox(),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15.sp),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText.rich(
                  TextSpan(
                      children: _parseMessage(message),
                    ),
                   style: TextStyle(fontSize: AppFontSize.subtext),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    List<TextSpan> _parseMessage(String message) {
    final List<TextSpan> spans = [];
    final RegExp exp =
        RegExp(r'(\*\*.*?\*\*|:[a-z_]+:|###.*|[^*]+)', unicode: true);
    final Iterable<Match> matches = exp.allMatches(message);

    for (final Match match in matches) {
      final String text = match.group(0)!;
      if (text.startsWith('**') && text.endsWith('**')) {
        spans.add(TextSpan(
          text: text.substring(2, text.length - 2),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else {
        spans.add(TextSpan(text: text));
      }
    }

    return spans;
  }
}

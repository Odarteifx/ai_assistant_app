import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatMenu extends StatelessWidget {
  const ChatMenu({super.key});

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    bool hasPhoto = user!.photoURL != null;
    return ShadSheet(
      constraints: BoxConstraints(minWidth: 290.w, maxHeight: 840.h),
      child: Material(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35.sp,
              ),
              Text(
                'Chat History',
                style: TextStyle(
                    fontSize: AppFontSize.onboadingbody,
                    fontWeight: AppFontWeight.bold),
              ),

              //Prompt History Section
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat_rooms')
                      .where('created_by', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return SizedBox(
                        width: 250.sp,
                        child: const Center(
                          child: Text(
                            'No History',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    var chatRooms = snapshot.data!.docs;

                    return SizedBox(
                      width: 260.sp,
                      child: ListView.builder(
                        itemCount: chatRooms.length,
                        itemBuilder: (context, index) {
                          var chatRoom = chatRooms[
                              index]; // This is a QueryDocumentSnapshot

                          // Access data using QueryDocumentSnapshot methods
                          String firstMessageText = 'No messages yet';
                          final messages = chatRoom.data()[
                              'messages']; //Access the messages field correctly

                          if (messages != null &&
                              messages is List &&
                              messages.isNotEmpty) {
                            if (messages.isNotEmpty &&
                                messages[0]['text'] != null) {
                              firstMessageText = messages[0]['text'] as String;
                            }
                          }

                          return ListTile(
                            title: Text(
                              firstMessageText,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                             debugPrint(chatRoom.data().values.toString());
                            },
                          );
                        },
                      ),
                    );
                  },
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
                    ShadAvatar(hasPhoto ? user.photoURL : AiAssets.noProfilepic,
                        size: Size(40.sp, 40.sp), fit: BoxFit.cover),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.email.toString(),
                          overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

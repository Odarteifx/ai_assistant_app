import 'package:ai_assistant_app/Services/chat_services.dart';
import 'package:ai_assistant_app/constants/ai_assets.dart';
import 'package:ai_assistant_app/constants/colors.dart';
import 'package:ai_assistant_app/constants/typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 35.sp,
              ),
              child: Text(
                'Chat History',
                style: TextStyle(
                    fontSize: AppFontSize.onboadingbody,
                    fontWeight: AppFontWeight.bold),
              ),
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
                      width: 260.sp,
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
                      padding: EdgeInsets.zero,
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        var chatRoom = chatRooms[index];
                        String newchatRoomId = chatRoom.id;
                        String firstMessageText = 'No messages yet';

                        return StreamBuilder(
                          stream: ChatServices().getMessages(newchatRoomId),
                          builder: (context, messageSnapshot) {
                            // if (messageSnapshot.connectionState == ConnectionState.waiting) {
                            //   return const Center(child: CircularProgressIndicator());
                            // }

                            if (!messageSnapshot.hasData ||
                                messageSnapshot.data!.docs.isEmpty) {
                              firstMessageText = 'No messages yet';
                            } else {
                              firstMessageText =
                                  messageSnapshot.data!.docs.first['message'];
                            }

                            return ListTile(
                              dense: true,
                              title: Text(
                                firstMessageText,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: AppFontSize.subtext),
                              ),
                              onTap: () {
                                context.go('/prompt/$newchatRoomId');
                              },
                            );
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
            GestureDetector(
              onTap: () {
                showShadSheet(
                  side: ShadSheetSide.bottom,
                  context: context,
                  builder: (context) {
                    return ShadSheet(
                      constraints: BoxConstraints(
                        minHeight: 750.w,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: AppFontSize.onboadingbody,
                            fontWeight: AppFontWeight.bold),
                      ),
                      child: Column(
                        children: [
                           SizedBox(height: 10.sp,),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFFDAD8D8)),
                                borderRadius: BorderRadius.circular(10.sp)),
                            child: Padding(
                              padding: EdgeInsets.all(8.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(user.email.toString().toLowerCase()),
                                  emailStatus(user.emailVerified)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.sp,),
                          const ProfileTile(
                              icon: Iconsax.document,
                              iconText: 'Terms of Use'),
                              const ProfileTile(
                              icon: LucideIcons.hand,
                              iconText: 'Privacy Policy'),
                              const ProfileTile(
                              icon: Iconsax.info_circle,
                              iconText: 'Check for updates')
                        ],
                      ),
                    );
                  },
                );
              },
              child: SizedBox(
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
                          user.email.toString().toLowerCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: AppFontSize.termsfont,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

emailStatus(bool emailStatus) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
    decoration: BoxDecoration(
      color: emailStatus ? const Color(0xFFE6F4EA) : const Color(0xFFFFF4E5),
      borderRadius: BorderRadius.circular(10.sp),
    ),
    child: Text(
      emailStatus ? 'verified' : 'not verified',
      style: TextStyle(
          color: emailStatus ? Colors.green : Colors.orange,
          fontSize: AppFontSize.termsfont,
          fontWeight: AppFontWeight.semibold),
    ),
  );
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.icon,
    required this.iconText,
    this.onpressed,
  });

  final IconData icon;
  final String iconText;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            Icon(
              icon,
               color: Colors.grey
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              iconText,
              style: TextStyle(
                  fontSize: AppFontSize.subtext,
                  fontWeight: AppFontWeight.regular),
            ),
            const Expanded(child: SizedBox()),
            Icon(
              Iconsax.arrow_right_3,
               color: AppColor.iconColor,
            )
          ],
        ),
      ),
    );
  }
}

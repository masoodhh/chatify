import 'package:chatify/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/text_styles.dart';
import 'messages.get.dart';

class MessagesTabbar extends StatelessWidget {
  final TabController controller;

  MessagesTabbar({super.key, required this.controller});

  final messagesGet = Get.find<MessagesGet>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: MyColors.primaryColor,
          tabs: [
            StreamBuilder(
              stream: messagesGet.contactsStream.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                final int contactsBadgeCount = messagesGet.contacts.where((contact) {
                  return contact.messages.any((message) => !message.seen);
                }).length;
                return SizedBox(
                  width: 70,
                  height:60 ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          CupertinoIcons.chat_bubble_2,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                      if (contactsBadgeCount > 0)
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: MyColors.primaryColor,
                          child: Text(contactsBadgeCount.toString(),
                              style: MyTextStyles.small
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                );
              },
            ),
            StreamBuilder(
              stream: messagesGet.roomStream.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                final int roomsBadgeCount = messagesGet.rooms.where((contact) {
                  return contact.messages.any((message) => !message.seen);
                }).length;
                return SizedBox(
                  width: 70,
                  height:60 ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          CupertinoIcons.collections,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      if (roomsBadgeCount > 0)
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: MyColors.primaryColor,
                          child: Text(roomsBadgeCount.toString(),
                              style: MyTextStyles.small
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                );
              },
            ),
          ]),
    );
  }
}

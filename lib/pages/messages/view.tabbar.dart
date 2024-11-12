import 'package:chatify/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagesTabbar extends StatelessWidget {
  final TabController controller;
  const MessagesTabbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: MyColors.primaryColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                CupertinoIcons.chat_bubble_2,
                color: Colors.grey,
                size: 28,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                CupertinoIcons.collections,
                color: Colors.grey,
                size: 22,
              ),
            ),
          ]),
    );
  }
}
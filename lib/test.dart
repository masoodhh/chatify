import 'package:chatify/constants/colors.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:chatify/pages/messages/view.chats.dart';
import 'package:chatify/pages/messages/view.rooms.dart';
import 'package:chatify/pages/messages/view.tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _MessagesState();
}

class _MessagesState extends State<Test> with TickerProviderStateMixin {

  @override
  void initState() {

    logger.w("test initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
          child: Container(
              width: 200,
              height: 150,
              color: Colors.amber,
              child: Center(
                child: Text("TEST"),
              ))),
    );
  }
}

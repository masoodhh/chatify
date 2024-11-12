import 'package:chatify/constants/colors.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:chatify/pages/messages/view.chats.dart';
import 'package:chatify/pages/messages/view.rooms.dart';
import 'package:chatify/pages/messages/view.tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with TickerProviderStateMixin {
  TabController? _controller;
  // final messagesGet = Get.find<MessagesGet>();
  final messagesGet = Get.put(MessagesGet());

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MESSAGES'),
        leading: IconButton(
            onPressed: () => Get.toNamed(PageRoutes.settings),
            icon: const Icon(CupertinoIcons.line_horizontal_3_decrease)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
        ],
      ),
      body: Column(
        children: [
          MessagesTabbar(controller: _controller!),
          Expanded(
              child: TabBarView(controller: _controller, children: [
            MessagesChatsTab(),
            MessagesRoomsTab(),
          ])),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed:()=> _controller?.index==0? messagesGet.addContact():messagesGet.addRoom(),
          backgroundColor: MyColors.primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

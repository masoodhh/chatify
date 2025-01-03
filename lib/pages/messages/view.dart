import 'package:chatify/constants/colors.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/constants/text_styles.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:chatify/pages/messages/view.chats.dart';
import 'package:chatify/pages/messages/view.rooms.dart';
import 'package:chatify/pages/messages/view.tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/connectionChecker.widget.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> with TickerProviderStateMixin {
  TabController? _controller;
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
        title: Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Messages',
              style: MyTextStyles.header2,
            ),
            ConnectionChecker(),
          ],
        )),
        leading: IconButton(
            onPressed: () => Get.toNamed(PageRoutes.settings),
            icon: const Icon(Icons.more_vert),),
        actions: [
          Obx(
            () => IconButton(
                onPressed: () => messagesGet.isSearchEnabled.value = !messagesGet.isSearchEnabled.value,
                icon: messagesGet.isSearchEnabled.value
                    ? const Icon(Icons.close)
                    : const Icon(CupertinoIcons.search)),
          ),
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
          onPressed: () => _controller?.index == 0 ? messagesGet.addContact() : messagesGet.addRoom(),
          backgroundColor: MyColors.primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

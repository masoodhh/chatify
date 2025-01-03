import 'package:chatify/components/message.widget.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/constants/text_styles.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/pages/properties/room.get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoomProperties extends StatelessWidget {
  RoomProperties({Key? key}) : super(key: key);

  final roomGet = Get.put(RoomPropertiesGet());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Properties'),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.size.height / 3,
            width: double.infinity,
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Icon(Icons.person, color: Colors.grey.shade400, size: 50)),
              imageUrl: Config.showRoomAvatarBaseUrl(roomGet.room?.id ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(roomGet.room?.name ?? '', style: Get.theme.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(roomGet.room?.desc ?? '', style: Get.theme.textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('Members: ${roomGet.room?.members.length}',
                style: MyTextStyles.caption!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Expanded(
              child: Container(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return MessageWidget(
                    contact: Contact(user: roomGet.room!.members[index],messages: []),
                  );
                  return Text(
                    '${roomGet.room?.members[index].username}',
                    style: Get.theme.textTheme.headlineSmall!.copyWith(color: Colors.black),
                  );
                },
                itemCount: roomGet.room?.members.length),
          )),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                    onPressed: roomGet.deleteRoom,
                    child: Text(
                      'Delete Room',
                      style: MyTextStyles.button!.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                    )),
              ),
              Expanded(
                child: TextButton(
                    onPressed: roomGet.leaveRoom,
                    child: Text(
                      'Leave Room',
                      style: MyTextStyles.button!.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

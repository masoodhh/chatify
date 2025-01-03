import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/init.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/room.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';

class ChatGet extends GetxController {
  User? user;
  Room? room;
  Contact? contact;
  var message = ''.obs;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  AppInit appInit = AppInit();
  List<Message> messages = [];
  final onUpdateStream = PublishSubject<bool>();

  final messagesGet = Get.find<MessagesGet>();
  var profilePic = ''.obs;

  @override
  void onInit() {
    if (Get.arguments.runtimeType == Room) {
      room = Get.arguments;
      appInit.currentChatRoom = room;
      initRoom();
    } else {
      user = Get.arguments;
      appInit.currentChatUser = user;
      initContact();
    }
    onUpdateStream.listen((_) {
      Future.delayed(const Duration(milliseconds: 100))
          .then((_) => scrollController.jumpTo(scrollController.position.maxScrollExtent));
    });

    super.onInit();
  }

  void initRoom() async {
    room = await HiveCacheManager().getRoom(room?.id ?? '');

    await HiveCacheManager().updateLastSeenRoom(room?.id ?? '');
    (Get.find<MessagesGet>()).roomStream.sink.add(true);

    messages.clear();
/*    final messagesWithUser3 = [
      Message(
        date: DateTime.now().subtract(Duration(minutes: 15)),
        message: 'سلام، یک فایل جدید برای پروژه فرستادم.',
        user: contact!.user,
      ),
      Message(
        date: DateTime.now().subtract(Duration(minutes: 14)),
        message: 'سلام، ممنون. بررسی می‌کنم.',
        user: Config.me!.exportToUser(), // کاربر 3
      ),
      Message(
        date: DateTime.now().subtract(Duration(minutes: 13)),
        message: 'لطفاً نظرت رو زودتر بگو چون باید تا فردا آماده کنیم.',
        user: contact!.user,
      ),
      Message(
        date: DateTime.now().subtract(Duration(minutes: 12)),
        message: 'حتماً. الان دارم نگاه می‌کنم.',
        user: Config.me!.exportToUser(),
      ),
      Message(
        date: DateTime.now().subtract(Duration(minutes: 11)),
        message: 'عالیه، ممنونم!',
        user: contact!.user,
      ),
    ]*/;

    // messages.addAll(messagesWithUser3);
    messages.addAll(room?.messages ?? []);

    profilePic.value = Config.showRoomAvatarBaseUrl(room!.id ?? '');
    onUpdateStream.sink.add(true);

    Future.delayed(const Duration(milliseconds: 100))
        .then((_) => scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  void initContact() async {
    logger.w("initContact 1");
    contact = await HiveCacheManager().get(user!.id);

    await HiveCacheManager().updateLastSeen(user!.id);
    (Get.find<MessagesGet>()).contactsStream.sink.add(true);

    messages.clear();
    messages.addAll(contact?.messages ?? []);
    profilePic.value = Config.showAvatarBaseUrl(contact!.user.id ?? '');

    onUpdateStream.sink.add(true);

    Future.delayed(const Duration(milliseconds: 100))
        .then((_) => scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  void userInfo() {
    if (contact == null) {
      Get.toNamed(PageRoutes.roomProperties, arguments: room!);
    } else {
      Get.toNamed(PageRoutes.contactProperties, arguments: contact!);
    }
  }

  void send() {
    _sendMessage(false, user!.id);
  }

  void sendMessageInRoom() {
    _sendMessage(true, room!.id);
  }

  void _sendMessage(bool isRoom, String recipientId) {
    if (message.value.isEmpty) return;
    if (Config.connectionStateStream.value != ConnectionStatus.online) {
      Config.errorHandler(title: "Error", message: "You are offline");
      return;
    }

    appInit.socket?.emit('send-message', {'message': message.value, (isRoom ? 'roomId' : 'to'): recipientId});
    final myMsg = Message(
        date: DateTime.now(),
        message: message.value,
        user: Config.me!.exportToUser(),
        seen: true,
        roomId: isRoom ? recipientId : "");
    messages.add(myMsg);

    if (isRoom) {
      HiveCacheManager().updateRoom(recipientId, myMsg);
      messagesGet.roomStream.sink.add(true);
    } else {
      HiveCacheManager().update(recipientId, myMsg);
      messagesGet.contactsStream.sink.add(true);
    }

    message.value = '';
    controller.clear();
    onUpdateStream.sink.add(true);
  }

  @override
  void dispose() {
    appInit.currentChatUser = null;
    appInit.currentChatRoom = null;
    super.dispose();
  }
}

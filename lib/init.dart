import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/chat/chat.get.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chatify/models/room.dart';

class AppInit {
  static final AppInit _singleton = AppInit._internal();

  factory AppInit() {
    return _singleton;
  }

  AppInit._internal();

  IO.Socket? socket;
  User? currentChatUser;
  Room? currentChatRoom;

  void initSocketClient() {
    Config.connectionStateStream.sink.add(ConnectionStatus.connecting);
    AppInit().socket = IO.io(
        '${Config.socketServerBaseUrl}?token=${Config.me!.token}',
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .enableForceNew()
            .enableReconnection()
            .setReconnectionDelay(3000)
            .setReconnectionAttempts(2)
            .build());

    AppInit().socket?.onConnect((data) {
      Config.connectionStateStream.sink.add(ConnectionStatus.online);
    });

    AppInit().socket?.onReconnectFailed((data) {
      Config.connectionStateStream.sink.add(ConnectionStatus.connectionFailed);
    });
    AppInit().socket?.onDisconnect((data) {
      Config.connectionStateStream.sink.add(ConnectionStatus.connecting);
      // _retryConnection(); // تلاش برای اتصال مجدد
    });
    AppInit().socket?.on('onMessage', (data) => _onMessageHandler(data));
    AppInit().socket?.on('onGroupCreate', (data) => _onGroupCreateHandler(data));

    AppInit().socket?.connect();
  } // end socket client initialization

  _onMessageHandler(Map<String, dynamic> json) {
    logger.w("onMessage");
    logger.w(json);
    final messagesGet = Get.find<MessagesGet>();
    final message = Message(
        date: DateTime.now(),
        message: json['message'],
        roomId: json['roomId'] ?? '',
        user: User.fromSocketJson(json['from']));
    if (message.roomId != '' && message.user.id == Config.me!.userId) return;
    if ((message.user.id == currentChatUser?.id && message.roomId == '') ||
        (message.roomId == currentChatRoom?.id)) {
      try {
        final chatGet = Get.find<ChatGet>();
        message.seen = true; // when user is inside chat page
        chatGet.messages.add(message);
        chatGet.onUpdateStream.sink.add(true);
      } catch (er) {
        print(er);
      }
    }
    if (message.roomId == '') {
      HiveCacheManager().update(message.user.id, message);
      messagesGet.contactsStream.sink.add(true);
    } else {
      HiveCacheManager().updateRoom(message.roomId, message);
      messagesGet.roomStream.sink.add(true);
    }
  }

  _onGroupCreateHandler(Map<String, dynamic> json) async {
    logger.w("onGroupCreate");
    logger.w(json);
    List<User> members = [];
    for (int i = 0; i < json['message']['members'].length; i++) {
      final user = User.fromMakeRoomJson(json['message']['members'][i]);
      members.add(user);
    }
    Room room = Room(
      id: json['message']['roomId'],
      name: json['message']['roomName'],
      desc: json['message']['roomDesc'],
      members: members,
      creator: User.fromMakeRoomJson(json['message']['creator']),
    );
    logger.i(room.toString());
    // TODO: fix role of members and creator
    await HiveCacheManager().saveRoom(room);
    final messagesGet = Get.find<MessagesGet>();
    messagesGet.init();

  }

/*// تابع بازتلاش برای اتصال مجدد
  int _retryCount = 0; // شمارنده تلاش‌ها
  final int _maxRetries = 5; // حداکثر تعداد تلاش‌ها
  void _retryConnection() {
    if (_retryCount < _maxRetries) {
      _retryCount++;
      Future.delayed(Duration(seconds: 3), () {
        if (AppInit().socket?.connected == false) {
          logger.i('Retrying connection ($_retryCount/$_maxRetries)...');
          AppInit().socket?.connect();
        }
      });
    } else {
      logger.e('Max retry attempts reached.');
    }
  }*/
}

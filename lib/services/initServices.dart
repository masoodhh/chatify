import 'dart:convert';
import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/init.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/room.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/services/base.dart';
import 'package:http/http.dart' as http;

class InitServices extends BaseService {
  final Uri _url = Uri.parse('${Config.httpServicesBaseUrl}/init');
  final Uri _urlDrop = Uri.parse('${Config.httpServicesBaseUrl}/clear-latest-offline-messages');

/*  String _searchMemberDataInUsers(List<dynamic> json, String userId, bool fullName) {
    final foundItems = json.where((element) => element['userId'] == userId).toList();
    if (foundItems.isNotEmpty) {
      return fullName ? foundItems.first['fullName'] : foundItems.first['userName'];
    } else {
      return '';
    }
  }*/

  Future<void> call(Map<String, dynamic> args) async {
    List<Map<String, dynamic>> latestDates = [];
    final rooms = await HiveCacheManager().getAllRooms();

    for (final room in rooms) {
      final newList = room.messages.where((element) => element.user.id != Config.me!.userId).toList();
      final date = room.messages.isNotEmpty ? (newList.isNotEmpty ? newList.last.date.toString() : '') : null;
      latestDates.add({'roomId': room.id, 'dateTime': date});
    }

    var newArgs = args;
    newArgs['latestDates'] = jsonEncode(latestDates);

    final response = await _postRequest(_url, newArgs);
    final decodedResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<Room> rooms = _processRooms(decodedResponse['data']['rooms']);

      for (final room in rooms) {
        await HiveCacheManager().saveRoom(room);
      }
      logger.w(decodedResponse);
      for (final messageObject in decodedResponse['data']['latestOfflineMessages']) {
        final userJson = messageObject['user'][0];
        final user =
            User(fullname: userJson['fullName'], id: userJson['_id'], username: userJson['userName']);
        logger.w(messageObject['dateTime']);
        logger.w(messageObject);
        await HiveCacheManager().save(Contact(user: user, messages: [
          Message(
              date: DateTime.parse(messageObject['dateTime']), message: messageObject['message'], user: user)
        ]));
      }
      await _dropMessages(args['userId']);
    }
  }

  Future<void> _dropMessages(String userId) async {
    await _postRequest(_urlDrop, {'userId': userId});
  }

  Future<http.Response> _postRequest(Uri url, Map<String, dynamic> body) async {
    final client = http.Client();
    return await client.post(url, body: body, headers: {'Authorization': 'Bearer ${Config.me!.token}'});
  }

  List<Room> _processRooms(List<dynamic> jsonRooms) {
    final List<Room> rooms = [];
  logger.i(jsonRooms);
    for (final room in jsonRooms) {
      final roomObject = Room(
          creator: User.fromJson(room['creatorUser'][0]),
          id: room['_id'],
          name: room['name'],
          members: [
            for (final memberItem in room['members'])
              User(
                fullname: memberItem["fullName"],
                username: memberItem["userName"],
                role: memberItem["role"],
                id: memberItem['userId'],
              )
          ],
          desc: room['desc'] ?? '',
          messages: room['messages'].length > 0
              ? ([
                  for (final messageItem in room['messages'])
                    Message(
                        message: messageItem['message'],
                        date: DateTime.parse(messageItem['dateTime']),
                        user: User.fromJson(messageItem['fromUser'][0]),
                        roomId: room['_id'])
                ])
              : const []);
      rooms.add(roomObject);
      AppInit().socket?.emit('join-room', {'roomId': roomObject.id});
    }

    return rooms;
  }
}

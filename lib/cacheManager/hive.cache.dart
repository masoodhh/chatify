import 'package:chatify/constants/config.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/room.dart';
import 'package:chatify/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

import '../pages/messages/messages.get.dart';
import '../services/addContact.service.dart';

class HiveCacheManager {
  static final HiveCacheManager _singleton = HiveCacheManager._internal();

  factory HiveCacheManager() {
    return _singleton;
  }

  HiveCacheManager._internal();

  Box<Contact>? contactsBox;
  Box<Room>? roomsBox;

  init() async {
    contactsBox = await Hive.openBox<Contact>('contacts');
    roomsBox = await Hive.openBox<Room>('rooms');
  }

  save(Contact contact) async {
    await init();
    if (contactsBox != null && contactsBox!.isOpen) {
      final result = contactsBox!.get(contact.user.id);
      if (result == null) {
        await contactsBox!.put(contact.user.id, contact);
      } else {
        result.messages.addAll(contact.messages);
        await contactsBox!.put(contact.user.id, result);
      }
    }
  }

  saveRoom(Room room) async {
    await init();
    if (roomsBox != null && roomsBox!.isOpen) {
      final result = roomsBox!.get(room.id);
      if (result == null) {
        await roomsBox!.put(room.id, room);
      } else {
        List<User> newMembers = [];
        for (final newMember in room.members) {
          if (result.members.where((element) => element.id == newMember.id).toList().isEmpty) {
            newMembers.add(newMember);
          }
        }
        result.members.addAll(newMembers);
        result.messages.addAll(room.messages);
        await roomsBox!.put(room.id, result);
      }
    }
  }

  update(String userId, Message msg) async {
    await init();
    if (contactsBox != null && contactsBox!.isOpen) {
      final contact = contactsBox!.get(userId);
      // * if sender is me then contact should be existed
      if (contact == null) {
        final service = AddContactService();
        final result = await service.call({'username': msg.user.username});
        if (result != null) {
          final messagesGet = Get.find<MessagesGet>();
          await save(Contact(user: result, messages: [msg]));
          messagesGet.init();
        }
      } else {
        contact!.messages.add(msg);
        await contactsBox!.put(userId, contact);
      }
    }
  }

  updateRoom(String roomId, Message msg) async {
    await init();
    logger.i("update user with message 1");
    if (roomsBox != null && roomsBox!.isOpen) {
      final room = roomsBox!.get(roomId);
      if (room == null) {
        logger.i("update user with message 2");
        //TODO: add new room
      } else {
        logger.i("update user with message 3");
        room!.messages.add(msg);
        await roomsBox!.put(roomId, room);
        logger.i("update user with message 4");
      }
    }
  }

  updateLastSeen(String userId) async {
    await init();
    if (contactsBox != null && contactsBox!.isOpen) {
      final contact = contactsBox!.get(userId);

      if (contact != null && contact.messages.isNotEmpty) {
        for (int i = contact.messages.length - 1; i >= 0; i--) {
          if (contact.messages[i].seen && contact.messages[i].user.id != Config.me!.userId) break;
          contact.messages[i].seen = true;
        }
        await contactsBox!.put(userId, contact);
      }
    }
  }

  updateLastSeenRoom(String roomId) async {
    await init();
    if (roomsBox != null && roomsBox!.isOpen) {
      final room = roomsBox!.get(roomId);
      for (int i = 0; i < room!.messages.length; i++) {
        room.messages[i].seen = true;
      }
      await roomsBox!.put(roomId, room);
    }
  }

  Future<Contact?> get(String userId) async {
    await init();
    if (contactsBox != null && contactsBox!.isOpen) {
      return contactsBox!.get(userId);
    } else {
      return null;
    }
  }

  Future<Room?> getRoom(String roomId) async {
    await init();
    if (roomsBox != null && roomsBox!.isOpen) {
      return roomsBox!.get(roomId);
    } else {
      return null;
    }
  }

  Future<DateTime?> getRoomLastMessageDateTime(String roomId) async {
    await init();
    if (roomsBox != null && roomsBox!.isOpen) {
      return roomsBox!.get(roomId)?.messages.last.date;
    } else {
      return null;
    }
  }

  Future<List<Contact>> getAll() async {
    await init();
    if (contactsBox != null && contactsBox!.isOpen) {
      return contactsBox!.values.toList();
    } else {
      return [];
    }
  }

  Future<List<Room>> getAllRooms() async {
    await init();
    if (roomsBox != null && roomsBox!.isOpen) {
      return roomsBox!.values.toList();
    } else {
      return [];
    }
  }

  clearAll() async {
    await init();
    await contactsBox!.clear();
    await roomsBox!.clear();
    contactsBox = null;
  }
}

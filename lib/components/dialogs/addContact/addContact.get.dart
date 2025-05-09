import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:chatify/services/addContact.service.dart';
import 'package:get/get.dart';

class AddContactGet extends GetxController {
  var username = ''.obs;
  var loading = false.obs;

  void add() async {
    if (username.value.isEmpty) {
      Config.errorHandler(message: 'You have to enter a username!', title: 'Error');
      return;
    }
    if (!loading.value) {
      loading.value = true;
      final service = AddContactService();
      final result = await service.call({'username': username.value});
      loading.value = false;
      if (result != null) {
        final messagesGet = Get.find<MessagesGet>();
        await HiveCacheManager().save(Contact(user: result, messages: []));
        messagesGet.init();

        Get.back();
        Get.toNamed(PageRoutes.chat, arguments: result);
      }
    }
  }
}

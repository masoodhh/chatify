import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/UploadService.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingGet extends GetxController {
  Rx<File> profileAvatar = File('').obs;
  var loading = false.obs;

  Future<void> uploadAvatar() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 60, maxHeight: 300, maxWidth: 300);
    if (pickedFile != null) {
      final uploadService = UploadService();
      final uploadResult = await uploadService.call({'avatar': pickedFile.path, 'userId': Config.me!.userId});
      if (uploadResult) {
        profileAvatar.value = File(pickedFile.path);
        CachedNetworkImage.evictFromCache(Config.showAvatarBaseUrl(Config.me!.userId));

      }
    }
  }

  Future<void> logoutGet() async {
    await UserCacheManager.clear();
    await HiveCacheManager().clearAll();
    Config.me = null;

    Get.offAllNamed(PageRoutes.welcome);
  }
}

import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:get/get.dart';

class SettingGet extends GetxController {
  var loading = false.obs;

  Future<void> logoutGet() async {
    await UserCacheManager.clear();
    await HiveCacheManager().clearAll();
    Config.me = null;

    Get.offAllNamed(PageRoutes.welcome);
  }
}

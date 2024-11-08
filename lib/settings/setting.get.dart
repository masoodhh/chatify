import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:get/get.dart';

class SettingGet extends GetxController {
  var loading = false.obs;

  Future<void> logoutGet() async {
    await UserCacheManager.clear();
    Config.me = null;

    Get.offAllNamed(PageRoutes.welcome);
  }
}

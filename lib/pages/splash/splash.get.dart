import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/init.dart';
import 'package:chatify/services/checkConnection.service.dart';
import 'package:chatify/services/initServices.dart';
import 'package:chatify/services/tokenFresher.service.dart';
import 'package:get/get.dart';

class SplashGet extends GetxController {
  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() async {
    await UserCacheManager.checkLogin();
    if (UserCacheManager.isUserLoggedIn) {
      Config.me = UserCacheManager.getUserData();
      // Refresh Token

      final checkConnectionService =  CheckConnectionService();
      final isConnected = await checkConnectionService.call({});
      if (!isConnected) {
        Get.offAllNamed(PageRoutes.messages);
      }
      final service = TokenFresherService();
      await service.call({'userId': Config.me!.userId, 'userName': Config.me!.username});
      // Init Socket & HiveCache Manager
      AppInit().initSocketClient();
      await HiveCacheManager().init();

      // Get latest offline messages
      final offlineMsgServices = InitServices();
      await offlineMsgServices.call({'userId': Config.me!.userId});

      // Route user to messages list
      // Get.offAllNamed(PageRoutes.test);
      Get.offAllNamed(PageRoutes.messages);
    } else {
      Get.offAllNamed(PageRoutes.welcome);
    }
  }
}

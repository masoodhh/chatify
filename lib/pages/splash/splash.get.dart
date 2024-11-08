import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/init.dart';
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
      final service = TokenFresherService();
      await service.call({'userId': Config.me!.userId, 'userName': Config.me!.username});
     logger.i("splash token fresher checked");
      // Init Socket & HiveCache Manager
      AppInit().initSocketClient();
      // await HiveCacheManager().init();
      logger.i("splash token fresher checked 2");

      // Get latest offline messages
      // final offlineMsgServices = InitServices();
      // await offlineMsgServices.call({'userId': Config.me!.userId});

      // Route user to messages list
      Get.offAllNamed(PageRoutes.messages);
    } else {
      Get.offAllNamed(PageRoutes.welcome);
    }
  }
}

/*
void _init() async {
  logger.w("splash 1");
  await UserCacheManager.checkLogin();
  logger.w("splash 2");
  if (UserCacheManager.isUserLoggedIn) {
    logger.w("splash 3");
    Config.me = UserCacheManager.getUserData();
    AppInit().initSocketClient();
    Get.offAllNamed(PageRoutes.messages);
  } else {
    logger.w("splash 4");
    Get.offAllNamed(PageRoutes.welcome);
  }
  logger.w("splash 5");
}
*/

import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/login.service.dart';
import 'package:get/get.dart';

class LoginGet extends GetxController {
  var userName = ''.obs;
  var password = ''.obs;
  var loading = false.obs;

  void loginToAccountGet() async {
    if (!loading.value) {
      loading.value = true;
      if (userName.value.isEmpty || password.value.isEmpty) {
        Config.errorHandler(title: "Error", message: "All fields are required.");
        return;
      }
      try {
        LoginService loginService = LoginService();
        final result = await loginService.call({"userName": userName.value, "password": password.value});
        if (result) {
          Get.offAllNamed(PageRoutes.splash);
        }
      } catch (error) {
        Config.errorHandler(title: "Error", message: error.toString());
        logger.e(error);
      }

      loading.value = false;
    }
  }
}

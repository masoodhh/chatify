import 'package:chatify/constants/config.dart';
import 'package:chatify/services/register.service.dart';
import 'package:get/get.dart';

import '../../cacheManager/user.cache.dart';

class RegisterGet extends GetxController {
  var fullName = ''.obs;
  var userName = ''.obs;
  var password = ''.obs;
  var loading = false.obs;

  void createAccount() async {

    if (!loading.value) {
      loading.value = true;
      if (fullName.value.isEmpty || userName.value.isEmpty || password.value.isEmpty) {
        Config.errorHandler(title: "Error", message: "All fields are required.");
        return;
      }
      try {
        RegisterService registerService = RegisterService();
        final result = await registerService
            .call({"fullName": fullName.value, "userName": userName.value, "password": password.value});
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

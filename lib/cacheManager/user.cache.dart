import 'package:chatify/models/me.dart';
import 'package:get_storage/get_storage.dart';

class UserCacheManager {
  UserCacheManager._();

  static bool isUserLoggedIn = false;

  static const String USER_ID_KEY = '--user-id-key';
  static const String USER_NAME_KEY = '--user-name-key';
  static const String USER_FULLNAME_KEY = '--user-fullname-key';
  static const String USER_TOKEN_KEY = '--user-token-key';

  static Me getUserData() {
    final box = GetStorage();
    return Me(
      fullname: box.read(USER_FULLNAME_KEY) ?? '',
      token: box.read(USER_TOKEN_KEY),
      userId: box.read(USER_ID_KEY),
      username: box.read(USER_NAME_KEY),
    );
  }

  static Future<void> save({String? userId, String? fullname, String? username, String? token}) async {
    final box = GetStorage();
    if (userId != null) await box.write(USER_ID_KEY, userId);
    if (fullname != null) await box.write(USER_FULLNAME_KEY, fullname);
    if (username != null) await box.write(USER_NAME_KEY, username);
    if (token != null) await box.write(USER_TOKEN_KEY, token);
  }

  static Future<void> clear() async {
    final box = GetStorage();
    await box.erase();
  }

  static Future<void> checkLogin() async {
    final box = GetStorage();
    final userId = await box.read(USER_ID_KEY);
    UserCacheManager.isUserLoggedIn = userId != null;
  }
}

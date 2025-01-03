import 'dart:convert';

import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/base.service.dart';
import 'package:http/http.dart' as http;

class LoginService extends BaseService {
  @override
  Future<bool> call(Map<String, dynamic> args) async {
    logger.i("LoginService 1");
    final client = http.Client();
    final url = Uri.parse('${Config.httpServicesBaseUrl}/signin');
    final response = await client.post(url, body: args);
    final decodedResponse = jsonDecode(response.body);

    logger.i("LoginService 2");
    if (response.statusCode == 200) {
      logger.i("LoginService 3");
      Config.errorHandler(title: decodedResponse["error_code"], message: decodedResponse["message"]);
      logger.i("LoginService 4");
      await UserCacheManager.save(
        userId: decodedResponse["data"]["_id"],
        fullname: decodedResponse["data"]["fullName"],
        username: decodedResponse["data"]["userName"],
        token: decodedResponse["data"]["token"],
      );
      logger.i("LoginService 5");
      return true;
    } else {
      logger.e(decodedResponse["error_code"]);
      Config.errorHandler(title: decodedResponse["error_code"], message: decodedResponse["message"]);
      return false;
    }
  }
}

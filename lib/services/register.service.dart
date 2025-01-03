import 'dart:convert';

import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/base.service.dart';
import 'package:http/http.dart' as http;

class RegisterService extends BaseService {
  @override
  Future<bool> call(Map<String, dynamic> args) async {
    final client = http.Client();
    final url = Uri.parse('${Config.httpServicesBaseUrl}/register');
    final response = await client.post(url, body: args);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Config.errorHandler(title: decodedResponse["error_code"], message: decodedResponse["message"]);
      await UserCacheManager.save(
        userId: decodedResponse["data"]["_id"],
        fullname: decodedResponse["data"]["fullName"],
        username: decodedResponse["data"]["userName"],
        token: decodedResponse["data"]["token"],
      );
      return true;
    } else {
      logger.e(decodedResponse["error_code"]);
      Config.errorHandler(title: decodedResponse["error_code"], message: decodedResponse["message"]);
      return false;
    }
  }
}

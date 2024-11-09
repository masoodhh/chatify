import 'dart:convert';

import 'package:chatify/constants/config.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/services/base.dart';
import 'package:http/http.dart' as http;

class AddContactService extends BaseService {
  // final Uri url = Uri.parse('${Config.httpsServicesBaseUrl}/new-contact');
  final Uri url = Uri.parse('${Config.httpServicesBaseUrl}/new-contact');
  Future<User?> call(Map<String, dynamic> args) async {
    logger.w("add-contact-service");
    final client = http.Client();
    logger.w("add-contact-service11");
    final response = await client.post(url,
        body: args, headers: {'Authorization': 'Bearer ${Config.me!.token}'});
    logger.w("add-contact-service22");
    final decodedResponse = jsonDecode(response.body);
    logger.w("add-contact-service2");
    if (response.statusCode == 200) {
      logger.w("add-contact-service3");
      return User.fromJson(decodedResponse['data']);
    } else {
      logger.w("add-contact-service4");
      Config.errorHandler(
          title: decodedResponse['error_code'],
          message: decodedResponse['message']);
      return null;
    }
  }
}
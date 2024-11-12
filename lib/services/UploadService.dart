import 'dart:convert';

import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/services/base.dart';
import 'package:http/http.dart' as http;

class UploadService extends BaseService {
  // final Uri url = Uri.parse('${Config.httpsServicesBaseUrl}/get-latest-offline-messages');
  final Uri url = Uri.parse('${Config.httpServicesBaseUrl}/upload-avatar');

  Future<bool> call(Map<String, dynamic> args) async {
    //todo
    try {
      logger.i(url);
      logger.i("UploadService start");
      final req = http.MultipartRequest('put', url)
        ..headers['Content-Type'] = 'multipart/form-data'
        ..headers['userid'] = args['userId']
        ..headers['Authorization'] = 'Bearer ${Config.me!.token}';

      req.files
          .add(await http.MultipartFile.fromPath('avatar', args['avatar']));
      logger.i("UploadService start 2");
      final response = await http.Response.fromStream(await req.send());
      logger.i("UploadService start 3");

      // req.files.add(await http.MultipartFile.fromPath('avatar', args['avatar']));

      // final response = await http.Response.fromStream(await req.send());

      final decodedResponse = jsonDecode(response.body);
      logger.i("UploadService start2");
      if (response.statusCode == 200) {
        return true;
      } else {
        Config.errorHandler(title: decodedResponse['error_code'], message: decodedResponse['message']);
        return false;
      }
    } catch (er) {
      logger.e(er);
      Config.errorHandler(title: 'Upload Error', message: er.toString());
      return false;
    }
  }

  Future<void> _dropMessages(Map<String, dynamic> args) async {
    try {
      final Uri url = Uri.parse('${Config.httpServicesBaseUrl}/clear-latest-offline-messages');
      final client = http.Client();
      final response =
          await client.post(url, body: args, headers: {'Authorization': 'Bearer ${Config.me!.token}'});
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
      } else {
        Config.errorHandler(title: decodedResponse['error_code'], message: decodedResponse['message']);
      }
    } catch (er) {
      logger.e(er);
    }
  }
}

import 'dart:convert';
import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/base.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectionService implements BaseService {
  final Uri url = Uri.parse('${Config.httpServicesBaseUrl}/test');

  @override
  Future<bool> call(Map<String, dynamic> args) async {
    try {
      // بررسی وضعیت اتصال اینترنت
      bool isConnected = await _checkInternetConnection();
      if (!isConnected) {
        logger.e('No internet connection');
        Config.errorHandler(title: "ٍerror", message: "No internet connection");
        return false;
      }

      // اتصال به سرور
      final client = http.Client();
      final response = await client.get(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        Config.errorHandler(title: "ٍerror", message: "Failed to connect to server");
        return false;
      }
    } catch (er) {
      logger.e('Error: $er');
      return false;
    }
  }

  /// بررسی وضعیت اتصال اینترنت
  Future<bool> _checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return true;
    } catch (e) {
      logger.e('Error checking internet connection: $e');
      return false;
    }
  }
}

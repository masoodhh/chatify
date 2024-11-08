import 'package:chatify/constants/config.dart';
import 'package:http/http.dart' as http;

abstract class BaseService {
  Future<dynamic> call(Map<String, dynamic> args) async {}


}

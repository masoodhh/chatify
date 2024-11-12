import 'package:chatify/constants/text_styles.dart';
import 'package:chatify/models/me.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';


Logger logger = Logger(
  printer: PrettyPrinter(
    // methodCount: 0, // تعداد خطوط stack trace. صفر برای عدم نمایش.
    errorMethodCount: 0, // تعداد خطوط stack trace برای خطاها.
    lineLength: 100, // طول هر خط لاگ
    // colors: false, // غیرفعال‌سازی رنگ‌ها
    printEmojis: false, // نمایش یا عدم نمایش ایموجی‌ها
    printTime: true, // نمایش زمان
  ),
);

class Config {
  Config._();

  // mirror mobile
  static const baseUrl = "10.0.2.2";

  //physical mobile
  // static const baseUrl = "192.168.1.108";

  static const httpServicesBaseUrl = 'http://$baseUrl:8888';
  static const httpsServicesBaseUrl = 'https://$baseUrl:8888';
  static const socketServerBaseUrl = 'http://$baseUrl:8888';

  static String showAvatarBaseUrl(String userId) => '${Config.httpServicesBaseUrl}/avatar/$userId';

  static String showRoomAvatarBaseUrl(String roomId) => '${Config.httpServicesBaseUrl}/room-avatar/$roomId';
  static ThemeData primaryThemeData = ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'Nexa',
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8)),
          focusColor: Colors.black,
          iconColor: Colors.grey,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      appBarTheme: const AppBarTheme(
          toolbarHeight: 69,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black, size: 24),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: MyTextStyles.appbar));

  static Me? me;

  static void errorHandler({String title = '', String message = ''}) {
    Get.snackbar(title, message,
        backgroundColor: Colors.grey.shade200, colorText: Colors.black, duration: const Duration(seconds: 4));
  }
}

class PageRoutes {
  PageRoutes._();

  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String messages = '/messages';
  static const String settings = '/settings';
  static const String splash = '/splash';
  static const String chat = '/chat';

  static const String test = '/test';

  static const String roomProperties = '/room-properties';
  static const String contactProperties = '/contact-properties';
}

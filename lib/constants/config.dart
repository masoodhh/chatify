import 'package:chatify/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:chatify/models/me.dart';

Logger logger = Logger();

class Config {
  Config._();

  static Me? me;


  static const httpServicesBaseUrl = 'http://10.0.2.2:8888';
  static const httpsServicesBaseUrl = 'https://10.0.2.2:8888';
  static const socketServerBaseUrl = 'http://10.0.2.2:8888';

  static void errorHandler({required String title, required String message}) =>
      Get.snackbar(title, message, backgroundColor: Colors.grey.shade200, colorText: Colors.black,duration: const Duration(seconds: 4));
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
}

class PageRoutes {
  PageRoutes._();

  static const splash = '/splash';
  static const welcome = '/welcome';
  static const setting = '/setting';
  static const signIn = '/sign-in';
  static const register = '/register';
  static const messages = '/messages';
  static const chat = '/chat';
}

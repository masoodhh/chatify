import 'package:chatify/constants/config.dart';
import 'package:chatify/models/contact.dart';
import 'package:chatify/models/message.dart';
import 'package:chatify/models/room.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/chat/view.dart';
import 'package:chatify/pages/login/view.dart';
import 'package:chatify/pages/messages/view.dart';
import 'package:chatify/pages/properties/view.contact.dart';
import 'package:chatify/pages/properties/view.room.dart';
import 'package:chatify/pages/register/view.dart';
import 'package:chatify/pages/splash/view.dart';
import 'package:chatify/pages/welcome/view.dart';
import 'package:chatify/settings/view.dart';
import 'package:chatify/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await GetStorage.init();

  // * Hive init and adapters
  Hive.initFlutter();
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RoomAdapter());
  Hive.registerAdapter(MessageAdapter());

  // * run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Config.primaryThemeData,
      initialRoute: PageRoutes.splash,
      // initialRoute: PageRoutes.test,
      getPages: [
        GetPage(name: PageRoutes.splash, page: () => Splash()),
        GetPage(name: PageRoutes.welcome, page: () => const Welcome()),
        GetPage(name: PageRoutes.signIn, page: () => Login()),
        GetPage(name: PageRoutes.register, page: () => Register()),
        GetPage(name: PageRoutes.messages, page: () => Messages()),
        GetPage(name: PageRoutes.settings, page: () => Setting()),
        GetPage(name: PageRoutes.test, page: () => Test()),
        GetPage(name: PageRoutes.chat, page: () => Chat()),
        GetPage(name: PageRoutes.roomProperties, page: () => RoomProperties()),
        GetPage(name: PageRoutes.contactProperties, page: () => ContactProperties()),
      ],
    );
  }
}

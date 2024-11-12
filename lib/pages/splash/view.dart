import 'package:chatify/pages/splash/splash.get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);
  final SpkashGet = Get.put(SplashGet());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Container(
            child: Container(
                width: 200,
                height: 150,
                color: Colors.amber,
                child: Center(
                  child: Text("Splash screen"),
                ))),
      ),
    );
  }
}

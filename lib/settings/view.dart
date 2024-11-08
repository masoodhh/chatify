import 'package:chatify/constants/config.dart';
import 'package:chatify/constants/text_styles.dart';
import 'package:chatify/settings/setting.get.dart';
import 'package:chatify/settings/setting_item.widget.get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  Setting({super.key});

  final settingGet = SettingGet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 50),
                  child: Text(Config.me!.fullname, style: MyTextStyles.header)),
              const SettingItemWidget(
                title: "Privecy Policy",
              ),
              SettingItemWidget(
                title: "Sign Out",
                isInRed: true,
                prefixIcon: Icons.exit_to_app_outlined,
                onTapped: settingGet.logoutGet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

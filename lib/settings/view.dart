import 'package:cached_network_image/cached_network_image.dart';
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
                  padding: const EdgeInsets.only(top: 30, bottom: 15),
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: settingGet.uploadAvatar,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                    child: Obx(() =>
                        (settingGet.profileAvatar.value != null && settingGet.profileAvatar.value.path != '')
                            ? ClipRRect(
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    radius: 80,
                                    backgroundImage: FileImage(settingGet.profileAvatar.value!)),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 160,
                                    imageUrl: Config.showAvatarBaseUrl(Config.me!.userId),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      color: Colors.grey.shade400,
                                      size: 50,
                                    ),
                                  ),
                                ))),
                  )),
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

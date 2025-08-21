
import 'package:flutter/material.dart';
import 'package:administra/app/views/adm_chat/adm_message_screen.dart';

import 'package:administra/app/views/adm_chat/adm_video_call.dart';

import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';

class AdmShareScreen extends StatefulWidget {
  const AdmShareScreen({
    super.key,
  });

  @override
  State<AdmShareScreen> createState() => _AdmShareScreenState();
}

class _AdmShareScreenState extends State<AdmShareScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                videoCallCat,
              )),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 23),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: whiteColor,
                  size: 28,
                ),
              ),
            ),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administra...',
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: admWhiteColor,
                          overflow: TextOverflow.fade),
                    ),
                    Text(
                      time,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: admWhiteColor,
                      ),
                    ),
                    17.height
                  ],
                ),
                24.width,
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(MyRoute.shareScreen);
                    },
                    child: Image.asset(
                      man,
                      height: 170,
                      width: 115,
                    ),
                  ),
                )
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCallView(speaker, () {}, whiteColor.withOpacity(0.2)),
                buildCallView(videoImg, () {}, whiteColor.withOpacity(0.2)),
                buildCallView(voice, () {}, whiteColor.withOpacity(0.2)),
                buildCallView(declinedCall, () {
                  Get.to(const AdmMessageScreen());
                }, admLightRed),
              ],
            ),
            25.height,
          ],
        ),
      ),
    );
  }


}



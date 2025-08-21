
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:administra/app/views/adm_chat/adm_video_call.dart';
import 'package:administra/constant/adm_strings.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import 'package:get/get.dart';

import '../../../adm_theme/adm_theme.dart';

class AdmVoiceCallScreen extends StatefulWidget {
  const AdmVoiceCallScreen({
    super.key,
  });

  @override
  State<AdmVoiceCallScreen> createState() => _AdmVoiceCallScreenState();
}

class _AdmVoiceCallScreenState extends State<AdmVoiceCallScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness:Brightness.light, // Change to Brightness.dark for dark icons
      ),
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(videoBackground),
            fit: BoxFit.cover,
          )),

          //You can use any widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
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
            ),
              const Spacer(),
              Image.asset(animal,height: 200,width: 200,),
              20.height,
              Text(
                animalRescue,
                style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: admWhiteColor,

                ),
                textAlign: TextAlign.center,
              ),
              20.height,
              Text(
                time,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: admWhiteColor,

                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCallView(speaker, () {}, whiteColor.withOpacity(0.2)),

                  buildCallView(voice, () {}, whiteColor.withOpacity(0.2)),
                  buildCallView(declinedCall, () {
                    Get.back();
                  }, admLightRed),
                ],
              ),
              23.height,



            ],
          ),
        ),

      ),
    );
  }
}

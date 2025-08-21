
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:administra/constant/adm_colors.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';

class AdmVideoCallScreen extends StatefulWidget {
  const AdmVideoCallScreen({
    super.key,
  });

  @override
  State<AdmVideoCallScreen> createState() => _AdmVideoCallScreenState();
}

class _AdmVideoCallScreenState extends State<AdmVideoCallScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }
bool isShow=false;
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
          decoration:  BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  isShow?videoCallCat:videoCallGirl,
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
                        'John Doe...',
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
                        setState(() {
                         // isShow!=isShow;
                          isShow = !isShow;
                        });
                        //Get.toNamed(MyRoute.shareScreen);
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

                    Get.back();
                  }, admLightRed),
                ],
              ),
              25.height,




            ],
          ),
        ),
      ),
    );
  }


}


Widget buildCallView(
    String image, void Function()? onPressed, Color? backgroundColor) {
  return Row(
    children: [
      InkWell(
        onTap:onPressed,
        child: CircleAvatar(
          radius: 35,
          backgroundColor: backgroundColor,
          child: Center(
              child: Image.asset(
                image,
                height: 21,
                width: 21,
              )),
        ),
      ),
      13.width
    ],
  );
}
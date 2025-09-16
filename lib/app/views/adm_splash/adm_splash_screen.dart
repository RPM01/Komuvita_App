import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/constant/adm_images.dart';
import 'package:administra/constant/adm_strings.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../controller/adm_splash_screen_controller.dart';

class AdmSplashScreen extends StatefulWidget {
  const AdmSplashScreen({super.key});

  @override
  State<AdmSplashScreen> createState() => _AdmSplashScreenState();
}

class _AdmSplashScreenState extends State<AdmSplashScreen> {
  final SplashScreenController splashScreenController =
      Get.put(SplashScreenController());
  @override
  void initState() {
    super.initState();
    // Set the status bar to light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Set to Brightness.light for white icons
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GetBuilder<SplashScreenController>(
        init: splashScreenController,
        tag: 'adm_splash',
        // theme: theme,
        builder: (controller) {
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: admColorPrimary,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Center(
                    child: CircularProgressIndicator(

                      //backgroundColor: admWhiteColor,
                      valueColor:
                          AlwaysStoppedAnimation(admWhiteColor.withOpacity(0.7)),
                      strokeWidth: 8,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        splashImg,
                        height: MediaQuery.of(context).size.width*0.5,
                        width: MediaQuery.of(context).size.width*0.5,
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

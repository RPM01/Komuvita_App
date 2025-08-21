import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/constant/adm_images.dart';
import 'package:administra/constant/adm_strings.dart';
import 'package:administra/adm_theme/theme_controller.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../adm_theme/adm_theme.dart';
//import '../../../widgets/common_button.dart';
import '../adm_privacy_policy/adm_privacy_policy_screen.dart';
import '../adm_terms_service/adm_terms_service_screen.dart';

class AdmWelcomeScreen extends StatefulWidget {
  const AdmWelcomeScreen({super.key});

  @override
  State<AdmWelcomeScreen> createState() => _AdmWelcomeScreenState();
}

class _AdmWelcomeScreenState extends State<AdmWelcomeScreen> {
  late ThemeData theme;
  final ThemeController themeController = Get.put(ThemeController());
  @override
  void initState() {
    super.initState();
    theme = themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            color: themeController.isDarkMode ? admWhiteColor : admTextColor,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                30.height,
                SvgPicture.asset(
                  splashImg,
                  colorFilter:
                      const ColorFilter.mode(admColorPrimary, BlendMode.srcIn),
                  height: 57,
                  width: 66,
                  fit: BoxFit.cover,
                ),
                50.height,
                Text(
                  getWelcomeStarted,
                  style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: themeController.isDarkMode
                          ? admWhiteColor
                          : admTextColor),
                ),
                18.height,
                Text(
                  accountDes,
                  style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode
                          ? greyColor
                          : admGreyTextColor),
                ),
                40.height,
                //const CustomButton(
                //  text: google,
                //  image: googleImg,
                //),
                //15.height,
                //CustomButton(
                //  text: apple,
                //  image: appleImg,
                //  color: Get.isDarkMode ? admWhiteColor : admBlackColor,
                //),
                //15.height,
                //const CustomButton(
                //  text: facebook,
                //  image: facebookImg,
                //),
                //15.height,
                // const CustomButton(
                //   text: twitter,
                //   image: twitterImg,
                // ),

                InkWell(
                  onTap: () {
                    Get.toNamed(MyRoute.registerScreen);
                  },
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                        color: admColorPrimary,
                        borderRadius: BorderRadius.circular(50)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        signUp,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700, color: admWhiteColor),
                      ),
                    ),
                  ),
                ),
                15.height,
                InkWell(
                  onTap: () {
                    Get.toNamed(MyRoute.loginScreen);
                  },
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? admDarkLightColor
                            : lightPrimaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        signIn,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Get.isDarkMode
                                ? admWhiteColor
                                : admColorPrimary),
                      ),
                    ),
                  ),
                ),
                30.height,
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            const AdmPrivacyPolicyScreen(),
                          );
                        },
                        child: Text(
                          privacyPolicy,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      15.width,
                      CircleAvatar(
                        radius: 2,
                        backgroundColor:
                            Get.isDarkMode ? greyColor : admGreyTextColor,
                      ),
                      15.width,
                      InkWell(
                        onTap: () {
                          Get.to(const AdmTermsAndServiceScreen());
                        },
                        child: Text(
                          termsOfUse,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:administra/constant/adm_colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:administra/adm_theme/theme_controller.dart';

import 'package:get/get.dart';

import '../constant/adm_images.dart';

Widget commonRowText(
  String leading,
  String trailing,
  ThemeData theme,
    void Function()? onTap
) {
  final ThemeController themeController = Get.put(ThemeController());
  return Row(
    children: [
      Expanded(
        child: Text(
          leading,
          style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: themeController.isDarkMode ? admWhiteColor : admTextColor),
        ),
      ),
      InkWell(
        onTap:onTap,
        child: Row(
          children: [
            Text(
              trailing,
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: admColorPrimary),
            ),
            10.width,
            const Icon(
              Icons.arrow_forward,
              color: admColorPrimary,
            ),
          ],
        ),
      )
    ],
  );
}

void customMsgBox(String msg,ThemeData theme,BuildContext context){
  final ThemeController themeController = Get.put(ThemeController());
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1),
                () => Get.back());
        return AlertDialog(


          backgroundColor: themeController.isDarkMode
              ? admDarkBorderColor
              : lightGreyColor,
          insetPadding:
          const EdgeInsets.only(bottom: 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.bottomCenter,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(checkMark),
              7.width,
              Text(
                msg,
                style: theme.textTheme.titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:themeController.isDarkMode?admWhiteColor:admTextColor
                ),
              ),
            ],
          ),
        );
      });

}
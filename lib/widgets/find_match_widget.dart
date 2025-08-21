import 'package:flutter/material.dart';

import '../constant/adm_colors.dart';
import '../constant/adm_strings.dart';
import 'common_button.dart';
import 'package:get/get.dart';

Widget buildCommonButtons(String text, ThemeData theme, int index,
    int selectedButtonIndex, void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: index == selectedButtonIndex
                  ? admColorPrimary
                  : Get.isDarkMode
                      ? darkGreyColor
                      : greyColor,
              width: 1)),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

AppBar appbarWithProgressIndicator(String text, ThemeData theme, double value) {
  return AppBar(
    backgroundColor: theme.scaffoldBackgroundColor,
    centerTitle: true,
    leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          color: Get.isDarkMode ? admWhiteColor : admTextColor,
        )),
    title: LinearProgressIndicator(
      backgroundColor: greyColor,
      color: admColorPrimary,
      minHeight: 12,
      value: value,
      borderRadius: BorderRadius.circular(50),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              text,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget buildContinueButton(dynamic Function()? onTap) {
  return PrimaryButton(text: continueText, onTap: onTap);
}

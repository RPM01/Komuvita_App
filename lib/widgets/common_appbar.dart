
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import '../constant/adm_colors.dart';



AppBar commonAppBar(
    {String? text,
       required String image,
      void Function()? onTap,
      required BuildContext context,
      required ThemeData theme,

      }) {
  final ThemeController themeController = Get.put(ThemeController());

  return AppBar(
    centerTitle: true,
    backgroundColor:themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
    automaticallyImplyLeading: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
    ),
    title: Text(
      text.toString(),
      style: theme.
          textTheme
          .headlineSmall
          ?.copyWith(fontWeight: FontWeight.w700, color: themeController.isDarkMode?admWhiteColor:admTextColor ),
    ),
    actions: [

      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: image.isEmpty?Container():
        SvgPicture.asset(image.toString(),height: 24,width: 24,
          colorFilter: ColorFilter.mode(
            themeController.isDarkMode?admWhiteColor:admTextColor, BlendMode.srcIn),),
      )
    ],

  );
}




AppBar customAppBar(

    {String? text,
      required String image,
     required String leading,
      required  String trailing,

      void Function()? onTap,
      required BuildContext context,
      required ThemeData theme,
      Color? color

    }) {
  final ThemeController themeController = Get.put(ThemeController());
  return AppBar(
    backgroundColor: color,

    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.all(15),
      child: SvgPicture.asset(
        image,

        colorFilter: const ColorFilter.mode(admColorPrimary, BlendMode.srcIn),
        height: 28,
        width: 29,
        //fit: BoxFit.cover,
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        text.toString(),
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: themeController.isDarkMode?admWhiteColor:admTextColor

        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon:leading.isEmpty?Container():
                SvgPicture.asset(
                  leading,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      themeController.isDarkMode?admWhiteColor:admTextColor, BlendMode.srcIn),
                )),
            10.width,
            IconButton(
                onPressed: () {},
                icon: trailing.isEmpty?Container():SvgPicture.asset(
                  trailing,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      themeController.isDarkMode?admWhiteColor:admTextColor, BlendMode.srcIn),
                ))
          ],
        ),
      )
    ],
  );
}

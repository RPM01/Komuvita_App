import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import '../app/modal/adms_home_modal.dart';
import '../constant/adm_colors.dart';
import '../constant/adm_images.dart';
import 'package:get/get.dart';

import 'common_progress.dart';


class AdmDetailView extends StatelessWidget {
  final ThemeData theme;
  final AdmsModal detail;
 final  void Function()? onPressed;
  AdmDetailView(
      {super.key,
      required this.theme,
      required this.detail,
      required this.onPressed});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: commonCacheAdmImageWidget(detail.image[0], 140, width: 140),
            ),

            Positioned(
              right: 5,
              top: 7,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: admColorPrimary,
                    borderRadius: BorderRadius.circular(30)),
                child: Obx(
                  () => IconButton(
                      onPressed: onPressed,
                      icon: detail.isFavorite.value
                          ? SvgPicture.asset(like)
                          : SvgPicture.asset(unlike)),
                ),
              ),
            ),
          ],
        ),
        10.height,
        Text(
          detail.name,
          style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode ? admWhiteColor : admTextColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              map,
              height: 12,
              width: 12,
            ),
            7.width,
            Text(detail.distance,
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: themeController.isDarkMode
                        ? greyColor
                        : admGreyTextColor)),
            7.width,
            CircleAvatar(
              radius: 1.3,
              backgroundColor:
                  themeController.isDarkMode ? greyColor : admGreyTextColor,
            ),
            7.width,
            Text(detail.category,
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: themeController.isDarkMode
                        ? greyColor
                        : admGreyTextColor)),
          ],
        )
      ],
    );
  }
}

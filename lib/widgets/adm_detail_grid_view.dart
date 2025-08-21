import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import '../app/modal/adms_home_modal.dart';
import '../constant/adm_colors.dart';
import '../constant/adm_images.dart';
import 'package:get/get.dart';

import 'common_progress.dart';

Widget admDetailGridView(ThemeData theme, AdmsModal detail, void Function()? onPressed, BuildContext context, String image) {
  final ThemeController themeController = Get.put(ThemeController());
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: commonCacheAdmImageWidget(
              detail.image[0],
              MediaQuery.sizeOf(context).height * 0.23,
              width: double.infinity,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: admColorPrimary,
                  borderRadius: BorderRadius.circular(30)),
              child:
              // show == true
              //     ? Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: SvgPicture.asset(
              //           like,
              //         ),
              //       )
              //     :
               IconButton(
                    onPressed: onPressed,
                    icon: SvgPicture.asset(image)
                        // ? SvgPicture.asset(unlike)
                        // : SvgPicture.asset(like)),

              // Obx(
              //         () => IconButton(
              //             onPressed: onPressed,
              //             icon: detail.isFavorite.value
              //                 ? SvgPicture.asset(unlike)
              //                 : SvgPicture.asset(like)),
                    ),

                        ),
          )
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
          Expanded(
            child: Text(detail.category,
                style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: themeController.isDarkMode
                        ? greyColor
                        : admGreyTextColor,
                  fontSize: 11

                ),
              maxLines: 1,

            ),
          ),
        ],
      )
    ],
  );
}

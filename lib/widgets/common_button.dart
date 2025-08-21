import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant/adm_images.dart';
import '../constant/adm_strings.dart';
import '../adm_theme/adm_theme.dart';

class CustomButton extends StatefulWidget {
  final String? image;
  final String? text;
  final Function()? onTap;
  final Color? color;

  const CustomButton(
      {super.key, this.text, this.onTap, this.image, this.color});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
          border:
              Border.all(color: Get.isDarkMode ? admDarkLightColor : greyColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.image.toString(),
                colorFilter: widget.color != null
                    ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                    : null, // Pass null if widget.color is null
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.text.toString(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Get.isDarkMode ? admWhiteColor : admTextColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String? text;
  final Function()? onTap;
  final Color? color;

  const PrimaryButton({
    super.key,
    this.text,
    this.onTap,
    this.color,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 120,
      padding: EdgeInsets.only(

          bottom: GetPlatform.isIOS
              ? MediaQuery.of(context).padding.bottom
              : 20),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? admDarkPrimary : admWhiteColor,
          ),
      child: Column(
        children: [
          Divider(
              color: Get.isDarkMode
                  ? admDarkLightColor
                  : admLightGrey),
          12.height,

          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                height: 58,

                decoration: BoxDecoration(
                    color: admColorPrimary,
                    borderRadius: BorderRadius.circular(50)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.text.toString(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: admWhiteColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget twitterButton(ThemeData theme){
  return  InkWell(
    splashColor: Colors.transparent,
    onTap: () {

    },
    child: Container(
      height: 58,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
        border:
        Border.all(color: Get.isDarkMode ? admDarkLightColor : greyColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(twitterImg),
            ),
            // Image.asset(
            //   twitterImg,
            //   height: 25,
            //   width: 25,
            //
            // ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  twitter,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Get.isDarkMode ? admWhiteColor : admTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
class MyButton extends StatefulWidget {
  final String? text;
  final Function()? onTap;
  final Color? color;

  const MyButton({
    super.key,
    this.text,
    this.onTap,
    this.color,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 120,
      padding: EdgeInsets.only(
          bottom: GetPlatform.isIOS
              ? MediaQuery.of(context).padding.bottom
              : 20),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? admDarkPrimary : admWhiteColor,
          // border: Border.all(
          //     color: Get.isDarkMode ? admDarkLightColor : admLightGrey)
      ),
      child: Column(
        children: [
          Divider(
              color: Get.isDarkMode
                  ? admDarkLightColor
                  : admLightGrey),
          12.height,
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                    color: widget.color, borderRadius: BorderRadius.circular(50)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.text.toString(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: admWhiteColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

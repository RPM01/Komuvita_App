import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import 'package:get/get.dart';
import '../../controller/adm_menu_controller.dart';

class AdmMenu extends StatefulWidget {
  const AdmMenu({super.key});

  @override
  State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmMenuState extends State<AdmMenu> {
  late ThemeData theme;
  AdmMenuController controller = Get.put(AdmMenuController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.themeController.isDarkMode
          ? admDarkPrimary
          : admWhiteColor,
      appBar: menuAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
              itemCount: controller.helpAndSupport.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 23),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        index < 20 ? Get.to(controller.screens[index]) : null;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.helpAndSupport[index],
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: controller.themeController.isDarkMode
                                  ? admWhiteColor
                                  : admDarkPrimary),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: controller.themeController.isDarkMode
                              ? admWhiteColor
                              : admDarkPrimary,
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  AppBar menuAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: controller.themeController.isDarkMode
          ? admDarkPrimary
          : admWhiteColor,
      leading: Padding(
        padding: const EdgeInsets.all(15),
        child: SvgPicture.asset(
          splashImg,
          colorFilter: const ColorFilter.mode(admColorPrimary, BlendMode.srcIn),
          height: 28,
          width: 29,
          //fit: BoxFit.cover,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          menu,
          style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: controller.themeController.isDarkMode
                  ? admWhiteColor
                  : admTextColor),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                searchIcon,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                    controller.themeController.isDarkMode
                        ? admWhiteColor
                        : admTextColor,
                    BlendMode.srcIn),
              )),
        )
      ],
    );
  }
}

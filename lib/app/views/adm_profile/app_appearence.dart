import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:administra/adm_theme/theme_controller.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../controller/adm_theme_controller.dart';

class AdmAppAppearance extends StatefulWidget {
  final String? initialLanguage;

  const AdmAppAppearance({super.key, this.initialLanguage = 'Español (GT)'});

  @override
  State<AdmAppAppearance> createState() => _AdmAppAppearanceState();
}

class _AdmAppAppearanceState extends State<AdmAppAppearance> {
  late String selectedLanguage; // Local state for language
  late ThemeData theme;
  final AdmThemeController controller = Get.put(AdmThemeController());

  @override
  void initState() {
    super.initState();
    // Initialize the selectedLanguage with the initialLanguage passed from widget
    selectedLanguage = widget.initialLanguage ?? 'Español (GT)';
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (_) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: commonAppBar(
            image: '', context: context, theme: theme, text: showText),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _showThemeBottomSheet(context, theme, controller);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        themeText,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: controller.themeController.isDarkMode
                              ? Colors.white
                              : admTextColor,
                        ),
                      ),
                    ),
                    Text(
                      controller.modeList[controller.selectedModeIndex.value],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: controller.themeController.isDarkMode
                            ? Colors.white
                            : admTextColor,
                      ),
                    ),
                    15.width,
                    Icon(
                      Icons.arrow_forward_ios,
                      color: controller.themeController.isDarkMode
                          ? Colors.white
                          : admTextColor,
                    )
                  ],
                ),
              ),
              25.height,
            ],
          ),
        ),
      );
    });
  }

  void _showThemeBottomSheet(
      BuildContext context, ThemeData theme, AdmThemeController controller) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              decoration: BoxDecoration(
                  color: controller.themeController.isDarkMode
                      ? admDarkPrimary
                      : whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  )),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.height,
                    Divider(
                      indent: 180,
                      height: 10,
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      endIndent: 180,
                      thickness: 4,
                    ),
                    10.height,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        chooseTheme,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    13.height,
                    Divider(
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    13.height,
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.modeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Radio(
                              activeColor: admColorPrimary,
                              fillColor:
                                  const WidgetStatePropertyAll(admColorPrimary),
                              value: index,
                              groupValue: controller.selectedModeIndex.value,
                              onChanged: (int? value) {
                                setState(() {
                                  controller.selectedModeIndex.value = value!;
                                });
                              },
                            ),
                            3.width,
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right:
                                        14), // Adjust horizontal padding as needed
                                child: Text(controller.modeList[index],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Divider(
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    13.height,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? admDarkLightColor
                                      : lightPrimaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    cancel,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Get.isDarkMode
                                          ? admWhiteColor
                                          : admColorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Adjust as needed
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  controller.themeController.toggleTheme();
                                  Get.forceAppUpdate();
                                  Get.back();
                                });
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: admColorPrimary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    ok,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: admWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

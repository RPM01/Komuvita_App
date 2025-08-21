import 'package:flutter/material.dart';

import '../../../constant/adm_colors.dart';

import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';

import 'package:get/get.dart';

import '../../controller/adm_helped_support_controller.dart';

class AdmHelpSupport extends StatefulWidget {
  const AdmHelpSupport({super.key});

  @override
  State<AdmHelpSupport> createState() => _AdmHelpSupportState();
}

class _AdmHelpSupportState extends State<AdmHelpSupport> {
  late ThemeData theme;
  AdmHelpAndSupportController controller =
      Get.put(AdmHelpAndSupportController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(
          image: '', context: context, theme: theme, text: helpAndSupportText),
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
                        index<4?
                        Get.to(controller.screens[index]):null;
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
                          ),
                        ),
                         Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Get.isDarkMode?admWhiteColor:admTextColor,
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}

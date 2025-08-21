import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';

class AdmDataAnalytics extends StatefulWidget {
  const AdmDataAnalytics({super.key});

  @override
  State<AdmDataAnalytics> createState() => _AdmDataAnalyticsState();
}

class _AdmDataAnalyticsState extends State<AdmDataAnalytics> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? admDarkPrimary : admLightGrey,
      appBar: commonAppBar(
          image: '',
          context: context,
          theme: theme,
          text: dataAnalyticsText),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataUsage,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        5.height,
                        Text(
                          dataUsageDes,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Get.isDarkMode ? admWhiteColor : admTextColor,
                  ),
                ],
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adPreferences,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        5.height,
                        Text(
                          adPreferencesDes,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                   Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Get.isDarkMode ? admWhiteColor : admTextColor,
                  ),
                ],
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          downloadMyData,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        5.height,
                        Text(
                          downloadMyDataDes,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                   Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                     color: Get.isDarkMode ? admWhiteColor : admTextColor,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

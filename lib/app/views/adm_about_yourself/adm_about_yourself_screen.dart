import 'package:flutter/material.dart';

import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/find_match_widget.dart';

class AdmAboutYourself extends StatefulWidget {
  const AdmAboutYourself({super.key});

  @override
  State<AdmAboutYourself> createState() => _AdmAboutYourselfState();
}

class _AdmAboutYourselfState extends State<AdmAboutYourself> {
  late ThemeData theme;
  late int selectedButtonIndex;
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedButtonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: buildContinueButton(() {
        Get.toNamed(MyRoute.findScreen);
      }),
      appBar: appbarWithProgressIndicator('1/4', theme, 0.4),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                aboutYourself,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.height,
              Text(
                aboutDes,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              25.height,
              buildCommonButtons(admAdopter, theme, 0, selectedButtonIndex, () {
                setState(() {
                  selectedButtonIndex = 0;
                });
              }),
              20.height,
              buildCommonButtons(
                  admOwnerOrganization, theme, 1, selectedButtonIndex, () {
                setState(() {
                  selectedButtonIndex = 1;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}

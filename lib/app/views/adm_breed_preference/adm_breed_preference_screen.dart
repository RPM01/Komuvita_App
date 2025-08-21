import 'package:flutter/material.dart';
import 'package:administra/constant/adm_colors.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../../../route/my_route.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/find_match_widget.dart';

import 'package:get/get.dart';

import '../../controller/adm_breed_preference_controller.dart';

class AdmBreedPreference extends StatefulWidget {
  const AdmBreedPreference({super.key});

  @override
  State<AdmBreedPreference> createState() => _AdmBreedPreferenceState();
}

class _AdmBreedPreferenceState extends State<AdmBreedPreference> {
  late ThemeData theme;
  late int selectedIndex;
  AdmBreedPreferenceController controller =
      Get.put(AdmBreedPreferenceController());
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedIndex = -1;
  }

  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
        bottomNavigationBar: buildContinueButton(() {
          Get.toNamed(MyRoute.finalStep);
        }),
        appBar: appbarWithProgressIndicator('3/4', theme, 0.8),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breedPreferences,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  10.height,
                  Text(
                    breedPreferencesDes,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  25.height,
                  Wrap(
                    children: List.generate(
                      controller.reportList.length,
                      (int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedIndices.contains(index)) {
                                  selectedIndices.remove(index);
                                } else {
                                  selectedIndices.add(index);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedIndices.contains(index)
                                    ? admColorPrimary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: selectedIndices.contains(index)
                                        ? Colors.transparent
                                        : Get.isDarkMode
                                        ? darkGreyColor
                                        : greyColor,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                controller.reportList[index],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: selectedIndices.contains(index)
                                      ? admWhiteColor
                                      : Get.isDarkMode
                                          ? admWhiteColor
                                          : admTextColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ]),
          ),
        ));
  }
}

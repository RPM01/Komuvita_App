import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';

import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';

import 'package:get/get.dart';

import '../../controller/adm_app_language_controller.dart';

class AdmAppLanguage extends StatefulWidget {
  const AdmAppLanguage({
    super.key,
  });

  @override
  State<AdmAppLanguage> createState() => _AdmAppLanguageState();
}

class _AdmAppLanguageState extends State<AdmAppLanguage> {
  late ThemeData theme;
  AdmAppLanguageController controller = Get.put(AdmAppLanguageController());
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? admDarkPrimary : admLightGrey,
      appBar: commonAppBar(
          image: '',
          context: context,
          theme: theme,
          text: appLanguage),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.languages.length,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });

                    String selectedLanguage = controller.languages.elementAt(index)['name'];
                    Get.back(
                        result:
                            selectedLanguage); // Pass the selected language back
                  },


                  child: Container(
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? admDarkBorderColor
                            : admWhiteColor,
                        border: Border.all(
                            color: selectedIndex == index
                                ? admColorPrimary
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            controller.languages[index]['image'],
                            width: 50,
                            height: 35,

                          ),
                          13.width,
                          Expanded(
                            child: Text(
                              controller.languages[index]['name'],
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          selectedIndex == index
                              ? const Icon(
                                  Icons.check,
                                  color: admColorPrimary,
                                  size: 20,
                                )
                              : Container(),
                          10.width,
                        ],
                      ),
                    ),
                  ),
                ),
                20.height
              ],
            );
          }),
    );
  }
}

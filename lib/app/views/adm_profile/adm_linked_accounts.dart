import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';

import 'package:get/get.dart';

import '../../controller/adm_linked_account_controller.dart';

class AdmLinkedAccounts extends StatefulWidget {
  const AdmLinkedAccounts({super.key});

  @override
  State<AdmLinkedAccounts> createState() => _AdmLinkedAccountsState();
}

class _AdmLinkedAccountsState extends State<AdmLinkedAccounts> {
  late ThemeData theme;
  AdmLinkedAccountController controller = Get.put(AdmLinkedAccountController());

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
          text: linkedText),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: controller.accounts.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final bool isSelected = controller.accounts[index]['isSelected'];
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:
                            Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          index==3?CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(controller.accounts[index]['image']),):
                          index == 1
                              ? SvgPicture.asset(
                                  controller.accounts[index]['image'],
                                  height: 35,
                                  width: 35,
                                  colorFilter: ColorFilter.mode(
                                      Get.isDarkMode
                                          ? admWhiteColor
                                          : admBlackColor,
                                      BlendMode.srcIn),
                                )
                              : SvgPicture.asset(
                                  controller.accounts[index]['image'],
                                  height: 35,
                                  width: 35,
                                ),
                          13.width,
                          Expanded(
                            child: Text(
                              controller.accounts[index]['name'],
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                controller.accounts[index]['isSelected'] =
                                    !controller.accounts[index]['isSelected'];
                              });
                            },
                            child: Text(
                              isSelected? 'Conectar':controller.accounts[index]['Connected'],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? admColorPrimary
                                      : Get.isDarkMode
                                          ? admBorderColor
                                          : admDarkColorGrey),
                            ),
                          ),
                          10.width,
                        ],
                      ),
                    ),
                  ),
                  20.height
                ],
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import 'package:get/get.dart';
import '../../controller/adm_contact_support_controller.dart';

class AdmContactSupportScreen extends StatefulWidget {
  const AdmContactSupportScreen({super.key});

  @override
  State<AdmContactSupportScreen> createState() =>
      _AdmContactSupportScreenState();
}

class _AdmContactSupportScreenState extends State<AdmContactSupportScreen> {
  late ThemeData theme;
  AdmContactSupportController controller =
      Get.put(AdmContactSupportController());
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
          text: contactSupport),
      body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          itemCount: controller.contactDetail.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
                          controller.contactDetail[index]['image'],
                          height: 25,
                          width: 25,
                        ),
                        13.width,
                        Expanded(
                          child: Text(
                            controller.contactDetail[index]['name'],
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Get.isDarkMode
                              ? admWhiteColor
                              : admTextColor,
                          size: 20,
                        ),
                        10.width,
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

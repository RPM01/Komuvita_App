import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../controller/adm_privacy_policy_controller.dart';

class AdmPrivacyPolicyScreen extends StatefulWidget {
  const AdmPrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<AdmPrivacyPolicyScreen> createState() => _AdmPrivacyPolicyScreenState();
}

class _AdmPrivacyPolicyScreenState extends State<AdmPrivacyPolicyScreen> {
  late ThemeData theme;
  AdmPrivacyPolicyController controller = Get.put(AdmPrivacyPolicyController());

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

          image: '',
          context: context,
          theme: theme,
          text: privacyPolicy),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  effectiveDate,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                20.height,
                ListView.builder(
                  itemCount: controller.privacyPolicyDetail.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.privacyPolicyDetail
                              .elementAt(index)['title']!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        13.height,
                        Text(
                          controller.privacyPolicyDetail
                              .elementAt(index)['subtitle']!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode ? admLightGrey : admDarkGrey,
                          ),
                        ),
                        23.height,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

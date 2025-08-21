import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../controller/adm_terms_service_controller.dart';
import 'package:get/get.dart';

class AdmTermsAndServiceScreen extends StatefulWidget {
  const AdmTermsAndServiceScreen({Key? key}) : super(key: key);

  @override
  State<AdmTermsAndServiceScreen> createState() =>
      _AdmTermsAndServiceScreenState();
}

class _AdmTermsAndServiceScreenState extends State<AdmTermsAndServiceScreen> {
  late ThemeData theme;

  AdmTermsServiceController controller = Get.put(AdmTermsServiceController());
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
          text: termsOfUse),
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
                  itemCount: controller.termsServiceDetail.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.termsServiceDetail
                              .elementAt(index)['title']!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        13.height,
                        Text(
                          controller.termsServiceDetail
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

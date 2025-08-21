import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../route/my_route.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_button.dart';
import 'package:get/get.dart';

class AdmSuccessfullyRegister extends StatefulWidget {
  const AdmSuccessfullyRegister({super.key});

  @override
  State<AdmSuccessfullyRegister> createState() =>
      _AdmSuccessfullyRegisterState();
}

class _AdmSuccessfullyRegisterState extends State<AdmSuccessfullyRegister> {
  late ThemeData theme;
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: PrimaryButton(
        text: gotoHomePage,
        onTap: () {
          Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(successfullyRegister),
            30.height,
            Text(
              youAreAllSet,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            18.height,
            Align(
              alignment: Alignment.center,
              child: Text(
                changedPassword,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

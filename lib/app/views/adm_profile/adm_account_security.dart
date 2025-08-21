import 'package:flutter/material.dart';

import 'package:administra/app/views/adm_profile/adm_notification.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';

import 'package:get/get.dart';

import '../../controller/adm_my_profile_controller.dart';

class AdmAccountSecurity extends StatefulWidget {
  const AdmAccountSecurity({super.key});

  @override
  State<AdmAccountSecurity> createState() => _AdmAccountSecurityState();
}

class _AdmAccountSecurityState extends State<AdmAccountSecurity> {
  late ThemeData theme;
  MyProfileController controller = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  bool biometric = false;
  bool faceId = false;
  bool sms = false;
  bool google = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(
          image: '', context: context, theme: theme, text: securityText),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSwitchRow(biometricID, biometric, (newValue) {
                setState(() {
                  biometric = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(faceID, faceId, (newValue) {
                setState(() {
                  faceId = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(smsAuthentication, sms, (newValue) {
                setState(() {
                  sms = newValue;
                });
              }, theme),
              20.height,
              buildSwitchRow(googleAuthenticator, google, (newValue) {
                setState(() {
                  google = newValue;
                });
              }, theme),
              23.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    changePassword,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color:Get.isDarkMode
                        ? admWhiteColor
                        : admTextColor,
                  )
                ],
              ),
              23.height,
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
                          deviceManagement,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        5.height,
                        Text(
                          deviceManagementDes,
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
                    color:Get.isDarkMode
                        ? admWhiteColor
                        : admTextColor,
                  ),
                ],
              ),
              23.height,
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
                          deactivateAccount,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        5.height,
                        Text(
                          deactivateAccountDes,
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
                     color:Get.isDarkMode
                         ? admWhiteColor
                         : admTextColor,
                  ),
                ],
              ),
              23.height,
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
                          deleteAccount,
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600, color: admLightRed),
                        ),
                        5.height,
                        Text(
                          deleteAccountDes,
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
                     color:Get.isDarkMode
                         ? admWhiteColor
                         : admTextColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

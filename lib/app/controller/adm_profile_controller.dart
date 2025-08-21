import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import '../../constant/adm_images.dart';
import '../../constant/adm_strings.dart';
import '../views/adm_password_creation/adm_password_creation_screen.dart';
import '../views/adm_profile/app_appearence.dart';
import '../views/adm_profile/adm_account_security.dart';
import '../views/adm_profile/adm_data_anlystics.dart';
import '../views/adm_profile/adm_help_support.dart';
import '../views/adm_profile/adm_linked_accounts.dart';
import '../views/adm_profile/adm_my_profile_screen.dart';
import '../views/adm_profile/adm_notification.dart';

class ProfileController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  List profileList = [

    {'image': notification, 'name': notificationText},
    {'image': security, 'name': "Cambio de contraseña"},
    /*    {'image': linked, 'name': linkedText},
    {'image': show, 'name': showText},
    {'image': dataAnalytics, 'name': dataAnalyticsText},
    {'image': helpAndSupport, 'name': helpAndSupportText},
    * */

  ];
  List screens =  [
    const AdmMyProfileScreen(),
    const AdmPasswordCreationScreen(),
  ];
}

import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';

class AdmThemeController extends GetxController {
  List<String> modeList = ['Claro', 'Oscuro'];

  // bool isDarkMode = false;

  RxInt selectedModeIndex = 0.obs;

  final ThemeController themeController = Get.put(ThemeController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // isDarkMode = themeController.isDarkMode;
    if (themeController.isDarkMode) {
      selectedModeIndex.value = 1;
    } else {
      selectedModeIndex.value = 0;
    }
  }
}

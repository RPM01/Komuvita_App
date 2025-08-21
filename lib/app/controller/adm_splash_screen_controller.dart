
import 'package:get/get.dart';

import '../../../../route/my_route.dart';


class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(MyRoute.loginScreen);
    });
  }
}


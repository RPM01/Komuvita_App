import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:administra/route/my_route.dart';
import '../../constant/adm_images.dart';
import '../../constant/adm_strings.dart';



class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final ThemeController themeController = Get.put(ThemeController());
  RxInt pageIndex = 0.obs;
  List content = [
    {
      'title': onboardingTitleOne,
      'image': firstOnboarding,
      'dark_image': firstOnboardingDark,
      'desc': onboardingSubTitleOne,
    },
    {
      'title': onboardingTitleTwo,
      'image': secondOnboarding,
      'dark_image': secondOnboardingDark,
      'desc': onboardingSubTitleTwo,
    },
    {
      'title': onboardingTitleThree,
      'image': threeOnboarding,
      'dark_image': threeOnboardingDark,
      'desc': onboardingSubTitleThree,
    }
  ];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      pageIndex.value = pageController.page?.round() ?? 0;
    });
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  String getTitle(int index) {
    return content[index]['title'];
  }

  String getDescription(int index) {
    return content[index]['desc'];
  }

  void goToNextPage() {
    if (pageIndex.value == content.length - 1) {
      Get.toNamed(MyRoute.admOnboardingScreen);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip() {
    Get.toNamed(MyRoute.welcomeScreen);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/size_config.dart';
import '../../../constant/adm_strings.dart';
import '../../controller/adm_dashboard_controller.dart';
import '../adm_chat/adm_message_screen.dart';
import '../adm_favourites/adm_favourites_screen.dart';
import '../adm_home/adm_home_screen.dart';
import '../adm_profile/adm_profile_screen.dart';
import 'package:administra/app/views/adm_menu/adm_menu.dart';

class AdmDashboardScreen extends StatelessWidget {
  const AdmDashboardScreen({super.key});

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SizedBox(
          //height: 55,
          child: BottomNavigationBar(
            backgroundColor: Get.isDarkMode ? admDarkPrimary : admWhiteColor,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            unselectedItemColor: darkGreyColor,
            selectedItemColor: admColorPrimary,
            selectedFontSize: textSizeSmall,
            unselectedFontSize: textSizeSmall,

            items: [
              _bottomNavbarItem(homeImage, activeHome, home),
              _bottomNavbarItem(locationImage, activeLocation, menu),
              _bottomNavbarItem(favouritesImage, activeFavourites, favorites),
              _bottomNavbarItem(chatImage, activeChat, messages),
              _bottomNavbarItem(profileImage, activeProfile, account),
            ], 
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DashboardController controller = Get.put(
      DashboardController(),
    );

    //scaffold wrap by safeArea than not showing status bar
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: buildBottomNavigationMenu(context, controller),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: const [
              AdmHomeScreen(),
              AdmMenu(),
              AdmFavouriteScreen(),
              AdmMessageScreen(),
              AdmProfileScreen(),
            ],
          )),
    );
  }
}

_bottomNavbarItem(String assetName, String activeAsset, String label) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(
      assetName,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    ),
    activeIcon: SvgPicture.asset(
      activeAsset,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
    ),
    label: label,
  );
}

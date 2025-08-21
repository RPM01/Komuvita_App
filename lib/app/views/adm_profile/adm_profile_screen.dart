import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/app/views/adm_profile/adm_my_profile_screen.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../controller/adm_profile_controller.dart';

class AdmProfileScreen extends StatefulWidget {
  const AdmProfileScreen({super.key});

  @override
  State<AdmProfileScreen> createState() => _AdmProfileScreenState();
}

class _AdmProfileScreenState extends State<AdmProfileScreen> {
  late ThemeData theme;
  late int selectedIndex;
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    //theme = Styles.admTheme;
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
    selectedIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      theme = controller.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
      appBar: customAppBar(
          //color: theme.scaffoldBackgroundColor,
          image: splashImg,
          context: context,
          theme: theme,
          text: account,
          leading: '',
          trailing: '',
        color:  controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(const AdmMyProfileScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 37,
                      backgroundImage: AssetImage(userImg),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userText,
                            style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: controller.themeController.isDarkMode
                                    ? admWhiteColor
                                    : admTextColor),
                          ),
                          9.height,
                          Text(
                            userEmail,
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: controller.themeController.isDarkMode
                                    ? greyColor
                                    : admGreyTextColor),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              23.height,
              Divider(
                color: controller.themeController.isDarkMode
                    ? admDarkDivider
                    : greyColor,
                height: 1,
              ),
              23.height,
              ListView.builder(
                  itemCount: controller.profileList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(controller.screens[index]);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                controller.profileList
                                    .elementAt(index)['image'],
                                colorFilter: ColorFilter.mode(
                                    controller.themeController.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor,
                                    BlendMode.srcIn),
                              ),
                              13.width, 
                              Expanded(
                                child: Text(
                                  controller.profileList
                                      .elementAt(index)['name'],
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: controller.themeController.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: controller.themeController.isDarkMode
                                    ? admWhiteColor
                                    : admTextColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        25.height,
                      ],
                    );
                  }),

              InkWell(
                onTap: () {
                  _showLogOutBottomSheet(context);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(logout),
                    13.width,
                    Expanded(
                      child: Text(
                        logoutText,
                        style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600, color: admLightRed),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogOutBottomSheet(
    BuildContext context,
  ) {
    final ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? admDarkPrimary : whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  )),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.height,
                      Divider(
                        indent: 180,
                        color: Get.isDarkMode ? admDarkLightColor : greyColor,
                        endIndent: 180,
                        thickness: 4,
                      ),
                      15.height,
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          logoutText,
                          style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700, color: admLightRed),
                        ),
                      ),
                      15.height,
                      Divider(
                        color: Get.isDarkMode ? admDarkLightColor : greyColor,
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      18.height,
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          logoutDes,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      18.height,
                      Divider(
                        color: Get.isDarkMode ? admDarkLightColor : greyColor,
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      15.height,
                      Padding(
                        padding:  EdgeInsets.only(left: 8, right: 8,bottom: GetPlatform.isIOS
                            ? MediaQuery.of(context).padding.bottom
                            : 8,top:8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? admDarkLightColor
                                        : lightPrimaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cancel,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Get.isDarkMode
                                            ? admWhiteColor
                                            : admColorPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20), // Adjust as needed
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Get.offNamedUntil('/adm_login',
                                  //     ModalRoute.withName(MyRoute.loginScreen));
                                  Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: admColorPrimary,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      yesLogout,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: admWhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.height
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

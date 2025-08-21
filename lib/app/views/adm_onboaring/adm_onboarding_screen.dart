import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_onboarding_controller.dart';

class AdmOnboardingScreen extends StatefulWidget {
  const AdmOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<AdmOnboardingScreen> createState() => _AdmOnboardingScreenState();
}

class _AdmOnboardingScreenState extends State<AdmOnboardingScreen> {
  final OnboardingController controller = Get.put(OnboardingController());

  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: Get.isDarkMode
            ? controller.pageIndex.value == index
                ? admColorPrimary
                : admDarkLightColor
            : controller.pageIndex.value == index
                ? admColorPrimary
                : greyColor,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: controller.pageIndex.value == index ? 30 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: admColorPrimary,
          body: GetBuilder<OnboardingController>(
              builder: (controller) => (Obx(
                    () => Stack(
                      children: [
                        PageView.builder(
                          itemCount: controller.content.length,
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30, top: 50),
                                child: Get.isDarkMode
                                    ? Image.asset(
                                        controller.content[index]['dark_image'],
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        controller.content[index]['image'],
                                        fit: BoxFit.contain,
                                      ));
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          child: ClipPath(
                            clipper: BottomClipper(),
                            child: Container(
                              width: width,
                              height: height * 0.38,
                              color: Get.isDarkMode
                                  ? admDarkPrimary
                                  : admWhiteColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: SingleChildScrollView(
                                  child: Column( 
                                    children: [
                                      SizedBox(
                                        height: height * 0.11,
                                      ),
                                      Text(
                                        controller.getTitle(
                                          controller.pageIndex.value,
                                        ),
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: controller
                                                        .themeController
                                                        .isDarkMode
                                                    ? admWhiteColor
                                                    : admTextColor),
                                        textAlign: TextAlign.center,
                                      ),
                                      13.height,
                                      Text(
                                        controller.getDescription(
                                            controller.pageIndex.value),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          // height: 1.4
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      18.height,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          controller.content.length,
                                          (int index) => _buildDots(
                                            index: index,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
          bottomNavigationBar: Obx(
            () => Container(
                height: 120,

                //height: 123,
                decoration: BoxDecoration(

                  color: controller.themeController.isDarkMode ? admDarkPrimary : admWhiteColor,
                  // border: Border.all(
                  //     color: Get.isDarkMode ? admDarkLightColor : admLightGrey)
                ),
                child: Column(
                  children: [
                    commonDivider(),
                    12.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: controller.pageIndex.value ==
                              controller.content.length - 1
                          ? InkWell(
                              onTap: () {
                                controller.skip();
                              },
                              child: Container(
                                height: 58,
                                decoration: BoxDecoration(
                                  color: admColorPrimary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    getStarted,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: admWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      controller.skip();
                                    },
                                    child: Container(
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? admDarkLightColor
                                            : lightPrimaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          skip,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
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
                                      controller.goToNextPage();
                                    },
                                    child: Container(
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: admColorPrimary,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          continueText,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
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
                  ],
                )),
          )
      ),
    );
  }
}

Widget commonDivider() {
  return Divider(color: Get.isDarkMode ? admDarkLightColor : admLightGrey);
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height); // Start at the bottom-left corner
    path.lineTo(size.width, size.height); // Line to the bottom-right corner
    path.lineTo(size.width, 20); // Line to the top-right corner
    path.quadraticBezierTo(size.width / 2, size.height * 0.4, 0,
        0); // Create a quadratic bezier curve to the top-left corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

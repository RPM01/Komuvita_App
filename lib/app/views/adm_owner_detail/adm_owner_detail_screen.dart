import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:administra/adm_theme/theme_controller.dart';
import '../../../../../route/my_route.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/common_progress.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_grid_view.dart';
import '../../controller/adm_owner_detail_controller.dart';
import 'package:get/get.dart';

import '../adm_chat/adm_chat_screen.dart';

class AdmOwnerDetailScreen extends StatefulWidget {
  const AdmOwnerDetailScreen({super.key});

  @override
  State<AdmOwnerDetailScreen> createState() => _AdmOwnerDetailScreenState();
}

class _AdmOwnerDetailScreenState extends State<AdmOwnerDetailScreen> {
  late ThemeData theme;
  late int selectedButtonIndex;
  AdmOwnerDetailController controller = Get.put(AdmOwnerDetailController());
  final bool value = false;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedButtonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? admDarkPrimary : admsScaffoldBackgroundColor,
      appBar: commonAppBar(
        image: more,
        context: context,
        theme: theme,
        text: owner,

      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(left: 15,right: 15,bottom:  GetPlatform.isIOS
            ? MediaQuery.of(context).padding.bottom:15),
        child: InkWell(
          onTap: () {
            Get.to(const AdmChatScreen(
              name: 'Happy Tails Ani...',
            ));
          },
          child: Container(
            height: 58,
            decoration: BoxDecoration(
                color: admColorPrimary,
                borderRadius: BorderRadius.circular(50)),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                sendMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: admWhiteColor),
              ),
            ),
          ),
        ),
      ),

      body: GetBuilder<AdmOwnerDetailController>(
        init: controller,
        tag: 'adm_OwnerDetail',
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomScrollView(
              slivers: <Widget>[
                // Use SliverToBoxAdapter for a simpler layout instead of SliverAppBar
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Get.isDarkMode ? admDarkBorderColor : whiteColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                animal,
                                height: 80,
                                width: 80,
                              ),
                              12.width,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    animalRescue,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  12.height,
                                  animalAddressDetail(map, address,12.2,12.2),
                                  5.height,
                                  animalAddressDetail(calling, callingNumber,9.0,9.0),
                                  5.height,
                                  animalAddressDetail(emailImg, gmail,9.0,9.0),
                                  5.height,
                                  animalAddressDetail(discovery, organization,12.0,12.0),
                                  5.height,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.height,
                      Container(
                        decoration: BoxDecoration(
                          color: Get.isDarkMode ? admDarkBorderColor : whiteColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sharingView(phone, phoneText),
                              sharingView(gmailImg, email),
                              sharingView(website, websiteText),
                              sharingView(navigate, navigateText),
                            ],
                          ),
                        ),
                      ),
                      20.height,
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 60,
                    maxHeight: 60,
                    child: Container(
                      color: Get.isDarkMode ? admDarkPrimary : admsScaffoldBackgroundColor,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? admDarkLightColor : greyColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Obx(
                                    () => buildButtons(
                                  '$adms (${controller.listOfAdms.length})',
                                  theme,
                                  0,
                                  selectedButtonIndex,
                                      () {
                                    setState(() {
                                      selectedButtonIndex = 0;
                                    });
                                  },
                                ),
                              ),
                              buildButtons(
                                adoptionPolicy,
                                theme,
                                1,
                                selectedButtonIndex,
                                    () {
                                  setState(() {
                                    selectedButtonIndex = 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: selectedButtonIndex == 0
                      ? FutureBuilder(
                    future: controller.getSearchAdmsDetail(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return commonProgressBar();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GridView.builder(
                            itemCount: controller.listOfAdms.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 5,
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.4
                                  ),
                            ),
                            itemBuilder: (context, index) {
                              final data = controller.listOfAdms[index];
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(MyRoute.admDetail, arguments: data);
                                },
                                child: Obx(
                                      () => admDetailGridView(
                                    theme,
                                    data,
                                        () {
                                      controller.toggleFavorite(data);
                                      data.isFavorite.value==false?
                                      customMsgBox(admRemovedFromFavourites,theme,context):
                                      customMsgBox(admAddedToFavourites,theme,context);
                                    },
                                    context,
                                    data.isFavorite.value ? like : unlike,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                      : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      itemCount: controller.privacyPolicy.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.privacyPolicy.elementAt(index)['title'],
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            15.height,
                            Text(
                              controller.privacyPolicy.elementAt(index)['des'],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode ? admLightGrey : admDarkGrey,
                              ),
                            ),
                            15.height,
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget animalAddressDetail(String image, text,double? height,width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          height: height,
          width: width,
        ),
        10.width,
        Text(
          text,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget sharingView(String image, text) {
    return Column(
      children: [
        SvgPicture.asset(
          image,
          height: 48,
          width: 48,
        ),
        10.height,
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Get.isDarkMode ? admLightGrey : admDarkGrey,
          ),
        ),
      ],
    );
  }
}

Widget buildButtons(String text, ThemeData theme, int index,
    int selectedButtonIndex, void Function()? onTap) {
  final ThemeController themeController = Get.put(ThemeController());
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: index == selectedButtonIndex
              ? admColorPrimary
              : themeController.isDarkMode
              ? admDarkLightColor
              : greyColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: index == selectedButtonIndex
                  ? whiteColor
                  : themeController.isDarkMode
                  ? admWhiteColor
                  : admTextColor,
            ),
          ),
        ),
      ),
    ),
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

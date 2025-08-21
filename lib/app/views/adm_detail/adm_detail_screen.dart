import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/route/my_route.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../controller/adm_detail_controller.dart';
import 'package:get/get.dart';
import '../adm_chat/adm_chat_screen.dart';

class AdmDetailScreen extends StatefulWidget {
  const AdmDetailScreen({super.key});

  @override
  State<AdmDetailScreen> createState() => _AdmDetailScreenState();
}

class _AdmDetailScreenState extends State<AdmDetailScreen> {
  AdmDetailController controller = Get.put(AdmDetailController());
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
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
              )),
          title: Text(
            admDetails,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Share.share('https://www.administra.com.gt/');
                  },
                  icon: SvgPicture.asset(
                    share,
                    height: 24,
                    width: 21,
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode ? admWhiteColor : admTextColor,
                        BlendMode.srcIn),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Get.isDarkMode ? admWhiteColor : admTextColor,
                    ))
              ],
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 118,
          decoration: BoxDecoration(
              color: Get.isDarkMode ? admDarkPrimary : admWhiteColor,
              ),
          child: Column(
            children: [
              Divider(
                  color: Get.isDarkMode
                      ? admDarkLightColor
                      : admLightGrey),
              12.height,
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? admDarkLightColor
                              : lightPrimaryColor,
                          borderRadius: BorderRadius.circular(60)),
                      child: Obx(
                        () => IconButton(
                            onPressed: () {
                              controller.toggleFavorite(controller.admDetail);
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () => Get.back());
                                    return AlertDialog(
                                      backgroundColor: Get.isDarkMode
                                          ? admDarkBorderColor
                                          : lightGreyColor,
                                      insetPadding:
                                          const EdgeInsets.only(bottom: 90),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                      actionsAlignment: MainAxisAlignment.center,
                                      alignment: Alignment.bottomCenter,
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(checkMark),
                                          7.width,
                                          Text(
                                            controller.admDetail.isFavorite.value ==
                                                    false
                                                ? addedToFavourite
                                                : removedToFavourite,
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: controller.admDetail.isFavorite.value
                                ? SvgPicture.asset(
                                    unlike,
                                    colorFilter: const ColorFilter.mode(
                                        admColorPrimary, BlendMode.srcIn),
                                    height: 23,
                                    width: 23,
                                  )
                                : SvgPicture.asset(
                                    like,
                                    colorFilter: const ColorFilter.mode(
                                        admColorPrimary, BlendMode.srcIn),
                                    height: 23,
                                    width: 23,
                                  )

                            //   : SvgPicture.asset(
                            //       unlike,
                            // colorFilter: const ColorFilter.mode(
                            //     admColorPrimary, BlendMode.srcIn),
                            //       height: 23,
                            //       width: 23,
                            //     )
                            ),
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(const AdmChatScreen(
                            name: 'Administra...',
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
                              adopt,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: admWhiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<AdmDetailController>(
          init: controller,
          tag: 'adm_Detail',
          builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        items: controller.admDetail.image
                            .map(
                              (item) => Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: commonCacheAdmImageWidget(item, 380,
                                        fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Container(
                                      height: 38,
                                      width: 58,
                                      decoration: BoxDecoration(
                                          color:
                                              admDarkPrimary.withOpacity(0.60),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: Obx(() =>  Text(
                                          '${controller.currentIndex.value.toString()}/${controller.admDetail.image.length}',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: admWhiteColor),
                                        ),)

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          aspectRatio: 9 / 8.5,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            controller.onPageChanged(index);
                          },
                        ),
                      ),

                      // Align(
                      //   alignment: Alignment.center,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(6),
                      //     child: commonCacheAdmImageWidget(controller.admDetail.image[0], 383, ),
                      //   ),
                      // ),
                      15.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.admDetail.name.toString(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          10.width,
                          Text('(${controller.admDetail.category.toString()})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Get.isDarkMode
                                      ? greyColor
                                      : admGreyTextColor)),
                        ],
                      ),
                      15.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            map,
                            height: 20,
                            width: 14,
                          ),
                          10.width,
                          Text(controller.admDetail.distance.toString(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Get.isDarkMode
                                      ? greyColor
                                      : admGreyTextColor)),
                        ],
                      ),
                      18.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: detailContainer(
                                theme,
                                genderText,
                                controller.admDetail.rooms.toString(),
                                const Color.fromRGBO(43, 124, 154, 0.08),
                            ),
                          ),
                          Expanded(
                            child: detailContainer(
                                theme,
                                age,
                                controller.admDetail.amenities.toString(),
                                const Color.fromRGBO(43, 124, 154, 0.08),
                            ),
                          ),
                          Expanded(
                            child: detailContainer(
                                theme,
                                sizeText,
                                controller.admDetail.size.toString(),
                                const Color.fromRGBO(43, 124, 154, 0.08),
                            ),
                          ),
                        ],
                      ),
                      18.height,
                      InkWell(
                        onTap: () {
                          Get.toNamed(MyRoute.admOwnerDetail);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              animal,
                              height: 60,
                              width: 60,
                            ),
                            10.width,
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    animalRescue,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  5.height,
                                  Text(
                                    address,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Get.isDarkMode
                                                ? greyColor
                                                : admGreyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(forward)
                          ],
                        ),
                      ),
                      18.height,
                      Text(
                        '$about  ${controller.admDetail.name}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      15.height,
                      Text(
                        controller.admDetail.about.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Get.isDarkMode ? admLightGrey : admDarkGrey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget detailContainer(
      ThemeData theme, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 85,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Get.isDarkMode ? greyColor : admGreyTextColor)),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

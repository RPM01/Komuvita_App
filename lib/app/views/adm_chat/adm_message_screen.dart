import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:administra/app/views/adm_chat/adm_chat_screen.dart';
import 'package:administra/route/my_route.dart';

import 'package:get/get.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../controller/adm_message_controller.dart';
import '../../modal/adm_message_modal.dart';

class AdmMessageScreen extends StatefulWidget {
  final bool cameFromDetailScreen;

  const AdmMessageScreen({super.key, this.cameFromDetailScreen = false});

  @override
  State<AdmMessageScreen> createState() => _AdmMessageScreenState();
}

class _AdmMessageScreenState extends State<AdmMessageScreen> {
    
  AdmMessageController controller = Get.put(AdmMessageController());
  late ThemeData theme;
  late int selectedButtonIndex;

  @override
  void initState() {
    super.initState();
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
    selectedButtonIndex = 0;
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
        appBar: AppBar(
          backgroundColor:controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
          centerTitle: true,
          leading: widget.cameFromDetailScreen
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Get.isDarkMode ? admWhiteColor : admTextColor,
                  ))
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    splashImg,
                    height: 28,
                    width: 29,
                    colorFilter: const ColorFilter.mode(
                        admColorPrimary, BlendMode.srcIn),
                  ),
                ),
          title: Text(
            messages,
            style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: controller.themeController.isDarkMode
                    ? admWhiteColor
                    : admTextColor),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      searchIcon,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          controller.themeController.isDarkMode
                              ? admWhiteColor
                              : admTextColor,
                          BlendMode.srcIn),
                    )),
                10.width,
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      more,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          controller.themeController.isDarkMode
                              ? admWhiteColor
                              : admTextColor,
                          BlendMode.srcIn),
                    ))
              ],
            )
          ],
        ),
        body: GetBuilder<AdmMessageController>(
          init: controller,
          tag: 'adm_chat',
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: controller.themeController.isDarkMode ? admDarkLightColor : greyColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  15.height,
                  selectedButtonIndex == 0
                      ? Expanded(
                          child: FutureBuilder(
                              future: controller.getChatsDetail(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return commonProgressBar();
                                } else {
                                  return ListView.builder(
                                      itemCount: controller.listOfChats.length,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        AdmMessageModal data =
                                            controller.listOfChats[index];

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 23),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(AdmChatScreen(
                                                name: data.title,
                                              ));
                                            },
                                            child: Row(
                                              children: [
                                                commonCacheAdmImageWidget(
                                                  data.image.toString(),
                                                  60,
                                                  width: 60,
                                                ),
                                                17.width,
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              data.title
                                                                  .toString(),
                                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                                  color: controller
                                                                          .themeController
                                                                          .isDarkMode
                                                                      ? admWhiteColor
                                                                      : admTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          ),
                                                          data.count
                                                                  .toString()
                                                                  .isEmpty
                                                              ? Container()
                                                              : CircleAvatar(
                                                                  radius: 13,
                                                                  backgroundColor:
                                                                      admColorPrimary,
                                                                  child: Center(
                                                                    child: Text(
                                                                        data.count
                                                                            .toString(),
                                                                        style: theme
                                                                            .textTheme
                                                                            .headlineLarge
                                                                            ?.copyWith(
                                                                                fontWeight: FontWeight.w500,
                                                                                color: whiteColor,fontSize: 12)),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      12.height,
                                                      Row(children: [
                                                        Expanded(
                                                          child: Text(
                                                            data.des.toString(),
                                                            style: theme.textTheme.titleSmall?.copyWith(
                                                                color: controller
                                                                        .themeController
                                                                        .isDarkMode
                                                                    ? greyColor
                                                                    : admGreyTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                        12.width,
                                                        Text(
                                                          data.time.toString(),
                                                          style: theme.textTheme.titleSmall?.copyWith(
                                                              color: controller
                                                                      .themeController
                                                                      .isDarkMode
                                                                  ? greyColor
                                                                  : admGreyTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }),
                        )
                      : Expanded(
                          child: FutureBuilder(
                              future: controller.getCallsDetail(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return commonProgressBar();
                                } else {
                                  return ListView.builder(
                                      itemCount: controller.listOfCalls.length,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        AdmMessageModal data =
                                            controller.listOfCalls[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 23),
                                          child: InkWell(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                commonCacheAdmImageWidget(
                                                  data.image.toString(),
                                                  60,
                                                  width: 60,
                                                ),
                                                17.width,
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.title.toString(),
                                                        style: theme
                                                            .textTheme.bodyLarge
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: (index ==
                                                                            3 ||
                                                                        index ==
                                                                            6)
                                                                    ? admLightRed
                                                                    : controller
                                                                            .themeController
                                                                            .isDarkMode
                                                                        ? admWhiteColor
                                                                        : admTextColor),
                                                      ),
                                                      12.height,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          commonCacheAdmImageWidget(
                                                              data.prefixImage
                                                                  .toString(),
                                                              9,
                                                              width: 9,
                                                              color: (index ==
                                                                          3 ||
                                                                      index ==
                                                                          6)
                                                                  ? admLightRed
                                                                  : admLightGreen),
                                                          12.width,
                                                          Text(
                                                            data.time
                                                                .toString(),
                                                            style: theme
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                              color: controller
                                                                      .themeController
                                                                      .isDarkMode
                                                                  ? greyColor
                                                                  : admGreyTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    controller.listOfCalls[index].selected==true?
                                                    Get.toNamed(MyRoute.admVideoCall):Get.toNamed(MyRoute.admVoiceCall);
                                                  },
                                                  child: commonCacheAdmImageWidget(
                                                    data.suffixImage.toString(),
                                                    24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }),
                        )
                ],
              ),
            );
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:administra/route/my_route.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_grid_view.dart';
import '../../controller/adm_search_result_controller.dart';
import 'package:get/get.dart';
import 'package:administra/constant/adm_images.dart';

class AdmSearchResult extends StatefulWidget {
  const AdmSearchResult({super.key});

  @override
  State<AdmSearchResult> createState() => _AdmSearchResultState();
}

class _AdmSearchResultState extends State<AdmSearchResult> {
  AdmSearchResultController controller = Get.put(AdmSearchResultController());
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;

    controller.selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: commonAppBar(
          image: searchIcon,
          context: context,
          theme: theme,
          text: searchResults,
        ),
        body: GetBuilder<AdmSearchResultController>(
          init: controller,
          tag: 'adm_searchResult',
          builder: (controller) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Obx(() => HorizontalList(
                    padding:  const EdgeInsets.only(left: 15,right: 15),
                    itemCount: controller.listOCategoryAdms.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () =>  InkWell(
                          onTap: () {
                            controller.selection(index); // Update selected index and fetch adms
                          },
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex.value == index
                                  ? admColorPrimary // Highlight selected category
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: controller.selectedIndex.value == index
                                    ? Get.isDarkMode
                                    ? Colors.transparent
                                    : Colors.transparent
                                    : Get.isDarkMode
                                    ? admBorderColor
                                    : admBorderColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                3.width,
                                Text(
                                  controller.listOCategoryAdms[index].name.toString(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: controller.selectedIndex.value == index
                                        ? Get.isDarkMode
                                        ? admWhiteColor
                                        : admWhiteColor
                                        : Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  15.height,

                  Obx(() {
                    if (controller.admList.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No Data Available',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Get.isDarkMode ? admWhiteColor : admTextColor,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Obx(
                            () =>  GridView.builder(
                              itemCount: controller.admList.length, // Number of adms
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                crossAxisSpacing: 15,
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.4),
                              ),
                              itemBuilder: (context, index) {
                                final data = controller.admList[index]; // Adm data
                                return Obx(
                                  () =>  InkWell(
                                    onTap: () {
                                      Get.toNamed(MyRoute.admDetail, arguments: data);
                                    },
                                    child: admDetailGridView(
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
                          ),
                        ),
                      );
                    }
                  }),


                ],
              ),
            );
          },
        ));
  }
}

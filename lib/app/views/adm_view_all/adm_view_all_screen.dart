import 'package:flutter/material.dart';
import 'package:administra/widgets/common_appbar.dart';
import 'package:administra/route/my_route.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_grid_view.dart';
import '../../controller/adm_view_all_controller.dart';
class AdmsViewAllScreen extends StatefulWidget {
  final String? title;
  const AdmsViewAllScreen({super.key,  this.title});

  @override
  State<AdmsViewAllScreen> createState() => _AdmsViewAllScreenState();
}

class _AdmsViewAllScreenState extends State<AdmsViewAllScreen> {

  late ThemeData theme;
  AdmViewAllController controller=Get.put(AdmViewAllController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: commonAppBar(image: '', context: context, theme: theme,text: widget.title),

        body:  GetBuilder<AdmViewAllController>(
            init: controller,
            tag: 'adm_DogsCategories',
            // theme: theme,
            builder: (homeController) =>
                Column(
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
                )
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../../route/my_route.dart';
import 'package:get/get.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/common_progress.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_grid_view.dart';
import '../../controller/adm_favourite_controller.dart';

class AdmFavouriteScreen extends StatefulWidget {
  const AdmFavouriteScreen({
    super.key,
  });

  @override
  State<AdmFavouriteScreen> createState() => _AdmFavouriteScreenState();
}

class _AdmFavouriteScreenState extends State<AdmFavouriteScreen> {
  late ThemeData theme;

  AdmFavoriteController controller = Get.put(AdmFavoriteController());
  @override
  void initState() {
    super.initState();
    // theme = Styles.admTheme;
    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
    controller.selectedIndex;

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(
            () => customAppBar(
                image: splashImg,
                context: context,
                theme: theme,
                text: favourite,
                leading: searchIcon,
                trailing: more,
              color: controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
            ), 
          ),
        ),
        body: GetBuilder<AdmFavoriteController>(
          init: controller,
          tag: 'adm_favourite',
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => HorizontalList(
                  padding:  const EdgeInsets.only(left: 15,right: 15),
                            itemCount: controller.listOCategoryAdms.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  controller.selection(index);
                                },
                                child: Container(
                                  height: 42,
                                  padding: EdgeInsets.symmetric(horizontal: GetPlatform.isIOS?12:10,vertical: 10),
                                  decoration: BoxDecoration(
                                    color:
                                    controller.selectedIndex.value == index
                                            ? admColorPrimary
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: controller.selectedIndex.value ==
                                                index
                                            ? controller
                                                    .themeController.isDarkMode
                                                ? Colors.transparent
                                                : Colors.transparent
                                            : controller
                                                    .themeController.isDarkMode
                                                ? admBorderColor
                                                : admBorderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      3.width,
                                      Text(
                                        controller.listOCategoryAdms[index].name
                                            .toString(),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              controller.selectedIndex.value ==
                                                      index
                                                  ? controller.themeController
                                                          .isDarkMode
                                                      ? admWhiteColor
                                                      : admWhiteColor
                                                  : controller.themeController
                                                          .isDarkMode
                                                      ? admWhiteColor
                                                      : admTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                10.height,
                FutureBuilder(
                    future: controller.getAdmsDetailById(controller
                            .listOCategoryAdms.isEmpty
                        ? 100
                        : controller
                            .listOCategoryAdms[controller.selectedIndex.value].id),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(child: commonProgressBar());
                      } else {
                        return Obx(() => controller.admList.isEmpty
                            ? Expanded(
                                child: Center(
                                    child: Text(
                                  'No hay datos disponibles',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Get.isDarkMode
                                              ? admWhiteColor
                                              : admTextColor),
                                )),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 12),
                                  child: GridView.builder(
                                      itemCount: controller.admList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                            crossAxisSpacing: 15,
                                             // mainAxisExtent: MediaQuery.sizeOf(context).height * 0.32
                                            childAspectRatio: MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context).size.height / 1.4
                                                ),
                                          ),
                                      itemBuilder: (context, index) {
                                        final data = controller.admList[index];
                                        return InkWell(
                                          onTap: () {
                                            Get.toNamed(MyRoute.admDetail,
                                                arguments: data);
                                          },
                                          child: Obx(
                                            () =>admDetailGridView(theme, data,
                                                () {
                                             // print("data");
                                                // controller.toggleFavorite(data);
                                                  data.isFavorite.value = !data.isFavorite.value;
                                                  data.isFavorite.value==false?
                                                  customMsgBox(admAddedToFavourites,theme,context):
                                                  customMsgBox(admRemovedFromFavourites,theme,context);


                                                 //  Get.showSnackbar(const GetSnackBar(
                                                 //    backgroundColor: black,
                                                 //    borderRadius:BorderSide.strokeAlignOutside,
                                                 //    snackStyle: SnackStyle.FLOATING,
                                                 //    message: admAddedToFavourites,
                                                 //    snackPosition: SnackPosition.BOTTOM,
                                                 //    duration: Duration(seconds: 2),
                                                 //    margin:  EdgeInsets.all(30),
                                                 //  )):
                                                 //  Get.showSnackbar(
                                                 //      const GetSnackBar(
                                                 //   backgroundColor: black,
                                                 //   borderRadius:BorderSide.strokeAlignOutside,
                                                 //   snackStyle: SnackStyle.FLOATING,
                                                 //   message: admRemovedFromFavourites,
                                                 //   snackPosition: SnackPosition.BOTTOM,
                                                 //   duration: Duration(seconds: 2),
                                                 //   margin:  EdgeInsets.all(30),
                                                 // ));




                                                }, context,data.isFavorite.value?unlike:like ),
                                          ),
                                        );
                                      }),
                                ),
                              ));
                      }
                    })
              ],
            );
          },
        )
    )
    ;
  }

}

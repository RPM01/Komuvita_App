import 'package:flutter/material.dart';
import 'package:administra/widgets/common_appbar.dart';
import 'package:administra/route/my_route.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_grid_view.dart';
import '../../controller/adm_category_controller.dart';
import 'package:get/get.dart';
class AdmsCategoriesScreen extends StatefulWidget {
  const AdmsCategoriesScreen({super.key});

  @override
  State<AdmsCategoriesScreen> createState() => _AdmsCategoriesScreenState();
}

class _AdmsCategoriesScreenState extends State<AdmsCategoriesScreen> {
  late ThemeData theme;
  AdmCategoryController controller=Get.put(AdmCategoryController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(image: searchIcon, context: context, theme: theme,text: controller.name),

        body:  GetBuilder<AdmCategoryController>(
            init: controller,
            tag: 'adm_DogsCategories',
            // theme: theme,
            builder: (homeController) =>
                FutureBuilder(
                    future: controller.getAdmsDetailById(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return commonProgressBar();
                      } else {
                        return Obx(() =>  controller.admList.isEmpty? Expanded(
                          child: Center(child: Text('No Data Available',style: theme.
                          textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700, color: Get.isDarkMode?admWhiteColor:admTextColor ),)),
                        ):
                            GridView.builder(
                                padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
                            itemCount: controller.admList.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                // crossAxisSpacing: 10,

                              crossAxisSpacing: 16,
                              // mainAxisExtent: MediaQuery.sizeOf(context).height * 0.32
                              childAspectRatio: MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height / 1.3
                                  ),
                            ),
                            itemBuilder: (context, index) {
                              final data = controller.admList[index];
                              return InkWell(
                                onTap: (){
                                  Get.toNamed(MyRoute.admDetail,arguments: data);
                                },
                                child: Obx(
                                  () => admDetailGridView(theme,data,(){
                                    controller.toggleFavorite(data);
                                    data.isFavorite.value==false?

                                    customMsgBox(admRemovedFromFavourites,theme,context):
                                    customMsgBox(admAddedToFavourites,theme,context);
                                  },context,data.isFavorite.value?like:unlike),
                                ),
                              );

                            }));
                      }
                    })
        )
    );
  }
}

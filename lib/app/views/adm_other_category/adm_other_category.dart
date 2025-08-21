import 'package:flutter/material.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:get/get.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../../../route/my_route.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/common_progress.dart';
import '../../controller/adm_other_category.dart';
import '../../modal/adms_home_modal.dart';

class AdmOtherCategoryScreen extends StatefulWidget {
  const AdmOtherCategoryScreen({super.key});

  @override
  State<AdmOtherCategoryScreen> createState() => _AdmOtherCategoryScreenState();
}

class _AdmOtherCategoryScreenState extends State<AdmOtherCategoryScreen> {
  late ThemeData theme;
  late int selectedIndex;
  AdmOtherAdmCategoryController controller =
      Get.put(AdmOtherAdmCategoryController());
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(image: '', context: context, theme: theme, text: ''),
      body: FutureBuilder(
          future: controller.getCategoryAdmsDetail(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return commonProgressBar();
            } else {
              return GridView.builder(
                  padding: const EdgeInsets.all(18.0),
                  itemCount: controller.listOCategoryAdms.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 132),
                  itemBuilder: (context, index) {
                    final AdmsModal data= controller.listOCategoryAdms[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(MyRoute.admDetail,
                            arguments: data);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          //color: Colors.yellow,
                          border: Border.all(
                              width: 2,
                              color: Get.isDarkMode
                                  ? darkGreyColor
                                  : greyColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: commonCacheAdmImageWidget(data.image[0], 60,fit: BoxFit.cover,),
                            ),
                            18.height,
                            Text(
                              data.name
                                  .toString(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

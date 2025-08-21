import 'package:flutter/material.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../../route/my_route.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../../widgets/find_match_widget.dart';
import '../../controller/find_match_screen_controller.dart';

class AdmFindMatchScreen extends StatefulWidget {
  const AdmFindMatchScreen({super.key});

  @override
  State<AdmFindMatchScreen> createState() => _AdmFindMatchScreenState();
}

class _AdmFindMatchScreenState extends State<AdmFindMatchScreen> {
  late ThemeData theme;
  late int selectedIndex;
  AdmFindMatchController controller = Get.put(AdmFindMatchController());
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      bottomNavigationBar: buildContinueButton(() {
        Get.toNamed(MyRoute.breedScreen);
      }),
      appBar: appbarWithProgressIndicator('2/4', theme, 0.6),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              findsMatch,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            10.height,
            Text(
              findsMatchDes,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            25.height,
            Expanded(
              child: GridView.builder(
                  itemCount: controller.data.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 132),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          //color: Colors.yellow,
                          border: Border.all(
                            width: 2,
                              color: selectedIndex == index
                                  ? admColorPrimary
                                  : Get.isDarkMode
                                  ? darkGreyColor
                                  : greyColor,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            commonCacheAdmImageWidget( controller.data.elementAt(index)['image'],60,width: 60
                            ),

                            18.height,
                            Text(
                              controller.data.elementAt(index)['name'],
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

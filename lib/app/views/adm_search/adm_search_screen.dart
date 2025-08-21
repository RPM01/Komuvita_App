import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/widgets/common_appbar.dart';
import 'package:administra/widgets/common_button.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/custum_textfeild.dart';

import 'package:administra/constant/adm_images.dart';

import '../../controller/adm_search_screen_controller.dart';

class AdmSearchScreen extends StatefulWidget {
  const AdmSearchScreen({super.key});

  @override
  State<AdmSearchScreen> createState() => _AdmSearchScreenState();
}

class _AdmSearchScreenState extends State<AdmSearchScreen> {
  late ThemeData theme;

  late int selectedIndex;
  late int selectedGender;
  late int selectedSize;
  late int selectedAge;
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedIndex = 0;
    selectedGender = 0;
    selectedSize = 0;
    selectedAge = 0;
  }

  AdmSearchScreenController controller = Get.put(AdmSearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: PrimaryButton(
        text: searchText,
        onTap: () {
          Get.toNamed(MyRoute.admSearchResult);
        },
      ),
      appBar: commonAppBar(
          image: '', context: context, theme: theme, text: admSearch,),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                  15.height,
                  Obx(() =>    CustomTextField(
                    textEditingController: controller.searchController.value,
                    hintText: searchHere,
                    obscureText: false,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        search,
                        colorFilter: ColorFilter.mode(
                            Get.isDarkMode ? admWhiteColor : admTextColor,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),),
                  15.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowText(String leading, trailing, ThemeData theme) {
    return Row(
      children: [
        Text(leading,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            )),
        9.width,
        Text(trailing,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
            )),
      ],
    );
  }
}

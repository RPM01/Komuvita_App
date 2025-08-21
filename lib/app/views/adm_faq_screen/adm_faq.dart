import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/constant/adm_images.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/custum_textfeild.dart';
import '../../controller/adm_faq_controller.dart';
import '../../modal/adm_faq_modal.dart';

class AdmFaqScreen extends StatefulWidget {
  const AdmFaqScreen({super.key});

  @override
  State<AdmFaqScreen> createState() => _AdmFaqScreenState();
}

class _AdmFaqScreenState extends State<AdmFaqScreen> {
  late ThemeData theme;

  final AdmFaqController controller = Get.put(AdmFaqController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? admDarkPrimary : admLightGrey,
      appBar: commonAppBar(
          image: '', context: context, theme: theme, text: faqText),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                textEditingController: controller.searchController.value,
                hintText: searchText,
                obscureText: false,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SvgPicture.asset(
                    searchIcon,
                    height: 10,
                    width: 10,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Get.isDarkMode ? admDarkColorGrey : admLightGreyColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              15.height,
              HorizontalList(
                  itemCount: controller.detail.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () =>  InkWell(
                        onTap: () {
                          controller.selection(index);
                        },
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: controller.selectedIndex.value == index
                                ? admColorPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: controller.selectedIndex.value == index
                                    ? Colors.transparent
                                    : Get.isDarkMode
                                        ? admDarkLightColor
                                        : admBorderColor),
                          ),
                          child: Center(
                            child: Text(
                              controller.detail[index],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: controller.selectedIndex.value == index
                                    ? admWhiteColor
                                    : Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              15.height,

              _buildFaqList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.detail.length,
      itemBuilder: (context, index) {
        return Obx(() {
          if (controller.selectedIndex.value == index) {
            return _buildSelectedFaqList(index);
          } else {
            return const SizedBox();
          }
        });
      },
    );
  }

  Widget _buildSelectedFaqList(int index) {
    List<AdmFaqData> faqs = [];

    switch (index) {
      case 0:
        faqs = controller.generalFaqs;
        break;
      case 1:
        faqs = controller.account;
        break;
      case 2:
        faqs = controller.service;
        break;
      case 3:
        faqs = controller.adoption;
        break;
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return  _buildFaqView(faq);
      },
    );
  }

  Widget _buildFaqView(AdmFaqData faq) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Get.isDarkMode ? greyColor : admGreyTextColor,
              collapsedIconColor: Get.isDarkMode ? greyColor : admGreyTextColor,
              onExpansionChanged: (value) {
                controller.toggleExpansion(faq);
              },
              title: Text(
                faq.question,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Get.isDarkMode ? admDarkLightColor : greyColor,
                        thickness: 2,
                      ),
                      10.height,
                      Text(
                        faq.answer,
                        style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode ? admLightGrey : admDarkGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

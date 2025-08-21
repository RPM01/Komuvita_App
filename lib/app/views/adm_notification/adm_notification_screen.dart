import 'package:flutter/material.dart';
import 'package:administra/widgets/common_appbar.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../controller/adm_notification_controller.dart';
import 'package:get/get.dart';

import '../../modal/adm_notification_modal.dart';

class AdmNotificationScreen extends StatefulWidget {
  const AdmNotificationScreen({super.key});

  @override
  State<AdmNotificationScreen> createState() => _AdmNotificationScreenState();
}

class _AdmNotificationScreenState extends State<AdmNotificationScreen> {
  late ThemeData theme;
  AdmNotificationController controller = Get.put(AdmNotificationController());
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
        appBar: commonAppBar(
            image: setting,
            context: context,
            theme: theme,
            text: notificationText),
        body: GetBuilder<AdmNotificationController>(
          init: controller,
          tag: 'adm_Notification',
          // theme: theme,
          builder: (controller) => Padding(
            padding: const EdgeInsets.all(15.0),
            child:  Obx(() {
              return ListView.builder(
                itemCount: controller.listOfNotification.length,
                shrinkWrap: true,
                //physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, mainIndex) {

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(controller.listOfNotification[mainIndex].date,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600, color: darkGreyColor),
                          ),
                          10.width,
                          Expanded(
                            child: Divider(
                              color: Get.isDarkMode ? darkGreyColor : greyColor,
                            ),
                          ),
                        ],
                      ),
                      23.height,
                      20.height,
                      ListView.builder(
                        itemCount: controller.listOfNotification[mainIndex].messagesList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {

                          final NotificationModal notification=controller.listOfNotification[mainIndex].messagesList[index];
                          return notificationView(notification,controller.listOfNotification[mainIndex].date=="Today"?true:false);
                        },)
                    ],
                  );
                },);

            }),


            ),
          ),
        );
  }

  Widget notificationView(NotificationModal notification,bool show) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            //color: Colors.yellow,
              border: Border.all(
                  color: Get.isDarkMode ? admDarkLightColor : greyColor),
              borderRadius: BorderRadius.circular(70)),
          child: Center(
            child:  commonCacheAdmImageWidget(notification.icon,
                24,  color: Get.isDarkMode ? admWhiteColor : admTextColor ),


          ),
        ),
        13.width,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(""),
              12.height,
              Text(""),
              12.height,
              Text(""),
              25.height,
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Visibility(
              visible: show,
              child: const CircleAvatar(
                backgroundColor: admColorPrimary,
                radius: 4,
              ),
            ),
            2.width,
            Icon(
              Icons.arrow_forward_ios,
              size: 22,
              color: Get.isDarkMode ?admWhiteColor:admTextColor,
            ),
          ],
        )
      ],
    );
  }
}

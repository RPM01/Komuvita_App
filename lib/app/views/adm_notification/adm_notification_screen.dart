import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:administra/widgets/common_appbar.dart';
import 'package:intl/intl.dart';
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
          builder: (controller) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  17.height,
                  Text("Notificaciones",style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width*0.035,
                    color: Color.fromRGBO(6,78,116,1),
                  )),

                  17.height,
                  FutureBuilder(
                    future:controller.getNotificationDetailTrue(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("No hay notificaciones, por el momento"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No hay notificaciones, por el momento"),);
                      }
                      final events = snapshot.data!;
                      //debugPrint(events.toString());
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.65,
                          child: LayoutBuilder(
                              builder: (context, constraints) {
                                final cardWidth = constraints.maxWidth * 0.9;
                                final cardHeight = constraints.maxHeight * 0.65;
                                final titleFontSize = constraints.maxWidth * 0.035;
                                final subtitleFontSize = constraints.maxWidth * 0.03;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight*0.3,
                                      child: Card(
                                          elevation: 3,
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          color: event["pv_estado_descripcion"].toString() != "Leída" ? Colors.white:Color.fromRGBO(206,228,255,1),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(12),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"])),style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                fontSize: constraints.maxWidth * 0.03,
                                                              ),maxLines: 2,
                                                              ),
                                                            ],
                                                          ),
                                                          AutoSizeText(event["pn_notificacion_descripcion"].toString(),
                                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color.fromRGBO(6, 78, 116, 1),
                                                              fontSize: constraints.maxWidth < 300 ?cardWidth * 0.02:cardWidth * 0.08,
                                                            ),maxLines: 3,minFontSize: cardWidth * 0.095.floor(),),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    );
                                  },
                                );
                              }
                          )
                      );
                    },
                  ),
                  17.height,
                ],
              ),
            ),
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

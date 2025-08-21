import 'package:flutter/material.dart';

import 'package:administra/constant/adm_colors.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_strings.dart';
import '../../../widgets/common_progress.dart';
import '../../modal/adm_chat_modal.dart';

class AdmSenderView extends StatelessWidget {
  final AdmMessageData messageData;
  final ThemeData theme;

  const AdmSenderView(
      {Key? key, required this.messageData, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
        if (messageData.image.isNotEmpty)
          Container(
            height: 192,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? admDarkBorderColor : admLightGrey),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child:  commonCacheAdmImageWidget(  messageData.image.toString(),140,width: 140),

                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        mochi,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        chatTime,
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: admDarkColorGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (messageData.message.isNotEmpty)
          Flexible(
            flex: 85,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 1.0, bottom: 9.0),
              child: Container(
                margin: const EdgeInsets.only(
                    left: 5.0, right: 8.0, top: 8.0, bottom: 0.0),
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: admColorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            messageData.message,
                            textAlign: TextAlign.left,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: admWhiteColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      // margin: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                      child: Text(
                        chatTime,
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500, color: admWhiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
          ),
      ],
    );
  }
}

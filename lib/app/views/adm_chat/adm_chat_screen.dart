import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/app/views/adm_chat/adm_receiver_view.dart';
import 'package:administra/app/views/adm_chat/adm_sender_view.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_images.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_progress.dart';
import '../../../widgets/custum_textfeild.dart';
import '../../controller/adm_chat_screen_controller.dart';
import '../../modal/adm_chat_modal.dart';

class AdmChatScreen extends StatefulWidget {
  final String? name;
  const AdmChatScreen({super.key, this.name});

  @override
  State<AdmChatScreen> createState() => _AdmChatScreenState();
}

class _AdmChatScreenState extends State<AdmChatScreen> {
  AdmChatController controller = Get.put(AdmChatController());
  late ThemeData theme;
  late int selectedButtonIndex;
  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
    selectedButtonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              widget.name.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(MyRoute.admVideoCall);
                      },
                      icon: SvgPicture.asset(
                        videoCall,
                        height: 28,
                        width: 28,
                        colorFilter: ColorFilter.mode(
                            Get.isDarkMode ? admWhiteColor : admTextColor,
                            BlendMode.srcIn),
                      )),
                  10.width,
                  IconButton(
                      onPressed: () {
                        Get.toNamed(MyRoute.admVoiceCall);
                      },
                      icon: SvgPicture.asset(call,
                          height: 28,
                          width: 28,
                          colorFilter: ColorFilter.mode(
                              Get.isDarkMode ? admWhiteColor : admTextColor,
                              BlendMode.srcIn)))
                ],
              ),
            )
          ],
        ),
        body: GetBuilder<AdmChatController>(
          init: controller,
          tag: 'adm_Chats',
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() {
                      if (controller.messageList.isEmpty) {
                        return commonProgressBar(); // Show the progress bar while data is being fetched.
                      } else {
                        return ListView.builder(
                          itemCount: controller.messageList.length,
                          itemBuilder: (context, index) {
                            AdmMessageData message =
                                controller.messageList[index];
                            return (message.isSender)
                                ? AdmSenderView(
                                    messageData: message,
                                    theme: theme,
                                  )
                                : AdmReceiverView(
                                    messageData: message,
                                    theme: theme,
                                  );
                          },
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: controller
                              .scrollController, // Add scroll controller for auto-scroll
                        );
                      }
                    }),
                  ),
                  _buildTextComposer()
                ],
              ),
            );
          },
        ));
  }

  _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: CustomTextField(
                textInputAction: TextInputAction.send,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(smileEmoji,
                      colorFilter: ColorFilter.mode(
                          Get.isDarkMode ? admWhiteColor : admTextColor,
                          BlendMode.srcIn)),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(document,
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(
                          Get.isDarkMode ? admWhiteColor : admTextColor,
                          BlendMode.srcIn)),
                ),
                textEditingController: controller.textController,
                hintText: 'Mensaje..',
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  controller.sendMessage(controller.textController.text);
                },
                child: SvgPicture.asset(
                  send,
                  height: 50,
                  width: 56,
                ),
              ),
            ),
          ]))
        ],
      ),
    );
  }
}

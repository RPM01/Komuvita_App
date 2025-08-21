import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../modal/adm_chat_modal.dart';

class AdmChatController extends GetxController {
  RxList<AdmMessageData> messageList = <AdmMessageData>[].obs;
  TextEditingController textController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMessages();
  }

  Future<List<AdmMessageData>> getMessages() async {
    messageList.clear();

    String jsonData = await rootBundle
        .loadString("assets/administra/data/adm_chat_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['adm_message_list'];
    for (int i = 0; i < jsonArray.length; i++) {
      messageList.add(AdmMessageData.fromJson(jsonArray[i]));
    }

    return messageList;
  }
  ScrollController scrollController = ScrollController();

  void sendMessage(String messageContent) {
    if (messageContent.isNotEmpty) {
      AdmMessageData newMessage = AdmMessageData(
        id: messageList.length + 1,
        message: messageContent,
        image: '',
        isSender: true,
        images: [],
      );
      messageList.add(newMessage);
      textController.clear();

      // Scroll to the bottom after sending a message
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    }
  }



}

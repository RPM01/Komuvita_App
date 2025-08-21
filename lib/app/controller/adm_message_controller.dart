import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import '../modal/adm_message_modal.dart';


class AdmMessageController extends GetxController{

  final ThemeController themeController = Get.put(ThemeController());

  RxList<AdmMessageModal> listOfChats = <AdmMessageModal>[].obs;
  RxList<AdmMessageModal> listOfCalls = <AdmMessageModal>[].obs;





  Future<List<AdmMessageModal>> getChatsDetail() async {
    String jsonData = await rootBundle.loadString("assets/administra/data/chats.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['chat_list'];
    listOfChats.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfChats.add(AdmMessageModal.fromJson(jsonArray[i]));
    }

    return listOfChats;
  }

  Future<List<AdmMessageModal>> getCallsDetail() async {
    String jsonData = await rootBundle.loadString("assets/administra/data/calls.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['call_list'];
    listOfCalls.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfCalls.add(AdmMessageModal.fromJson(jsonArray[i]));
    }

    return listOfCalls;
  }



}
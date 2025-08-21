import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../modal/adms_home_modal.dart';

class AdmCategoryController extends GetxController{


  RxList<AdmsModal> admList = <AdmsModal>[].obs;

  final int id = Get.arguments['id'] ?? 0;
  final String name = Get.arguments['name'] ?? '';

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }



  Future<List<AdmsModal>> getAdmsDetailById() async {
    admList.clear();
    await Future.delayed(const Duration(seconds: 1));
    String jsonData = await rootBundle.loadString("assets/administra/data/adms_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['adm_list'];

    List<AdmsModal> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(AdmsModal.fromJson(jsonArray[i]));
    }
    if (id == 100) {
      admList.addAll(list);
    } else {
      for (int j = 0; j < list.length; j++) {
        if (list[j].id == id) {
          admList.add(list[j]);
        }
      }
    }

    return admList;
  }



}
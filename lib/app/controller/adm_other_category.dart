
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../modal/adms_home_modal.dart';




class AdmOtherAdmCategoryController extends GetxController {
  RxList<AdmsModal> listOCategoryAdms = <AdmsModal>[].obs;

  Future<List<AdmsModal>> getCategoryAdmsDetail() async {
    listOCategoryAdms.clear();
    String jsonData = await rootBundle.loadString("assets/administra/data/other_category.json");
    dynamic data = json.decode(jsonData);

    List<dynamic> jsonArray = data['other_category'];

    listOCategoryAdms.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOCategoryAdms.add(AdmsModal.fromJson(jsonArray[i]));
    }

    return listOCategoryAdms;
  }

}

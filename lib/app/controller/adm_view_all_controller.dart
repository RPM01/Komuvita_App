import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../modal/adms_category.dart';
import '../modal/adms_home_modal.dart';

class AdmViewAllController extends GetxController{


  RxList<AdmsModal> admList = <AdmsModal>[].obs;
  RxList<AdmsCategory> listOCategoryAdms = <AdmsCategory>[].obs;
  RxInt selectedIndex = 0.obs;


  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }

  void selection(int index) {
    selectedIndex.value = index;
    getAdmsDetailById(listOCategoryAdms[index].id);  // Fetch adms based on selected category
    update();
  }

  // Future<List<AdmsModal>> getAdmsDetail() async {
  //   admList.clear();
  //   String jsonData = await rootBundle
  //       .loadString("assets/administra/data/near_adms.json");
  //   dynamic data = json.decode(jsonData);
  //   List<dynamic> jsonArray = data['near_adms_list'];
  //
  //
  //   for (int i = 0; i < jsonArray.length; i++) {
  //     admList.add(AdmsModal.fromJson(jsonArray[i]));
  //   }
  //
  //   return admList;
  // }
  @override
  void onReady() {
    getCategoryAdmsDetail().then((categories) {
      if (categories.isNotEmpty) {
        // Automatically select the first category or a default category like "All"
        selection(0); // Fetch adms for the first category by default
      }
    });
    super.onReady();
  }

  Future<List<AdmsCategory>> getCategoryAdmsDetail() async {
    String jsonData = await rootBundle
        .loadString("assets/administra/data/category_adm.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category_adms_list'];

    // listOCategoryAdms.add(AdmsCategory(
    //     id: 100, name: 'All', image: ''));

    for (int i = 0; i < jsonArray.length; i++) {
      listOCategoryAdms.add(AdmsCategory.fromJson(jsonArray[i]));
    }

    return listOCategoryAdms;
  }




  Future<List<AdmsModal>> getAdmsDetailById(int? id) async {
    admList.clear(); // Clear the list before adding new items
    // await Future.delayed(const Duration(seconds: 1));

    String jsonData = await rootBundle.loadString("assets/administra/data/adms_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['adm_list'];

    List<AdmsModal> list = jsonArray.map((json) => AdmsModal.fromJson(json)).toList();

    // Filter adms by the selected category ID
    for (AdmsModal adm in list) {
      if (adm.id == id) {
        admList.add(adm);
      }
    }

    update(); // Notify the UI about the data change
    return admList;
  }


}
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:administra/adm_theme/theme_controller.dart';
import '../modal/adms_category.dart';
import '../modal/adms_home_modal.dart';

class AdmFavoriteController extends GetxController{
  final ThemeController themeController = Get.put(ThemeController());
  RxList<AdmsCategory> listOCategoryAdms = <AdmsCategory>[].obs;

  RxList<AdmsModal> admList = <AdmsModal>[].obs;


  RxInt selectedIndex = 0.obs;


  void selection(int index) {
    selectedIndex.value = index;
    update();
  }

  @override
  void onReady() {
    getFavouriteList();
    super.onReady();
  }
  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }



  Future<List<AdmsCategory>> getFavouriteList() async {
    String jsonData = await rootBundle.loadString("assets/administra/data/category_adm.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category_adms_list'];

    listOCategoryAdms.add(AdmsCategory(
        id: 100, name: 'Todos', image: ''));

    for (int i = 0; i < jsonArray.length; i++) {
      listOCategoryAdms.add(AdmsCategory.fromJson(jsonArray[i]));
    }

    return listOCategoryAdms;
  }



  Future<List<AdmsModal>> getAdmsDetailById(int? id) async {
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
import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant/adm_strings.dart';
import '../modal/adms_home_modal.dart';

class AdmOwnerDetailController extends GetxController{



  RxList<AdmsModal> listOfAdms = <AdmsModal>[].obs;
  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
  List privacyPolicy = [
    {'title': animalRescue, 'des': addressDes},
    {'title': adoptionApplication, 'des': adoptionApplicationDes},
    {'title': meedAndGreet, 'des': meedAndGreetDes},
    {'title': homeVisit, 'des': homeVisitDes},
    {'title': adoptionFee, 'des': adoptionFeeDes},
  ];



  Future<List<AdmsModal>> getSearchAdmsDetail() async {
    String jsonData = await rootBundle.loadString("assets/administra/data/owner_detail.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['adms_list'];
    listOfAdms.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfAdms.add(AdmsModal.fromJson(jsonArray[i]));
    }

    return listOfAdms;
  }





}
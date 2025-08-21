import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../route/my_route.dart';
import '../../constant/adm_strings.dart';
import '../modal/adm_countries.dart';

class AdmFinalStepController extends GetxController {
  TextEditingController nameController = TextEditingController(text: 'John Doe');
  TextEditingController phoneController = TextEditingController(text: '40352210');
  final formKey = GlobalKey<FormState>();

  var errorTextMobile = ''.obs;
  final phoneFieldFocused = false.obs;
  FocusNode f1 = FocusNode();
  @override
  void onInit() {
    super.onInit();
    getCountryList();
  }

  var selectedCountryCode =
      AdmCountries(code: 'GT', name: 'Guatemala', dialCode: '+502').obs;
  RxList<AdmCountries> listOfCountries = <AdmCountries>[].obs;

  String? validateName(String? value) {
    String pattern =
        r"^[a-zA-Z\s]+$"; // Pattern to match alphabetic characters only
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return admEmptyName;
    } else if (!regex.hasMatch(value)) {
      return admValidationName;
    } else {
      return null;
    }
  }

  String validatePhoneNumber(String phoneNumber) {
    const int minDigits = 8;
    const int maxDigits = 15;

    String numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    int phoneNumberLength = numericPhoneNumber.length;
    if (phoneNumberLength == 0) {
      return admEmptyPhone;
    }
    if (phoneNumberLength < minDigits) {
      return admEmptyPhoneTooShort;
    } else if (phoneNumberLength > maxDigits) {
      return admEmptyPhoneTooLong;
    }

    return '';
  }

  Future<List<AdmCountries>> getCountryList() async {
    listOfCountries.clear();
    String jsonData = await rootBundle
        .loadString("assets/administra/data/countries.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['country_list'];

    for (int i = 0; i < jsonArray.length; i++) {
      listOfCountries.add(AdmCountries.fromJson(jsonArray[i]));
    }
    return listOfCountries;
  } 

  void checkRegister() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return ;
    }
    Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,);
  }
}

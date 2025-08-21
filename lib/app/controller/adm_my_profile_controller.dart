import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constant/adm_colors.dart';
import '../../constant/adm_strings.dart';
import '../modal/adm_countries.dart';

class MyProfileController extends GetxController {

  TextEditingController nameController = TextEditingController(text: 'John Doe');
  TextEditingController emailController = TextEditingController(text: 'admin@administra.com.gt');
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: '40354110');

  FocusNode f1 = FocusNode();
  final formKey = GlobalKey<FormState>();
  var errorTextMobile = ''.obs;
  final phoneFieldFocused = false.obs;

  var selectedCountryCode = AdmCountries(code: 'GT', name: 'Guatemala', dialCode: '+502').obs;



  @override
  void onInit() {
    super.onInit();
    getCountryList();
  }


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
  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return emailPattern;
    } else {
      return null;
    }
  }
  String validatePhoneNumber(String phoneNumber) {
    const int minDigits = 7;
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

  RxList<AdmCountries> listOfCountries = <AdmCountries>[].obs;

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

  var selectedDate = ''.obs;

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:  const ColorScheme.light().copyWith(
              primary: admColorPrimary, // Change the primary color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      selectedDate.value = formattedDate;
      //FocusScope.of( context ).requestFocus(FocusNode());
    } else {
      if (kDebugMode) {
        print('No date selected');
      }
    }
  }




}

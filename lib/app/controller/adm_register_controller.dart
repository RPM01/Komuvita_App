import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/adm_strings.dart';




class RegisterController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;


  //final loading = RxBool(false);
  final isChecked = true.obs;
  final passwordVisible = true.obs;
  final formKey = GlobalKey<FormState>();

  final emailFieldFocused = false.obs;
  final passwordFieldFocused = false.obs;
  final isButtonEnabled = false.obs;


  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void updateButtonState() {
    isButtonEnabled.value = emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty&&isChecked.value==true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController.value.addListener(updateButtonState);
    passwordController.value.addListener(updateButtonState);

    updateButtonState();
  }
  @override
  void onClose() {
    super.onClose();
    emailController.value.dispose();
    passwordController.value.dispose();
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty ) {
      return enterYourEmail;
    }
    if(!regex.hasMatch(value)){
      return emailPattern;

    }
    else {
      return null;
    }
  }

  String? validatePassword(String? value1) {
    String pattern =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$";
    RegExp regex2 = RegExp(pattern);
    if (value1 == null || value1.isEmpty) {
      return requiredText;
    }
    if (value1.length < 8) {
      return passwordLength;
    }
    if (!regex2.hasMatch(value1)) {
      return passwordValidation;
    }
    return null;
  }


}

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant/adm_strings.dart';
import '../../route/my_route.dart';
import 'adm_login_controller.dart';
import 'package:http/http.dart' as http;




class PasswordCreationController extends GetxController {
  final oldPasswordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  final confirmPasswordFocusNode = FocusNode();

  final isChecked = false.obs;

  final oldPasswordVisible = true.obs;
  final newPasswordVisible = true.obs;
  final confirmPasswordVisible = true.obs;
  final formKey = GlobalKey<FormState>();

  final oldPasswordFocused = false.obs;
  final newPasswordFocused = false.obs;
  final confirmPasswordFocused = false.obs;

  void oldPasswordVisibility() {
    oldPasswordVisible.value = !oldPasswordVisible.value;
  }
  void newPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void confirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  Future<void>cambioPassWord() async{
    debugPrint("CambioPassWord Prueba");
    String deviceName = "";
    String deviceID = "";
    String newpasswordControllerText = newPasswordController.value.text;
    String confirmpasswordControllerText = confirmPasswordController.value.text;
    String errorMensaje = "Falla de coneccino";
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

    String? usuario = prefs.getString("correo");

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceID = build.id;
      deviceName = "Android";
      debugPrint("Android: $deviceID");
    }
    else if (Platform.isIOS) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceID = build.id;
      deviceName = "Iphone";
      debugPrint("Iphone: $deviceID");
    }

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/administracion/usuarios/cambiar_clave"
          "http://api.komuvita.com/administracion/usuarios/cambiar_clave"
      );
      Map body = {
        "autenticacion":
        {
          "pv_usuario": usuario,
          "pv_clave": oldPasswordController.value.text,
          "pv_origen": "APP",
          "pv_identificador":deviceID
        },
        "parametros":
        {
          "pv_clave_nueva": newPasswordController.value.text
        }
      };
      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint(response.body.toString());
      if(response.statusCode == 200)
      {
        if(json["resultado"]["pn_error"] == 0)
        {

          Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,);
        }
        else{
          errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context)
          {
            return SimpleDialog(
              title: Text(errorMensaje),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          }
      );
    }
  }

  String? validatePassword(String? value1) {
    String pattern =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
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
  String? validateRepeatPassword(String? value) {
    final password = newPasswordController.value.text;
    if (value != password) {
      return "Las contraseñas no coinciden";
    }
    return null;
  }

}

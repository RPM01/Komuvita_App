import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant/adm_strings.dart';
import 'package:http/http.dart' as http;
import '../../route/my_route.dart';
import 'Dio_Controller.dart';
import 'adm_login_controller.dart';


class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController().obs;


  final formKey = GlobalKey<FormState>();

  final emailFieldFocused = false.obs;


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

  Future<void>resetPassword() async{
    debugPrint("ResestPass Test");
    String deviceName = "";
    String deviceID = "";
    String emailControllerText = emailController.value.text;

    String errorMensaje = "Falla de coneccino";
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/administracion/usuarios/restablecer_clave"
          "$baseUrl/administracion/usuarios/restablecer_clave"
      );
      Map body = {
        "autenticacion":
        {
          "pv_usuario": emailControllerText,
        }
      };
      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {

        if(json["resultado"]["pn_error"] == 0)
        {
          debugPrint(json["resultado"]["pn_tiene_datos"].toString());

          prefs.setString("correo", emailControllerText);
          Get.toNamed(MyRoute.passwordCreation);
          //Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,);
          //Get.toNamed(MyRoute.otpCodeScreen);
        }
        else{
          errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offAllNamed(MyRoute.loginScreen);
      }
      showDialog(
          context: Get.context!,
          builder: (context)
          {
            return SimpleDialog(
              title: Text(errorMensaje),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          }
      );
    }
  }

  void msgxToast(String msxg){

    Fluttertoast.showToast(
      msg: msxg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 40,
    );
  }
}

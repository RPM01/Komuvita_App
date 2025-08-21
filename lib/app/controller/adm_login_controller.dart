import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant/adm_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:developer'as devLog;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../route/my_route.dart';
import 'dart:convert';

import 'adm_home_controller.dart';

List<int> empresasIdsSet = [];
List<String> empresasNombresSet = [];
List<String> empresasPropiedadSet = [];


class LoginController extends GetxController {
  AdmHomeController homeController = Get.put(AdmHomeController());
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final ThemeController themeController = Get.put(ThemeController());

  //final loading = RxBool(false);
  var isChecked= false.obs;
  final passwordVisible = true.obs;
  final formKey = GlobalKey<FormState>();

  final emailFieldFocused = false.obs;
  final passwordFieldFocused = false.obs;

  final isButtonEnabled = false.obs;




  Future<void> setRememberMe(String email, bool recuerdame) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Recuerdame", recuerdame);
    if (recuerdame) {
      await prefs.setString("correo", email);
    }
  }

   Future<void> getUserInfoB() async {
    final prefs = await SharedPreferences.getInstance();
    bool recuerdaMe = prefs.getBool("Recuerdame") ?? false;
    isChecked.value = recuerdaMe;

    if (recuerdaMe) {
      emailController.value.text = prefs.getString("correo") ?? '';
    }
  }



    Future<void>LogIn() async{
    debugPrint("*********************");
    String deviceName = "";
    String deviceID = "";
    String emailControllerText = emailController.value.text;
    String passwordControllerText = passwordController.value.text;
    String errorMensaje = "Falla de coneccino";
    List<String> myStringList = [];
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

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
      var url = Uri.parse("https://apidesa.komuvita.com/administracion/usuarios/login");
      Map body = {
        "autenticacion":
        {
          "pv_usuario": emailControllerText,
          "pv_clave": passwordControllerText,
          "pv_origen": "APP",
          "pv_identificador":deviceID
        }
      };
      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Info Login");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint(response.body.toString());


      if(response.statusCode == 200)
      {
        if(json["resultado"]["pn_error"] == 0)
          {

            debugPrint("Contraseña correcta");
            prefs.setString("Token", json["datos"]["pv_token"].toString());
            prefs.setString("Empresa", json["datos"]["pl_empresas"][0][0]["pn_empresa"].toString());
            prefs.setString("correo",emailControllerText);
            prefs.setString("intruciones de pago",json["datos"]["pl_empresas"][0][0]["pv_instrucciones_pago"].toString());
            prefs.setString("NombreUser",json["datos"]["pv_usuario_nombre"].toString());
            //prefs.setString("UserCode",json["datos"]["pv_token"].toString());

            final empresasList = json["datos"]["pl_empresas"] as List;

            debugPrint(empresasList.toString());
            final flatList = empresasList.expand((e) => e).toList();
            final List<int> empresasIds = flatList.map((e) => e["pn_empresa"] as int).toList();
            final List<String> empresasNombres = flatList.map((e) => e["pv_empresa_nombre"] as String).toList();
            final List<String> empresasPropiedad = flatList.map((e) => e["pv_propiedad_tipo"] as String).toList();


            empresasIdsSet = empresasIds;
            empresasNombresSet = empresasNombres;
            empresasPropiedadSet = empresasPropiedad;
            GestionTickets1();

            if(json["datos"]["pn_clave_vencida"] == 1)
              {
                msgxToast("Su contraseña se encuentra vencida");

                Get.toNamed(MyRoute.forgotPasswordScreen);
              }
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
                contentPadding: EdgeInsets.all(20),
                children: [Text(e.toString())],
              );
            }
      );
    }
  }

  Future<List<Map<String, dynamic>>>GestionTickets1()async
  {
    debugPrint("**********G1***********");

    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/tickets/propiedades_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Objetos Perdidos");
      //debugPrint(response.body.toString());
      debugPrint("clientes");
      debugPrint(json["datos"][0]["pv_cliente"].toString());
      prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());
      debugPrint("Propiedad");
      prefs.setString("propiedad", json["datos"][0]["pn_propiedad"].toString());
      debugPrint(json["datos"][0]["pv_propiedad"].toString());
      debugPrint("Tickest100");
      debugPrint(response.body.toString());
      if(response.statusCode == 200)

      {
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          Get.offNamedUntil(MyRoute.home,(route) => route.isFirst,);
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      //Get.back();
      debugPrint(e.toString());
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
    throw Exception("Error en conexión");
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void updateButtonState() {
    isButtonEnabled.value = emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty;

  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController.value.addListener(updateButtonState);
    passwordController.value.addListener(updateButtonState);
    updateButtonState();
    getUserInfoB();
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

    if (!regex2.hasMatch(value1)) {
      return passwordValidation;
    }
    return null;
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
    fontSize: 20,
  );
}
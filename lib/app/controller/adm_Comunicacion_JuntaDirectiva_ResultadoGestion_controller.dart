import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api_Clases/class_Document5.dart';
import '../../api_Clases/class_RentasVentas5.dart';
import '../../api_Clases/class_Reservas5.dart';
import '../../api_Clases/class_Tickets5.dart';
import '../../route/my_route.dart';
import '../modal/adms_ImportanInfo.dart';
import '../modal/adms_category.dart';
import '../modal/adms_home_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'as devLog;

import 'Dio_Controller.dart';
import 'adm_login_controller.dart';



class AdmComunicacionJuntaDirectivaResultadoGestionController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}


class ComunicacionJuntaDirectivaFinancieraClass
{
  String informacionFinanciera="";
  String criterio="";

  ComunicacionJuntaDirectivaFinancieraClass(this.informacionFinanciera,this.criterio);

  Future<List<Map<String, dynamic>>>ColumicacionesListadosK5()async
  {
    debugPrint("**********K5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("Tickets!!!");
    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestiones_listado");
          "$baseUrl/portal/juntadirectiva/informacion_financiera_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_informacion_financiera_tipo": informacionFinanciera,
          "pv_criterio": criterio
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Lista Directiva lista financiera");
      debugPrint(url.toString());
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      devLog.log("Lista Directiva lista financiera");
      devLog.log(response.body.toString());

      if(response.statusCode == 200)
      {
        //GestionTickets1();
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          return [];
        }
        debugPrint("Regreso correcto");
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
        if (json["resultado"]["pn_tiene_datos"] == 1) {

          return List<Map<String, dynamic>>.from(json["datos"]);
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(
              json["resultado"]["pv_error_descripcion"].toString());
        }
        }
      }
    }
    catch(e)
    {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
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
}


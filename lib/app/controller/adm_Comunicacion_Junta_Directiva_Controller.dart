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

 

class AdmComunicacionJuntaDirectivaController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}

class ComunicacionJuntaDirectivaClass
{
  String comunicacionTipo="";
  String estado="";
  String criterio="";

  ComunicacionJuntaDirectivaClass(this.comunicacionTipo, this.estado,this.criterio);

  Future<List<Map<String, dynamic>>>ColumicacionesListadosJ5()async
  {
    debugPrint("**********J5***********");
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
          "$baseUrl/portal/juntadirectiva/comunicaciones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_comunicacion_tipo": comunicacionTipo,
          "pn_estado": estado,
          "pv_criterio": criterio
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Lista Directiva !!!!!!!!!");
      debugPrint(body.toString());
      debugPrint(url.toString());
      debugPrint(response.body.toString());
      devLog.log("Lista Directiva !!!!!!!!!");
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

class ComunicacionJuntaDirectivaMarcarClass
{
  String comunicacion="";

  ComunicacionJuntaDirectivaMarcarClass(this.comunicacion);

  Future<List<Map<String, dynamic>>>ColumicacionesMarcaJ6()async
  {
    debugPrint("**********J6***********");
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
          "$baseUrl/portal/juntadirectiva/comunicacion_marcar");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_comunicacion_tipo": comunicacion,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Lista Directiva");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      devLog.log("Lista Directiva");
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

class ComunicacionJuntaDirectivaMensajeClass
{
  String comunicacion="";
  String mensaje="";

  ComunicacionJuntaDirectivaMensajeClass(this.comunicacion,this.mensaje);

  Future<List<Map<String, dynamic>>>ColumicacionesMensajeJ7()async
  {
    debugPrint("**********J7***********");
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
          "$baseUrl/portal/juntadirectiva/comunicacion_mensaje_crear");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_comunicacion": comunicacion,
          "pv_mensaje": mensaje,
        }
      };
      debugPrint("Mensaje directiva");
      debugPrint(url.toString());
      debugPrint(body.toString());
      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);

      debugPrint(response.body.toString());
      debugPrint("Mensaje directiva");
      devLog.log(response.body.toString());
      if(response.statusCode == 200)
      {
        //GestionTickets1();
        if (json["resultado"]["pn_error"] == 0) {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
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

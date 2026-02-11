import 'dart:convert';

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

class AdmNoticiasController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());


  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }


}


class setNewsComentC7{

  String noticiaID="";
  String comentario="";

  setNewsComentC7(this.noticiaID, this.comentario);

  Future<List<Map<String, dynamic>>>ComentarioNoticias7()async

  {
    debugPrint("**********C7***********");
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
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/noticias/comentario_noticia_creacion"
          "$baseUrl/portal/noticias/comentario_noticia_creacion"
      );
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_noticia": noticiaID,
          "pv_comentario": comentario
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Noticias_Comentario");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          return [];
        }

        debugPrint("Noticias3 comentario");
        //debugPrint(json["datos"][0]["pl_comentarios"][0]["pv_descripcion"].toString());

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          
          debugPrint("Comentario ingresado!!");
          return List<Map<String, dynamic>>.from(json["datos"]);
        } else {
          debugPrint("Noticia comentario Sin datos");
          debugPrint("Noticias comentario Error");
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
          // //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          // throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
    throw Exception("Error en llamado");
  }
}

class getNewsC5{

String noticiaTipo="";
String importante="";
String criterio="";
String periodo="";

getNewsC5(this.noticiaTipo, this.importante,this.criterio,this.periodo);

  Future<List<Map<String, dynamic>>>importanNoticias5()async

  {
  debugPrint("**********C5***********");
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
    var url = Uri.parse(
       //"https://apidesa.komuvita.com/portal/noticias/noticias_listado"
        "$baseUrl/portal/noticias/noticias_listado"
    );
    Map body = {
      "autenticacion":
      {
        "pv_token": token
      },
      "parametros":
      {
        "pn_empresa": empresaID,
        "pn_periodo": periodo,
        "pn_noticia_tipo": noticiaTipo,
        "pn_importante": importante,
        "pv_criterio": criterio
      }
    };

    http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
    final json = jsonDecode(response.body);
    debugPrint("Noticias");
    debugPrint(body.toString());
    debugPrint(response.body.toString());

    if(response.statusCode == 200)
    {
      if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
      {
        debugPrint("Si funciona verificar el mensaje");
        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      if (json["resultado"]["pn_error"] == 0)
      {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
      // ✅ Check if datos exists and is not null
      if (json["datos"] == null || (json["datos"] as List).isEmpty) {
        // Return an empty list instead of throwing
        debugPrint("⚠️ 'datos' is null or empty in response");
        return [];
      }

      debugPrint("Noticias3");
      //debugPrint(json["datos"][0]["pl_comentarios"][0]["pv_descripcion"].toString());

      if (json["resultado"]["pn_tiene_datos"] == 1) {

        debugPrint("Noticias con datos");
        return List<Map<String, dynamic>>.from(json["datos"]);
      } else {
        debugPrint("Noticias Sin datos");
        debugPrint("Noticias Error");
        debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
        // //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
        // throw Exception(json["resultado"]["pv_error_descripcion"].toString());
      }
      }
     else if (json["resultado"]["pn_error"] == 1 && json["resultado"]["pv_error_descripcion"].toString() =="Exception: El token ha expirado")
       {
         //msgxToast("Exception: El token ha expirado");
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
  throw Exception("Error en llamado");
}
}
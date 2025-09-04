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

class AdmNoticiasController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());


  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }


}

class getNewsH5{

String noticiaTipo="";
String importante="";
String criterio="";

getNewsH5(this.noticiaTipo, this.importante,this.criterio,);

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
        "http://api.komuvita.com/portal/noticias/noticias_listado"
    );
    Map body = {
      "autenticacion":
      {
        "pv_token": token
      },
      "parametros":
      {
        "pn_empresa": int.parse(empresa!),
        "pn_periodo": 1,
        "pn_noticia_tipo": "-1",
        "pn_importante": "-1",
        "pv_criterio": ""
      }
    };

    http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
    final json = jsonDecode(response.body);
    debugPrint("Noticias");
    debugPrint(body.toString());
    debugPrint(response.body.toString());

    if(response.statusCode == 200)
    {

      if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
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
  throw Exception("Error en llamado");
}
}
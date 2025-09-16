import 'dart:convert';

import 'package:administra/app/controller/adm_login_controller.dart';
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

class AdmObjetosPerdidosController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }

}


class objetosPerdidosSetE5
{

String busqueda="";


objetosPerdidosSetE5( this.busqueda);

Future<List<Map<String, dynamic>>>objetosPerdidos5()async
{
  debugPrint("**********E5***********");
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
        //"https://apidesa.komuvita.com/portal/cosasperdidas/cosas_perdidas_listado");
    "http://api.komuvita.com/portal/cosasperdidas/cosas_perdidas_listado");
    Map body = {
      "autenticacion":
      {
        "pv_token": token
      },
      "parametros":
      {
        
        "pn_empresa": empresaID,
        "pv_criterio": busqueda,
        "pn_resumen": "1",
      }
    };

    http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
    final json = jsonDecode(response.body);

    debugPrint("Objetos Perdidos");
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
      debugPrint("Regreso correcto");
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
}
class objetosPerdidosSetReporteE6
{

  String idObjeto="";
  String fecha="";
  String reclamadoPor="";


  objetosPerdidosSetReporteE6( this.idObjeto,this.fecha,this.reclamadoPor);

  Future<List<Map<String, dynamic>>>objetosPerdidosReclamo6()async
  {
    debugPrint("**********E5***********");
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
       //"https://apidesa.komuvita.com/portal/cosasperdidas/cosa_perdida_reclamar");
      "http://api.komuvita.com/portal/cosasperdidas/cosa_perdida_reclamar");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa":empresaID,
          "pn_cosa_perdida":idObjeto,
          "pf_fecha":fecha,
          "pv_reclamada_por":reclamadoPor
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);

      debugPrint("Objetos Perdidos");
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
        debugPrint("Regreso correcto");
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
}
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



List<String> monedaId = [];
List<String> monedaSimbolo = [];
List<String> monedaDescripcion = [];

class AdmRentasVnetasController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());


  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}


class RentaVentasSetE5
{

  String tipo = "";
  String busqueda = "";

  RentaVentasSetE5(this.tipo,this.busqueda);

  Future<List<RentaVentaD5>>listadoRentas5B()async
  {
    debugPrint("**********D5***********");
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
          //"https://apidesa.komuvita.com/portal/rentasventas/rentas_listado");
      "http://api.komuvita.com/portal/rentasventas/rentas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pn_renta_tipo": tipo,
          "pv_criterio": busqueda,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Rentas");
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
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => RentaVentaD5.fromJson(item))
              .toList();
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

class listaDeMonedas
{


  Future<List<Map<String, dynamic>>>listaMonedas()async
  {
    debugPrint("**********EX1***********");
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
          //"https://apidesa.komuvita.com/portal/general/monedas_listado");
      "http://api.komuvita.com/portal/general/monedas_listado");
      Map  body = {
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
      debugPrint("Lista Monedas");
      debugPrint(body.toString());
      debugPrint(response.body.toString());


      final empresasList = json["datos"];

      debugPrint(empresasList.toString());

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {

          final List<dynamic> datos = json["datos"];
          // ✅ Separate lists
          final List<String> monedas =
          datos.map<String>((item) => item["pn_moneda"] as String).toList();

          final List<String> abreviaturas =
          datos.map<String>((item) => item["pn_abreviatura"].toString()).toList();

          final List<String> descripciones =
          datos.map<String>((item) => item["pn_moneda_descripcion"].toString()).toList();


          debugPrint(" Monedas: $monedas");
          debugPrint(" Abreviaturas: $abreviaturas");
          debugPrint(" Descripciones: $descripciones");



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

class RentaVentasSetE7
{
  String tipoRenta = "";
  String detalle = "";
  String valor = "";
  String contacto = "";
  String moneda = "";
  String imagen = "";

  RentaVentasSetE7(this.tipoRenta,this.detalle,this.valor,this.contacto,this.imagen,this.moneda);

  Future<List<Map<String, dynamic>>>listadoCreacionRentas6B()async
  {
    debugPrint("**********D6***********");
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
          //"https://apidesa.komuvita.com/portal/rentasventas/rentas_creacion");
      "http://api.komuvita.com/portal/rentasventas/rentas_creacion");
      Map<String,dynamic> body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pn_renta_tipo": tipoRenta,
          "pv_detalle": detalle,
          "pm_valor":valor,
          "pv_contacto": contacto,
          "pn_moneda": moneda,
          "pl_fotografias":
          [
            {
              "pn_fotografia": 999,
              "pv_fotografiab64": imagen,
            }
          ]
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Rentas");
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
        debugPrint("Regreso correcto!!!!!");

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
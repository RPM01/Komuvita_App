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


List<Map<String, dynamic>> CargoLecturaClienteCrearListadoList = [];
String mensajeErrorClienteCrearCargoListado = "";
String verificacionClienteCrearCargoListado ="";
String recibo = "";

List<String> formaPago = [];
List<String> formapagoDescirpcion = [];
List<String> formapagoTarjeta = [];

class AdmHomeController extends GetxController {

  RxList<AdmsCategory> listOCategoryAdms = <AdmsCategory>[].obs;
  RxList<DatosImportantes> listOImportanInfo = <DatosImportantes>[].obs;
  RxList<AdmsModal> listOfNearAdms = <AdmsModal>[].obs;
  RxList<AdmsModal> listOfBasedAdms = <AdmsModal>[].obs;

  final ThemeController themeController = Get.put(ThemeController());



  String pn_estadoTickets = "-1";
  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
  /*@override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }*/

  //B5
  Future<List<Map<String, dynamic>>>importanInfo5()async
  {
    debugPrint("**********B5***********");
    String deviceName = "";
    String deviceID = "";
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/importantes/datos_importantes_listado"
           "$baseUrl/portal/importantes/datos_importantes_listado"
      );
      Map body = {
            "autenticacion":
            {
            "pv_token": token
            },
            "parametros":
            {
            "pn_empresa": empresaID,
            "pn_dato_importante_tipo":"-1",
            "pn_forma_contacto": "-1",
            "pv_criterio": "",
            "pn_prioritario": "-1"
            }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint("InfoImportatnte");
      debugPrint(json["datos"][0]["pv_detalle"].toString());
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

          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      return [];
    }
    return [];
    throw Exception("Error en llamado");
  }


  Future<List<Map<String, dynamic>>>importanNoticias5()async
  {
    debugPrint("**********C5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
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
          "pn_periodo": 3,
          "pn_noticia_tipo": "-1",
          "pn_importante": "-1",
          "pv_criterio": ""
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Noticias");


      if(response.statusCode == 200)
      {

        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }

          debugPrint("Noticias3");
          //debugPrint(json["datos"][0]["pl_comentarios"][0]["pv_descripcion"].toString());

          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            debugPrint("Noticias con datos");
            debugPrint(body.toString());
            debugPrint(response.body.toString());
            debugPrint(json["datos"].toString());
            return List<Map<String, dynamic>>.from(json["datos"]);
          } else {
            debugPrint("Noticias Sin datos");
            debugPrint("Noticias Error");
            //debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
            
            // //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            // //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<Map<String, dynamic>>>listadoRentas5()async
  {
    debugPrint("**********D5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/rentasventas/rentas_listado"
           "$baseUrl/portal/rentasventas/rentas_listado"
      );
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
            "pn_empresa": empresaID,
            "pn_renta_tipo": "-1",
            "pv_criterio": ""
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

  Future<List<RentaVentaD5>>listadoRentas5B()async
  {
    debugPrint("**********D5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
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
           "$baseUrl/portal/rentasventas/rentas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_renta_tipo": "-1",
          "pv_criterio": ""
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
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
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


  Future<List<Map<String, dynamic>>>objetosPerdidos5()async
  {
    debugPrint("**********E5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
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
           "$baseUrl/portal/cosasperdidas/cosas_perdidas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_criterio": "",
          "pn_resumen": "1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      //debugPrint(response.body.toString());
      debugPrint("Objetos Perdidos");
      debugPrint((response.body.toString()));
      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
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
        if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      debugPrint(e.toString());
      return [];
    }
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>amenidadesReservadas5()async
  {
    debugPrint("**********F5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/amenidades/reservas_amenidades_listado");
           "$baseUrl/portal/amenidades/reservas_amenidades_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_criterio": "",
          "pn_amenidad":"-1",
          "pn_estado": "-1"
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Amenidades Reservadasdos");
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
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
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



  Future<List<ReservasF5>>amenidadesReservadas5B()async
  {
    debugPrint("**********F5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/amenidades/reservas_amenidades_listado");
           "$baseUrl/portal/amenidades/reservas_amenidades_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_criterio": "",
          "pn_amenidad":"-1",
          "pn_estado": "-1"
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Amenidades Reservadasdos");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!6");

        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            return (json["datos"] as List)
                .map((item) => ReservasF5.fromJson(item))
                .toList();
          } else {
            // debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            // //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      debugPrint("Amenidades reservadas 2");
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

  Future<List<Map<String, dynamic>>>GestionTickets5()async
  {
    debugPrint("**********G5***********");
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
           "$baseUrl/portal/tickets/gestiones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_periodo": "-1",
          "pv_cliente": prefs.getString("correo"),
          "pv_propiedad": "-1",
          "pn_gestion_tipo": "-1",
          "pn_estado": "-1",
          "pv_criterio": ""
         }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
       debugPrint("Tickets3");
       debugPrint(body.toString());
      debugPrint(response.body.toString());
      devLog.log("Tickets3");
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



  Future<List<TickestG5>> GestionTickets5B() async {
    debugPrint("**********G5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;

    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("Tickets!!!");

    try {
      var header = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestiones_listado");
         "$baseUrl/portal/tickets/gestiones_listado");


      Map body = {
        "autenticacion": {
          "pv_token": token,
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pn_periodo": "1",
          "pv_cliente": prefs.getString("correo"),
          "pv_propiedad": "-1",
          "pn_gestion_tipo": "-1",
          "pn_estado": pn_estadoTickets,
          "pv_criterio": "",
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);
      debugPrint("Tickets69LOL");
      debugPrint(body.toString());
      if (json["datos"] == null || json["datos"] is! List) {
        debugPrint("⚠️ 'datos' is null or not a list");
        return [];
      }
      List datosList = json["datos"];
      int totalWithGestion =
          datosList.where((item) => item['pn_gestion'] != null).length;
      debugPrint(totalWithGestion.toString());

      debugPrint(body.toString());
      debugPrint(response.body.toString());
      devLog.log("Tickets69");
      devLog.log(response.body.toString());

      if (response.statusCode == 200) {
        if (json["resultado"]["pn_error"] == 0) {
          if (datosList.isEmpty) {
            debugPrint("⚠️ 'datos' is empty");
            return [];
          }

          debugPrint("Regreso correcto!!!!!");

          if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            debugPrint("Si funciona verificar el mensaje");
            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }
          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            return datosList.map((item) => TickestG5.fromJson(item)).toList();
          } else {
            debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            throw Exception(
                json["resultado"]["pv_error_descripcion"].toString());
          }
        }
      }
    } catch (e) {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      debugPrint("❌ Exception: $e");
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text(errorMensaje),
            contentPadding: EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }

    throw Exception("Error en conexión");
  }


  Future<List<TickestG5>>GestionTickets5BMes()async
  {
    debugPrint("**********G5***********");
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
           "$baseUrl/portal/tickets/gestiones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_periodo": "1",
          "pv_cliente": prefs.getString("correo"),
          "pv_propiedad": "-1",
          "pn_gestion_tipo": "-1",
          "pn_estado": "-1",
          "pv_criterio": ""
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);

      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint("Tickets159");

      debugPrint(json["datos"]["pn_gestion"].toString());
      int secondItemsLength = (json["datos"]["pn_gestion"] as List).length;
      debugPrint("Cantidad de gestiones");
      debugPrint(secondItemsLength.toString());
      devLog.log("Tickets69");
      devLog.log(response.body.toString());
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
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            return (json["datos"] as List)
                .map((item) => TickestG5.fromJson(item))
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


  Future<List<Map<String, dynamic>>>paqueteria5()async
  {
    debugPrint("**********L5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? cliente = prefs.getString("cliente");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Info Paquetes");
    debugPrint(empresa);
    debugPrint(cliente);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/paqueteria/paquete_pendiente_listado");
           "$baseUrl/portal/paqueteria/paquete_pendiente_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_cliente": cliente,
          "pv_propiedad": "-1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Paquetes001");
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
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
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

  Future<List<Map<String, dynamic>>>visitas5()async
  {
    debugPrint("**********M5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint("Info Visitas");
    debugPrint(cliente);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_pendiente_listado");
           "$baseUrl/portal/visitas/visita_pendiente_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_cliente": cliente,
          "pv_propiedad": "-1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("VisitasM5");
      debugPrint(json["datos"][0]["pv_imagen_qrb64"].toString());
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
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            return List<Map<String, dynamic>>.from(json["datos"]);
          }
          else {
            debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
            
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
      return [];
    }
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>listaPagosH2()async
  {
    debugPrint("**********H2***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/cuentas/forma_pago_listado");
           "$baseUrl/portal/cuentas/forma_pago_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("ListadoPagos");
      debugPrint("Test");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!8");
        if (json["resultado"]["pn_error"] == 0) {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }

          if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            debugPrint("Si funciona verificar el mensaje");
            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }

          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            debugPrint(json["datos"].toString());
            List<Map<String, dynamic>> datos =
                List<Map<String, dynamic>>.from(json["datos"]);

            List<String> formasPago = List<String>.from(
                datos.map((e) => e["pv_forma_pago"].toString()).toList());

            List<String> descripciones = List<String>.from(
                datos.map((e) => e["pv_descripcion"].toString()).toList());

            List<String> tarjeta = List<String>.from(
                datos.map((e) => e["pb_es_tarjeta"].toString()).toList());

            formaPago = formasPago;
            formapagoDescirpcion = descripciones;
            formapagoTarjeta = tarjeta;

            //debugPrint(formaPago.toString());
            //debugPrint(formapagoDescirpcion.toString());
            //debugPrint(formapagoTarjeta.toString());

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
      return [];
    }
    return [];
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>documentosListados5()async
  {
    debugPrint("**********H5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
   // GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/cuentas/documentos_listado");
           "$baseUrl/portal/cuentas/documentos_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_cliente": prefs.getString("correo"),
          "pn_propiedad": "-1",
          "pn_documento_tipo": "-1",
          "pv_criterio": "",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Documentos");
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

  Future<List<AdmsCategory>> getCategoryAdmsDetail() async {
    listOCategoryAdms.clear();
    String jsonData = await rootBundle
        .loadString("assets/administra/data/files.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['category_adms_list'];

    if (jsonArray.length > 8) {
      for (int i = 0; i < 8; i++) {
        listOCategoryAdms.add(AdmsCategory.fromJson(jsonArray[i]));
      }
    } else {
      for (int i = 0; i < jsonArray.length; i++) {
        listOCategoryAdms.add(AdmsCategory.fromJson(jsonArray[i]));
      }
    }
    return listOCategoryAdms;
  }


  Future<List<DacumentosH5>> documentosListados5B() async {
    debugPrint("**********H5***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;

    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/cuentas/documentos_listado");
           "$baseUrl/portal/cuentas/documentos_listado");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pv_cliente": prefs.getString("correo"),
          "pn_propiedad": "-1",
          "pn_documento_tipo": "-1",
          "pv_criterio": "",
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);

      debugPrint("Documentos");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }
          debugPrint("Regreso correcto!!!!!");
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
          if (json["resultado"]["pn_tiene_datos"] == 1) {
            
            return (json["datos"] as List)
                .map((item) => DacumentosH5.fromJson(item))
                .toList();
          } else {
            debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
          }
        }
      }

    } catch (e) {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      debugPrint(e.toString());
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text(errorMensaje),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(e.toString())],
          );
        },
      );
    }
    throw Exception("Error en conexión");
  }


  //Listas que no se usan
  Future<List<AdmsModal>> getNearAdmsDetail() async {
    String jsonData = await rootBundle
        .loadString("assets/administra/data/near_adms.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['near_adms_list'];
   // print(jsonArray);
    // if (kDebugMode) {
    //   print(jsonArray);
    // }
    listOfNearAdms.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfNearAdms.add(AdmsModal.fromJson(jsonArray[i]));
    }

    return listOfNearAdms;
  }

  Future<List<AdmsModal>> getBasedPreferenceAdmsDetail() async {
    String jsonData = await rootBundle.loadString(
        "assets/administra/data/based_preference_list.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['based_Preference_list'];

    listOfBasedAdms.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfBasedAdms.add(AdmsModal.fromJson(jsonArray[i]));
    }

    return listOfBasedAdms;
  }
}


class ServicioListadoCargoClienteCargar{

  String numeroDocumento="";
  String montoPago="";
  String formaPago="";
  String fechaPago="";
  String numeroAutorizacion="";
  String imagen = "";
  String reserva = "";

  ServicioListadoCargoClienteCargar(this.numeroDocumento, this.montoPago,this.formaPago,this.fechaPago,this.numeroAutorizacion,this.imagen,this.reserva);

  Future<bool> hacerPago() async {

    debugPrint("**********H6***********");
    const String errorMensaje = "Falla de conexión";
    bool status = false;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;

    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

      try{var headers = {
        'Content-Type': 'application/json'
      };
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pn_reserva": reserva,
          "pn_documento": numeroDocumento,
          "pn_forma_pago": formaPago,
          "pf_fecha_pago":fechaPago,
          "pm_monto":montoPago,
          "pn_autorizacion": numeroAutorizacion,
          "pv_comprobanteb64":imagen
        }
      };

        var dio = Dio();
      var response = await dio.request(
        //"https://apidesa.komuvita.com/portal/cuentas/documento_aplicar_pago",
         "$baseUrl/portal/cuentas/documento_aplicar_pago",

          options: Options(
            method: 'POST',
            headers: headers,
          ),
          data: data,
        );

      devLog.log("Realizando pago....");
        devLog.log(data.toString());
        debugPrint(response.data.toString());
        debugPrint(response.statusCode.toString());


        debugPrint(response.data["resultado"]["pv_error_descripcion"]);
      if (response.statusCode == 200 && response.data['datos'] != []) {

          String lista = json.encode(response.data);
          // debugPrint(data.toString());
          devLog.log(data.toString());
          debugPrint(lista);
          debugPrint("!!!!!");
          //CargoLecturaClienteCrearListadoList = List<Map<String, dynamic>>.from(response.data['datos']!);


          verificacionClienteCrearCargoListado = response.data["resultado"]["pn_error"].toString();
          mensajeErrorClienteCrearCargoListado = response.data["resultado"]["pv_error_descripcion"].toString();
          recibo = response.data["datos"]["pn_recibo"].toString();
          debugPrint(verificacionClienteCrearCargoListado);
          debugPrint("Aplicando pago");
          debugPrint("Funciono!!!");
          msgxToast("Pago realizado correctamente no.${response.data["datos"]["pn_recibo"].toString()}");

          if(response.data["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            debugPrint("Si funciona verificar el mensaje");
            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }
             debugPrint(status.toString());
        }
        else {
          debugPrint("SIN INGORMACION");
          debugPrint(response.statusMessage);
          debugPrint("???*");
          status =  false;
        }
      }
      catch (ex, stacktrace){
        status =  false;
        debugPrint("???/+/");
        debugPrint("Request failed: $ex");
        debugPrint("Stacktrace: $stacktrace");
      }

    debugPrint(status.toString());
    return status;
  }
}

class AutorizarClass
{

  String reserva = "";


  AutorizarClass(this.reserva);

  Future<List<Map<String, dynamic>>>amenidadesReservadas7B()async
  {
    debugPrint("**********F7***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
      //"https://apidesa.komuvita.com/portal/amenidades/reserva_amenidad_autoriza");
      "$baseUrl/portal/amenidades/reserva_amenidad_autoriza");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_reserva":reserva,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Amenidades Reservadasdos");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!6");

        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());

         if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
        if (json["resultado"]["pn_tiene_datos"] == 1) {
          if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            debugPrint("Si funciona verificar el mensaje");
            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          // debugPrint(json["resultado"]["pv_error_descripcion"].toString());
           msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      msgxToast(e.toString());
      debugPrint("Amenidades reservadas 2");
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

class RechazarClass
{

  String reserva = "";
  String observaciones = "";


  RechazarClass(this.reserva,this.observaciones);

  Future<List<Map<String, dynamic>>>amenidadesReservadas8B()async
  {
    debugPrint("**********F8***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
      //"https://apidesa.komuvita.com/portal/amenidades/reserva_amenidad_rechazar");
      "$baseUrl/portal/amenidades/reserva_amenidad_rechazar");
      Map<String,dynamic> body = {
        "autenticacion":
        {
          "pv_token":token
        },
        "parametros":
        {
          "pn_empresa":empresaID,
          "pn_reserva":reserva,
          "pv_observaciones":observaciones,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Amenidades_Rechazadas");
      debugPrint("123");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!6");

        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
        if (json["resultado"]["pn_tiene_datos"] == 1) {

          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          // debugPrint(json["resultado"]["pv_error_descripcion"].toString());
           msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      msgxToast(e.toString());
      debugPrint("Amenidades reservadas 2");
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
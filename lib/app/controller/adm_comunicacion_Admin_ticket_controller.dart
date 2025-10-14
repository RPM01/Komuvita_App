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

import 'adm_login_controller.dart';


List <String> gestionDescripcion = [];
List <int> gestionIDs = [];

List <String> gestionDescripcionB = [];
List <int> gestionIDsB = [];

List<Map<String, dynamic>> cracionTicketInfoList = [];
String mensajeErrorClienteCrearTickets = "";
String verificacionClienteCrearTickets ="";

String reciboTickets = "";

class AdmComunicacionAdministraController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}

class ListaFiltradaTickets
{
  String periodo = "";
      String propiedad = "";
  String gestion = "";
      String estado = "";
  String criterio = "";

ListaFiltradaTickets( this.periodo, this.propiedad,
 this.gestion, this.estado, this.criterio);

Future<List<TickestG5>> GestionTickets5B_2() async {
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
        "http://api.komuvita.com/portal/tickets/gestiones_listado");

    Map body = {
      "autenticacion": {
        "pv_token": token,
      },
      "parametros": {
        "pn_empresa": empresaID,
        "pn_periodo": periodo,
        "pv_cliente": prefs.getString("correo"),
        "pv_propiedad": propiedad,
        "pn_gestion_tipo": gestion,
        "pn_estado": estado,
        "pv_criterio": criterio,
      }
    };

    http.Response response = await http.post(
      url,
      body: jsonEncode(body),
      headers: header,
    );

    final json = jsonDecode(response.body);
    debugPrint("Tickets69_G5");

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
    devLog.log("Tickets69_G5");
    devLog.log(response.body.toString());

    if (response.statusCode == 200) {

     if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
    {
      debugPrint("Si funciona verificar el mensaje");
      Get.offAllNamed(MyRoute.loginScreen);
    }

      if (json["resultado"]["pn_error"] == 0) {
        if (datosList.isEmpty) {
          debugPrint("⚠️ 'datos' is empty");
          return [];
        }

        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return datosList.map((item) => TickestG5.fromJson(item)).toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(
              json["resultado"]["pv_error_descripcion"].toString());
        }
      }
     if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
     {
       debugPrint("Si funciona verificar el mensaje");
       Get.offAllNamed(MyRoute.loginScreen);
     }
    }
  } catch (e) {

    if(e.toString() == "Exception: El token ha expirado")
    {
      msgxToast(e.toString());
      debugPrint("Si funciona verificar el mensaje");

      Get.offAllNamed(MyRoute.loginScreen);
    }
    debugPrint("❌ Exception: $e");
    return [];
  }

  return [];
}
}

class ServicioTickets
{
  String propiedad="";
  String propiedadDescripcion = "";
  String gestionTipo="";
  String descripcion="";
  String clientes = "";
  List<String> imagen =[];

  ServicioTickets(this.propiedad,this.propiedadDescripcion, this.gestionTipo,this.descripcion,this.clientes,this.imagen);

  Future<List<Map<String, dynamic>>>listadoCreacionTickets()async
  {
    debugPrint("**********G6***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("clienteID");
    debugPrint(cliente);

    List<Map<String, String>> listaFotografias = imagen
        .map((img) => {"pv_fotografiab64": img})
        .toList();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestion_creacion",
        "http://api.komuvita.com/portal/tickets/gestion_creacion",
      );
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_cliente":  clienteIDset,
          "pv_propiedad": propiedad,
          "pn_gestion_tipo": gestionTipo,
          "pv_descripcion": descripcion,
          "pv_propiedad_direccion":propiedad,
          "pv_propiedad_descripcion": "lol",
          "pl_fotografias":listaFotografias,
        },
      };

      http.Response response = await http.post(url,body: jsonEncode(data),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Tickets1212");
      debugPrint(data.toString());
      devLog.log(response.body.toString());

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];

        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
           msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
      }
    }
    catch(e)
    {

      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");
        msgxToast(e.toString());
        Get.offAllNamed(MyRoute.loginScreen);
      }
      debugPrint(e.toString());
      return [];
    }
    return [];
  }

}



class ServicioSeguimientoTickets
{
  String comentarios="";
  String gestionNo="";
  List<String> imagen =[];

  ServicioSeguimientoTickets(this.comentarios,this.imagen,this.gestionNo);

  Future<List<Map<String, dynamic>>>listadoSeguimientoTickets()async
  {
    debugPrint("**********G6***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("clienteID");
    debugPrint(cliente);

    List<Map<String, String>> listaFotografias = imagen
        .map((img) => {"pv_fotografiab64": img})
        .toList();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/seguimiento_gestion_creacion",
        "http://api.komuvita.com/portal/tickets/seguimiento_gestion_creacion",
      );
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_gestion":  gestionNo,
          "pv_comentario": comentarios,
          "pl_fotografias": listaFotografias
        },
      };

      http.Response response = await http.post(url,body: jsonEncode(data),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Creacion de comentario");
      debugPrint(data.toString());
      devLog.log(response.body.toString());
      msgxToast(json["resultado"]["pv_error_descripcion"]);

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
           msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
      }
    }
    catch(e)
    {

      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");
        msgxToast(e.toString());
        Get.offAllNamed(MyRoute.loginScreen);
      }
      //Get.back();
       debugPrint(e.toString());
      return [];
    }
    return [];
  }

}

Future<List<Map<String, dynamic>>>GestionTickets2()async
{
  debugPrint("**********G2***********");

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
        //"https://apidesa.komuvita.com/portal/tickets/gestion_tipo_listado");
    "http://api.komuvita.com/portal/tickets/gestion_tipo_listado");
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
    debugPrint("Tickets si sirvio");
    //debugPrint(response.body.toString());
    debugPrint("clientes");

    debugPrint(json["datos"][0]["pv_cliente"].toString());
    prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());
    //prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());

    //prefs.setStringList('ListaPropiedad', json["datos"]["pv_descripcion"]);
    // prefs.setStringList('ListaPropiedadID', json["datos"]["pn_propiedad"]);



    final empresasList = json["datos"] as List;

    debugPrint(empresasList.toString());


    final List<String> gestionDes = empresasList.map((e) => e["pv_descripcion"] as String).toList();
    final List<int> gestioNumero = empresasList.map((e) => e["pn_gestion_tipo"] as int).toList();

    final List<String> gestionDesB = empresasList.map((e) => e["pv_descripcion"] as String).toList();
    final List<int> gestioNumeroB = empresasList.map((e) => e["pn_gestion_tipo"] as int).toList();


    //prefs.setStringList("clientesInternos", gestionDes);

    debugPrint("GestionesProto");
    debugPrint(gestionDes.toString());

    debugPrint("GestionesIDProto");
    debugPrint(gestioNumero.toString());


    gestionDescripcionB = gestionDesB;
    gestionIDsB = gestioNumeroB;

    gestionDescripcion = gestionDes;
    gestionIDs = gestioNumero;

    gestionDescripcion.insert(0, "Todos");
    gestionIDs.insert(0, -1);

    debugPrint("Gestiones");
    debugPrint(gestionDescripcion.toString());

    debugPrint("GestionesID");
    debugPrint(gestionIDs.toString());

    debugPrint("GestionesB");
    debugPrint(gestionDescripcionB.toString());

    debugPrint("GestionesIDB");
    debugPrint(gestionIDsB.toString());
    //prefs.setString("propiedad", json["datos"][0]["pn_propiedad"].toString());

    debugPrint("Tickest100");
    debugPrint(response.body.toString());
    if(response.statusCode == 200)

    {
      debugPrint("Regreso correcto");
      if(json["resultado"]["pn_tiene_datos"] == 1)
      {
        //Get.offNamedUntil(MyRoute.home,(route) => route.isFirst,);
        return List<Map<String, dynamic>>.from(json["datos"]);
      }
      else
      {
        debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
        //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
      }
      if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
      {
        debugPrint("Si funciona verificar el mensaje");
        Get.offAllNamed(MyRoute.loginScreen);
      }
    }
  }
  catch(e)
  {

    if(e.toString() == "Exception: El token ha expirado")
    {
      msgxToast(e.toString());
      debugPrint("Si funciona verificar el mensaje");
      msgxToast(e.toString());
      Get.offAllNamed(MyRoute.loginScreen);
    }
    //Get.back();
    debugPrint(e.toString());
    return [];
  }
  return [];
}

class ServicioProcesoTickets
{

  String gestionNo="";


  ServicioProcesoTickets(this.gestionNo);

  Future<List<Map<String, dynamic>>>listadoProcesoTickets()async
  {
    debugPrint("**********G9***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("clienteID");
    debugPrint(cliente);


    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestion_en_proceso",
        "http://api.komuvita.com/portal/tickets/gestion_en_proceso",
      );
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_gestion":  gestionNo,
        },
      };

      http.Response response = await http.post(url,body: jsonEncode(data),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Creacion de comentario");
      debugPrint(data.toString());
      devLog.log(response.body.toString());
      msgxToast(json["resultado"]["pv_error_descripcion"]);

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
      }
    }
    catch(e)
    {

      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");
        msgxToast(e.toString());
        Get.offAllNamed(MyRoute.loginScreen);
      }
      //Get.back();
      debugPrint(e.toString());
      return [];
    }
    return [];
  }
}

class ServicioFinalizarTickets
{

  String gestionNo="";


  ServicioFinalizarTickets(this.gestionNo);

  Future<List<Map<String, dynamic>>>listadoFinalizarTickets()async
  {
    debugPrint("**********G10***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("clienteID");
    debugPrint(cliente);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestion_finalizar",
        "http://api.komuvita.com/portal/tickets/gestion_finalizar",
      );
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_gestion":  gestionNo,
        },
      };

      http.Response response = await http.post(url,body: jsonEncode(data),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Creacion de comentario");
      debugPrint(data.toString());
      devLog.log(response.body.toString());
      msgxToast(json["resultado"]["pv_error_descripcion"]);

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
      }
    }
    catch(e)
    {

      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");
        msgxToast(e.toString());
        Get.offAllNamed(MyRoute.loginScreen);
      }
      //Get.back();
      debugPrint(e.toString());
      return [];
    }
    return [];
  }
}
class ServicioCerrarTickets
{

  String gestionNo="";
  String estrellas ="";

  ServicioCerrarTickets(this.gestionNo,this.estrellas);

  Future<List<Map<String, dynamic>>>listadoCerrarTickets()async
  {
    debugPrint("**********G8***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("clienteID");
    debugPrint(cliente);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
        //"https://apidesa.komuvita.com/portal/tickets/gestion_finalizar",
        "http://api.komuvita.com/portal/tickets/gestion_finalizar",
      );
      Map<String,dynamic> data =
      {
        "autenticacion": {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_gestion":  gestionNo,
          "pn_estrellas": ""
        },
      };

      http.Response response = await http.post(url,body: jsonEncode(data),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Creacion de comentario");
      debugPrint(data.toString());
      devLog.log(response.body.toString());
      msgxToast(json["resultado"]["pv_error_descripcion"]);

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0) {debugPrint(json["resultado"]["pv_error_descripcion"].toString());
        // ✅ Check if datos exists and is not null
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          // Return an empty list instead of throwing
          debugPrint("⚠️ 'datos' is null or empty in response");
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);

        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offAllNamed(MyRoute.loginScreen);
        }
      }
    }
    catch(e)
    {

      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");
        msgxToast(e.toString());
        Get.offAllNamed(MyRoute.loginScreen);
      }
      //Get.back();
      debugPrint(e.toString());
      return [];
    }
    return [];
  }
}

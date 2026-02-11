import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api_Clases/class_Cuentas7.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
 import '../../adm_theme/theme_controller.dart';
import '../../api_Clases/class_Paquetes6.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../modal/adms_home_modal.dart';
import 'Dio_Controller.dart';
import 'adm_login_controller.dart';
import 'dart:developer'as devLog;



class AdmListadoDePaquetescontroller extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}


class ServiciosListadoDePaquetes
{
  String propiedad = "";
  String periodo = "";
  String recolectada = "";
  String clientez = "";

  ServiciosListadoDePaquetes(this.clientez,this.periodo,this.recolectada,this.propiedad);

  Future<List<PaqueteG6>> paquetesG6() async {
    debugPrint("**********G16***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? inquilino = prefs.getString("Inquilino");

    String? empresa = empresaID;
    String? cliente = "";

    if(inquilino == "1")
    {
      cliente = cliente = prefs.getString("cliente");
    }
    else
    {
      cliente = clientez;
    }

    debugPrint(token);
    debugPrint("Empresa_Paquete 222");
    debugPrint(empresa);
    debugPrint(cliente);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
      //"https://apidesa.komuvita.com/portal/paqueteria/paquete_listado");
      "$baseUrl/portal/paqueteria/paquete_listado");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pv_cliente": cliente,
          "pv_propiedad": propiedad,
          "pn_periodo": periodo,
          "pn_recolectado":recolectada
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      debugPrint("Documentos_Paquetes_1");
      debugPrint(url.toString());
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      final json = jsonDecode(response.body);
      //debugPrint(json.toString());

      debugPrint(response.statusCode.toString());


      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 200)
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
        if(json["resultado"]["pv_error_descripcion"]=="El token ha expirado")
          {
            msgxToast(json["resultado"]["pv_error_descripcion"]);

            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }

        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          
          return (json["datos"] as List)
              .map((item) => PaqueteG6.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          //throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
        }
      }
    }
    catch (e)
    {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      debugPrint(e.toString());
      msgxToast(e.toString());
      return[];
    }
    throw Exception("Error en conexión");
  }
}



class ServiciosListadoDePaquetesEdicion
{
  String propiedad = "";
  String propiedadNombre = "";
  String periodo = "";
  String paquetes = "";
  String fecha = "";
  String recolectada = "";
  String descripcion = "";
  List<String> imagenes = [];
  String clientez = "";

  ServiciosListadoDePaquetesEdicion(this.fecha,this.propiedad,this.propiedadNombre,this.descripcion,this.paquetes,this.imagenes,this.clientez);

  Future<List<Map<String, dynamic>>> paquetesG8()  async {
    debugPrint("**********G8***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? inquilino = prefs.getString("Inquilino");

    String? empresa = empresaID;
    String? cliente = "";

    if(inquilino == "1")
    {
      cliente = cliente = prefs.getString("cliente");
    }
    else
    {
      cliente = clientez;
    }

    debugPrint(token);
    debugPrint("Empresa_Paquete 111");
    debugPrint(empresa);
    debugPrint(cliente);

    //GestionTickets1();

    List<Map<String, dynamic>> listaFotografias = List.generate(
      imagenes.length,
          (index) => {
        "pn_fotografia": index, // use index as ID
        "pv_fotografiab64": imagenes[index],
      },
    );

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/paqueteria/paquete_edicion");
      "$baseUrl/portal/paqueteria/paquete_edicion");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pn_paquete": paquetes,
          "pf_fecha": fecha,
          "pv_cliente": cliente,
          "pv_propiedad": propiedad,
          "pv_propiedad_nombre": propiedadNombre,
          "pv_descripcion":descripcion,
          "pl_fotografias":listaFotografias
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);

      devLog.log(listaFotografias.toString());
      debugPrint("Documentos_Paquetes_Editados");

      //devLog.log(body.toString());
      //debugPrint(body.toString());
      devLog.log(body.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 200)
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
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
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
      return[];
    }
    throw Exception("Error en conexión");
  }

}

class ServiciosListadoDePaquetesRecepcion
{
  String propiedad = "";
  String clientez = "";
  String propiedadNombre = "";
  String periodo = "";
  String paquetes = "";
  String fecha = "";
  String recolectada = "";
  String descripcion = "";
  List<String> imagenes = [];

  ServiciosListadoDePaquetesRecepcion(this.fecha,this.propiedad,this.clientez,this.propiedadNombre,this.descripcion,this.imagenes);

  Future<List<Map<String, dynamic>>> paquetesG7() async {
    debugPrint("**********G7***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? inquilino = prefs.getString("Inquilino");

    String? empresa = empresaID;
    String? cliente = "";

    if(inquilino == "1")
    {
      cliente = cliente = prefs.getString("cliente");
    }
    else
    {
      cliente = clientez;
    }

    debugPrint(token);
    debugPrint("Empresa_Paquete_Creacion");
    debugPrint(empresa);
    debugPrint(cliente);

    //GestionTickets1();
    List<Map<String, dynamic>> listaFotografias = List.generate(
      imagenes.length,
          (index) => {
        "pn_fotografia": index, // use index as ID
        "pv_fotografiab64": imagenes[index],
      },
    );

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/paqueteria/paquete_recepcion");
      "$baseUrl/portal/paqueteria/paquete_recepcion");

      devLog.log(imagenes.toString());



      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pv_cliente": cliente,
          "pf_fecha": fecha,
          "pv_propiedad": propiedad,
          "pv_propiedad_nombre": propiedadNombre,
          "pv_descripcion":descripcion,
          "pl_fotografias":listaFotografias
        }
      };

      debugPrint("Documentos_Paquetes_creacion");
      debugPrint(url.toString());
      debugPrint(body.toString());
      //debugPrint(listaFotografias.toString());

      devLog.log(listaFotografias.toString());

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);

      debugPrint(response.body.toString());

      if (response.statusCode == 200)
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
      }

    } catch (e) {
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
      debugPrint(e.toString());
      return[];
    }
    throw Exception("Error en conexión");
  }

}

class ServiciosListadoDePaquetesRecoletar
{
  String paquetes = "";
  String fecha = "";
  String observaciones = "";

  ServiciosListadoDePaquetesRecoletar(this.paquetes,this.fecha,this.observaciones);

  Future<List<Map<String, dynamic>>> paquetesG9() async {
    debugPrint("**********G9***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    String? cliente = prefs.getString("cliente");

    debugPrint(token);
    debugPrint("Empresa_Paquete 333");
    debugPrint(empresa);
    debugPrint(cliente);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/paqueteria/paquete_recolectar");
      "$baseUrl/portal/paqueteria/paquete_recolectar");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pn_paquete": paquetes,
          "pf_fecha":  fecha,
          "pv_observaciones":observaciones
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      debugPrint("Documentos_Paquetes_Recolectar");
      debugPrint(url.toString());
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      final json = jsonDecode(response.body);



      if (response.statusCode == 200)
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
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          debugPrint("⚠️ 'datos' is null or empty in response");
          return [];
        }
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          
          return List<Map<String, dynamic>>.from(json["datos"]);

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
      return[];
    }
    throw Exception("Error en conexión");
  }

}
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
import '../../api_Clases/class_Visitas6.dart';
import '../../route/my_route.dart';
import '../modal/adms_ImportanInfo.dart';
import '../modal/adms_category.dart';
import '../modal/adms_home_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'as devLog;

import 'adm_login_controller.dart';
import 'package:administra/app/controller/Dio_Controller.dart';



class AdmRentasVisitasController extends GetxController
{
  final ThemeController themeController = Get.put(ThemeController());

  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
}

class visitasLista
{

  String clientez = "";
  String propiedades = "";
  String periodo = "";
  String recibida= "";
  String codigo= "";

  visitasLista(this.clientez,this.propiedades, this.periodo,this.recibida,this.codigo);


  Future<List<VisitaM6>> listadoVisitasM6() async {
    debugPrint("**********M6***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;

    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_listado");
      "$baseUrl/portal/visitas/visita_listado");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pv_cliente": clientez,
          "pv_propiedad": propiedades,
          "pn_periodo": periodo,
          "pn_recibida": recibida,
          "pv_codigo": codigo
        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);

      debugPrint("Listado de Visitas_Recibido!!!");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 200)
      {
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }
        if (json["resultado"]["pn_error"] == 0)
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          // ✅ Check if datos exists and is not null
          if (json["datos"] == null || (json["datos"] as List).isEmpty) {
            // Return an empty list instead of throwing
            debugPrint("⚠️ 'datos' is null or empty in response");
            return [];
          }
          debugPrint("Regreso correcto!!!!!");

          if (json["resultado"]["pn_tiene_datos"] == 1) {
            return (json["datos"] as List)
                .map((item) => VisitaM6.fromJson(item))
                .toList();
          } else {
            debugPrint(json["resultado"]["pv_error_descripcion"].toString());
            //msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            throw Exception(json["resultado"]["pv_error_descripcion"].toString());
          }
        }
        else
        {
          msgxToast(json["resultado"]["pv_error_descripcion"]);
          debugPrint("Si funciona verificar el mensaje");
          if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
          }
        }
      }

    } catch (e) {
      debugPrint(e.toString());
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
      }
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

}

class VisitasRecibir
{


  String visitaId = "";
  String fecha = "";
  String hora = "";
  String observaciones = "";

  VisitasRecibir(this.visitaId,this.fecha,this.hora,this.observaciones);

  Future<List<Map<String, dynamic>>> VisitasM8()  async {
    debugPrint("**********G8***********");
    const String errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    String? cliente = prefs.getString("cliente");

    debugPrint(token);
    debugPrint("Empresa_Paquete");
    debugPrint(empresa);
    debugPrint(cliente);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_recibir");
      "${baseUrl}/portal/portal/visitas/visita_recibir");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": empresaID,
          "pn_visita": visitaId,
          "pf_fecha": fecha,
          "pf_hora": hora,
          "pv_observaciones": observaciones,

        }
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      final json = jsonDecode(response.body);

      debugPrint("Documentos_Paquetes_Editados");
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

}

class visitasListaB
{
  String propiedad = "";
  String clientez = "";


  visitasListaB(this.propiedad, this.clientez);

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
    debugPrint(clienteIDset);

    debugPrint(cliente);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_pendiente_listado");
      "${baseUrl}/portal/visitas/visita_pendiente_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pv_cliente": clienteIDset,
          "pv_propiedad": propiedad,
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint("Informacion Visitas");
      debugPrint(json["datos"][0]["pv_imagen_qrb64"].toString());
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
}
class crearVisitas
{
  String propiedad = "";
  String propiedadNombre = "";
  String clientez = "";
  String clientezNombre = "";
  String fecha = "";
  String hora = "";
  String motivoVisita = "";
  String nombreVisita = "";
  String visitaID = "";
  String visitaTelefono = "";
  String visitaTipoEntrada = "";
  String visitaPlaca = "";
  String observaciones = "";


  crearVisitas(this.propiedad,this.propiedadNombre,this.clientez,this.clientezNombre,this.fecha,
      this.hora,this.motivoVisita,this.nombreVisita,this.visitaID,this.visitaTelefono,this.visitaTipoEntrada,
      this.visitaPlaca,this.observaciones);

  Future<List<Map<String, dynamic>>>visitas7()async
  {
    debugPrint("**********M7***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint("Info Visitas");
    debugPrint(clienteIDset);

    debugPrint(cliente);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_creacion");
      "${baseUrl}/portal/visitas/visita_creacion");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
        "pn_empresa":empresaID,
        "pv_cliente":clientez,
        "pv_cliente_nombre":clientezNombre,
        "pv_propiedad":propiedad,
        "pv_propiedad_nombre":propiedadNombre,
        "pf_fecha":fecha,
        "pf_hora_llegada":hora,
        "pv_visita_motivo":motivoVisita,
        "pv_visita_nombre":nombreVisita,
        "pv_visita_no_identificacion":visitaID,
        "pv_visita_telefono":visitaTelefono,
        "pv_visita_entrada_tipo":visitaTipoEntrada,
        "pv_visita_vehiculo_placa":visitaPlaca,
        "pv_observaciones":observaciones
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Creacion de nueva visita !!!");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint("Creacion de nueva visita !!!");
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
}
class EditarVisita
{
  String propiedad = "";
  String propiedadNombre = "";
  String clientez = "";
  String clientezNombre = "";
  String fecha = "";
  String hora = "";
  String motivoVisita = "";
  String nombreVisita = "";
  String visitaID = "";
  String visitaTelefono = "";
  String visitaTipoEntrada = "";
  String visitaPlaca = "";
  String observaciones = "";


  EditarVisita(this.propiedad,this.propiedadNombre,this.clientez,this.clientezNombre,this.fecha,
      this.hora,this.motivoVisita,this.nombreVisita,this.visitaID,this.visitaTelefono,this.visitaTipoEntrada,
      this.visitaPlaca,this.observaciones);

  Future<List<Map<String, dynamic>>>visitas9()async
  {
    debugPrint("**********M9***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = empresaID;
    String? cliente = prefs.getString("cliente");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint("Info Visitas");
    debugPrint(clienteIDset);

    debugPrint(cliente);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/visitas/visita_edicion");
      "${baseUrl}/portal/visitas/visita_edicion");


      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
        "pn_empresa": empresaID,
        "pv_cliente": clientez,
        "pv_cliente_nombre": clientezNombre,
        "pv_propiedad": propiedad,
        "pv_propiedad_nombre": propiedadNombre,
        "pf_fecha": fecha,
        "pf_hora_llegada": hora,
        "pv_visita_motivo": motivoVisita,
        "pv_visita_nombre": nombreVisita,
        "pv_visita_no_identificacion": visitaID,
        "pv_visita_telefono": visitaTelefono,
        "pv_visita_entrada_tipo": visitaTipoEntrada,
        "pv_visita_vehiculo_placa": visitaPlaca,
        "pv_observaciones": observaciones
        }
      };

      http.Response response = await http.post(
          url,body: jsonEncode(body),headers:header);

      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("Editada de nueva visita !!!");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      debugPrint("Editada de nueva visita !!!");
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
}


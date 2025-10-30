import 'dart:convert';

import 'package:administra/app/controller/adm_renta_ventas_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api_Clases/class_Cuentas7.dart';
import '../../api_Clases/class_Document5.dart';
import '../../api_Clases/class_RentasVentas5.dart';
import '../../api_Clases/class_Reservas5.dart';
import '../../api_Clases/class_ReservasF1.dart';
import '../../api_Clases/class_Tickets5.dart';
import '../../route/my_route.dart';
import '../modal/adms_ImportanInfo.dart';
import '../modal/adms_category.dart';
import '../modal/adms_home_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'as devLog;

import 'adm_login_controller.dart';

class AdmCrearReservaController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());


  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }

  Future<List<DatosReservaF1>> amenidadesReservadasListaF1() async {
    debugPrint("**********F1***********");
    const errorMensaje = "Falla de conexión";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("Token");
    final empresa = empresaID;

    if (token == null || empresa == null) {
      debugPrint("❌ Token o Empresa no encontrados en SharedPreferences");
      return [];
    }

    try {
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse(
        "https://apidesa.komuvita.com/portal/amenidades/amenidades_listado");
          //"http://api.komuvita.com/portal/amenidades/amenidades_listado");

      final body = {
        "autenticacion": {"pv_token": token},
        "parametros": {"pn_empresa": empresaID},
      };

      final response =
      await http.post(url, body: jsonEncode(body), headers: headers);

      debugPrint("📤 Request Body: $body");
      debugPrint("📥 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        // Verificar si hubo error en la respuesta
        if (json["resultado"]["pn_error"] != 0) {
          throw Exception(json["resultado"]["pv_error_descripcion"]);
        }
        else if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
          {
            debugPrint("Si funciona verificar el mensaje");
            Get.offAllNamed(MyRoute.loginScreen);
          }

        // Si no hay datos
        if (json["datos"] == null || (json["datos"] as List).isEmpty) {
          debugPrint("⚠️ 'datos' vacío en la respuesta");
          return [];
        }

        // Mapear a la clase custom
        final lista = (json["datos"] as List)
            .map((item) => DatosReservaF1.fromJson(item))
            .toList();

        return lista;
      } else {


        throw Exception("❌ HTTP ${response.statusCode}");
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
  }
}

class reservaAmenidadCreacion
{
    String clienteNombre="";
    String propiedadID="";
    String porpiedadNombre="";
    String propiedadDireccion ="";
    String amenidad="";
    String fecha="";
    String horaInicio = "";
    String horaFin = "";
    String moneda = "";
    String valorA_Cobrar = "";
    String observaciones = "";


  reservaAmenidadCreacion(this.clienteNombre,this.propiedadID,this.porpiedadNombre,this.propiedadDireccion,this.amenidad,
      this.fecha,this.horaInicio,this.horaFin,this.moneda,this.valorA_Cobrar,this.observaciones);

    Future<List<Map<String, dynamic>>>reservaAmenidadCreacionF6()async
  {
    debugPrint("**********F6***********");
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
          "https://apidesa.komuvita.com/portal/amenidades/reserva_amenidad_creacion");
      //"http://api.komuvita.com/portal/amenidades/reserva_amenidad_creacion");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa":empresaID,
          "pv_cliente": clienteIDset,
          "pv_cliente_nombre":clienteNombre,
          "pv_propiedad": propiedadID,
          "pv_propiedad_nombre": propiedadDireccion,
          "pv_propiedad_direccion": propiedadDireccion,
          "pn_amenidad": amenidad,
          "pf_fecha": fecha,
          "pv_hora_inicio": horaInicio,
          "pv_hora_fin": horaFin,
          "pn_moneda": moneda,
          "pm_valor": valorA_Cobrar,
          "pv_observaciones": observaciones
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);

      debugPrint("Creacion_reservas6");
      debugPrint(body.toString());
      debugPrint(response.body.toString());

      if(response.statusCode == 200)
      {
        if (json["resultado"]["pn_error"] == 0)
        {  debugPrint(json["resultado"]["pv_error_descripcion"].toString());

        final datos = json["datos"];

        if (datos == null) {
          msgxToast(json["resultado"]["pv_error_descripcion"] );
          debugPrint("⚠️ 'datos' is null in response");
          return [];
        }

        if (datos is List) {
          msgxToast(json["resultado"]["pv_error_descripcion"] );
          var list = List<Map<String, dynamic>>.from(datos);
          debugPrint("✅ 'datos' is a List with ${list.length} items");
          return list;
        }

        if (datos is Map) {
          msgxToast(json["resultado"]["pv_error_descripcion"] );
          debugPrint("✅ 'datos' is a single Map, wrapping it in a List");
          return [Map<String, dynamic>.from(datos)];
        }

        debugPrint("⚠️ 'datos' has unexpected type: ${datos.runtimeType}");
        return [];
        }
        else
        {msgxToast(json["resultado"]["pv_error_descripcion"]);

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

        Get.offAllNamed(MyRoute.loginScreen);
      }
      //Get.back();
      return [];
    }
    return [];
  }
}




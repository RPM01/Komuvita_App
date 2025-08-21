import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:nb_utils/nb_utils.dart';
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

  //B5
  Future<List<Map<String, dynamic>>>importanInfo5()async
  {
    debugPrint("**********B5***********");
    String deviceName = "";
    String deviceID = "";
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/importantes/datos_importantes_listado");
      Map body = {
            "autenticacion":
            {
            "pv_token": token
            },
            "parametros":
            {
            "pn_empresa": int.parse(empresa!),
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
        if(json["resultado"]["pn_error"] == 0)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/noticias/noticias_listado");
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
        debugPrint("Noticias3");
        debugPrint(json["datos"][0]["pl_comentarios"][0]["pv_descripcion"].toString());

        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint("Noticias Error");
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
          // msgxToast(json["resultado"]["pv_error_descripcion"].toString());
         // throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      //Get.back();
      debugPrint("ErrorTest");
      debugPrint(e.toString());
      debugPrint(errorMensaje);
      showDialog(
        context: Get.context!,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(dialogContext).pop(); // Dismiss the dialog
          });
          return AlertDialog(
            title: Text(e.toString()),
            content: Text(errorMensaje),
          );
        },
      );
    }
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>listadoRentas5()async
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/rentasventas/rentas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
            "pn_empresa": int.parse(empresa!),
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
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/rentasventas/rentas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => RentaVentaD5.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/cosasperdidas/cosas_perdidas_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pv_criterio": "",
          "pn_resumen": "1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      //debugPrint(response.body.toString());
      debugPrint("Objetos Perdidos");
      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<Map<String, dynamic>>>amenidadesReservadas5()async
  {
    debugPrint("**********F5***********");
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/amenidades/reservas_amenidades_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<ReservasF5>>amenidadesReservadas5B()async
  {
    debugPrint("**********F5***********");
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
      var url = Uri.parse("https://apidesa.komuvita.com/portal/amenidades/reservas_amenidades_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => ReservasF5.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      //Get.back();
      debugPrint("Error Amenidades Reservadasdos");
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


  Future<List<Map<String, dynamic>>>GestionTickets5()async
  {
    debugPrint("**********G5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("Tickets!!!");
    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/tickets/gestiones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<TickestG5>>GestionTickets5B()async
  {
    debugPrint("**********G5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("Tickets!!!");
    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/tickets/gestiones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pn_periodo": "-1",
          "pv_cliente": prefs.getString("correo"),
          "pv_propiedad": "-1",
          "pn_gestion_tipo": "-1",
          "pn_estado": pn_estadoTickets,
          "pv_criterio": ""
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Tickets69");
      int totalWithGestion = (json['datos'] as List).where((item) => item['pn_gestion'] != null).length;
      debugPrint(totalWithGestion.toString());
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      devLog.log("Tickets69");
      devLog.log(response.body.toString());
      if(response.statusCode == 200)
      {
        //GestionTickets1();
        debugPrint("Regreso correcto!!!!!");
        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => TickestG5.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<TickestG5>>GestionTickets5BMes()async
  {
    debugPrint("**********G5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    debugPrint("Tickets!!!");
    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/tickets/gestiones_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
      debugPrint("Tickets69");

      debugPrint(json["datos"]["pn_gestion"].toString());
      int secondItemsLength = (json["datos"]["pn_gestion"] as List).length;
      debugPrint("Cantidad de gestiones");
      debugPrint(secondItemsLength.toString());
      devLog.log("Tickets69");
      devLog.log(response.body.toString());
      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!");
        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => TickestG5.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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


  Future<List<Map<String, dynamic>>>paqueteria5()async
  {
    debugPrint("**********L5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/paqueteria/paquete_pendiente_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pv_cliente": prefs.getString("cliente"),
          "pv_propiedad": "-1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("paquetes");
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<Map<String, dynamic>>>visitas5()async
  {
    debugPrint("**********M5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
    //GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/visitas/visita_pendiente_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
          "pv_cliente": prefs.getString("cliente"),
          "pv_propiedad": "-1",
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Objetos Perdidos");
      debugPrint("visitas");
      debugPrint(json["datos"][0]["pv_imagen_qrb64"].toString());
      debugPrint(body.toString());
      debugPrint(response.body.toString());
      if(response.statusCode == 200)
      {
        debugPrint("Regreso correcto!!!!!");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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

  Future<List<Map<String, dynamic>>>documentosListados5()async
  {
    debugPrint("**********H5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String? empresa = prefs.getString("Empresa");
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);
   // GestionTickets1();

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse("https://apidesa.komuvita.com/portal/cuentas/documentos_listado");
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": int.parse(empresa!),
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
        debugPrint("Regreso correcto!!!!!");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          return List<Map<String, dynamic>>.from(json["datos"]);
        }
        else
        {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
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
    String? empresa = prefs.getString("Empresa");

    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    //GestionTickets1();

    try {
      var header = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse("https://apidesa.komuvita.com/portal/cuentas/documentos_listado");

      Map<String, dynamic> body = {
        "autenticacion": {
          "pv_token": token
        },
        "parametros": {
          "pn_empresa": int.parse(empresa!),
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

      if (response.statusCode == 200) {
        debugPrint("Regreso correcto!!!!!");

        if (json["resultado"]["pn_tiene_datos"] == 1) {
          return (json["datos"] as List)
              .map((item) => DacumentosH5.fromJson(item))
              .toList();
        } else {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
          throw Exception(json["resultado"]["pv_error_descripcion"].toString());
        }
      } else {
        throw Exception("Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
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
      rethrow; // Keep the error in the Future
    }
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
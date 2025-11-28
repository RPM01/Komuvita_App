import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../route/my_route.dart';
import '../modal/adm_notification_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'as devLog;

import 'Dio_Controller.dart';
import 'adm_login_controller.dart';


class AdmNotificationController extends GetxController{



  RxList<NotificationModalData> listOfNotification = <NotificationModalData>[].obs;


  @override
  void onInit() {
    super.onInit();
    getNotificationDetail();
  }



  Future<List<Map<String, dynamic>>> getNotificationDetailTrue() async
  {
    debugPrint("**********G5***********");
    String errorMensaje = "Falla de conexión";
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("Token");
    String empresa = empresaID;
    debugPrint(token);
    debugPrint("Empresa");
    debugPrint(empresa);

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
          //"https://apidesa.komuvita.com/portal/notificaciones/notificaciones_listado"
          "$baseUrl/portal/notificaciones/notificaciones_listado"
      );
      Map body = {
        "autenticacion":
        {
          "pv_token": token
        },
        "parametros":
        {
          "pn_empresa": empresaID,
          "pn_notificacion_tipo": "-1",
          "pn_estado": "-1",
          "pv_criterio": ""
        }
      };

      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      //debugPrint("Tickets3");
      debugPrint(body.toString());
      debugPrint("Notificaciones");
      debugPrint(response.body.toString());
      if(response.statusCode == 200)
      {
        if(json["resultado"]["pv_error_descripcion"] == "El token ha expirado")
        {
          debugPrint("Si funciona verificar el mensaje");
          Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
        }

        if (json["resultado"]["pn_error"] == 0) {
          debugPrint(json["resultado"]["pv_error_descripcion"].toString());
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
            msgxToast(json["resultado"]["pv_error_descripcion"].toString());
            throw Exception(
                json["resultado"]["pv_error_descripcion"].toString());
          }
        }
      }
    }
    catch(e)
    {
      //Get.back();
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offAllNamed(MyRoute.loginScreen);
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


  Future<List<NotificationModalData>> getNotificationDetail() async {
    String jsonData = await rootBundle.loadString("assets/administra/data/adm_notification.json");
    dynamic data = json.decode(jsonData);
    List<dynamic> jsonArray = data['notification_list'];
    listOfNotification.clear();

    for (int i = 0; i < jsonArray.length; i++) {
      listOfNotification.add(NotificationModalData.fromJson(jsonArray[i]));
    }

    return listOfNotification;
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




}
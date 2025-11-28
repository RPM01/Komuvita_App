import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:administra/adm_theme/theme_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant/adm_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:developer'as devLog;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../route/my_route.dart';
import 'dart:convert';

import '../views/adm_paquetes/adm_paquetes_screen.dart';
import 'adm_home_controller.dart';
import 'package:administra/app/controller/Dio_Controller.dart';

List<int> empresasIdsSet = [];
List<String> empresasNombresSet = [];
List<String> empresasPropiedadSet = [];
List<String> clientesPropiedadSet = [];



List<String> clientesIdsSet = [];
List<String> propiedadesInternasIdsSet = [];
List<String> propiedadesInternaNombresSet = [];
List<String> propiedadesDireccionNombresSet = [];

List<String> clientesIdsSetB = [];
List<String> propiedadesInternasIdsSetB = [];
List<String> propiedadesInternaNombresSetB = [];
List<String> propiedadesDireccionNombresSetB = [];
String clienteIDset = "";
String empresaID = "";
String empresaNombreID = "";

class LoginController extends GetxController {
  AdmHomeController homeController = Get.put(AdmHomeController());
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final ThemeController themeController = Get.put(ThemeController());

  //final loading = RxBool(false);
  var isChecked= false.obs;
  final passwordVisible = true.obs;
  final formKey = GlobalKey<FormState>();

  final emailFieldFocused = false.obs;
  final passwordFieldFocused = false.obs;

  final isButtonEnabled = false.obs;




  Future<void> setRememberMe(String email, bool recuerdame) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Recuerdame", recuerdame);
    if (recuerdame) {
      await prefs.setString("correo", email);
    }
  }

   Future<void> getUserInfoB() async {
    final prefs = await SharedPreferences.getInstance();
    bool recuerdaMe = prefs.getBool("Recuerdame") ?? false;
    isChecked.value = recuerdaMe;

    if (recuerdaMe) {
      emailController.value.text = prefs.getString("correo") ?? '';
    }
  }



    Future<void>LogIn() async{
    debugPrint("*********************");
    String deviceName = "";
    String deviceID = "";
    String emailControllerText = emailController.value.text;
    String passwordControllerText = passwordController.value.text;
    String errorMensaje = "Falla de coneccino";
    List<String> myStringList = [];
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceID = build.id;
      deviceName = "Android";
      debugPrint("Android: $deviceID");
    }
    else if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceID = iosInfo.identifierForVendor.toString();
      deviceName = "Iphone";
      debugPrint("Iphone: $deviceID");
    }

    try
    {
      var header = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(
            "$baseUrl/administracion/usuarios/login");
          //"https://apidesa.komuvita.com/administracion/usuarios/login");
      Map body = {
        "autenticacion":
        {
          "pv_usuario": emailControllerText,
          "pv_clave": passwordControllerText,
          "pv_origen": "APP",
          "pv_identificador":deviceID
        }
      };
      http.Response response = await http.post(url,body: jsonEncode(body),headers:header);
      final json = jsonDecode(response.body);
      debugPrint("Info Login");
      debugPrint(body.toString());
      debugPrint(response.body.toString());


      if(response.statusCode == 200)
      {
        if(json["resultado"]["pn_error"] == 0)
          {

            debugPrint("Contraseña correcta");

            prefs.setString("Token", json["datos"]["pv_token"].toString());
            prefs.setString("Admin", json["datos"]["pn_administrador"].toString());
            prefs.setString("JuntaDirectiva", json["datos"]["pn_junta_directiva"].toString());
            debugPrint(prefs.getString("JuntaDirectiva"));
            prefs.setString("Empresa", json["datos"]["pl_empresas"][0][0]["pn_empresa"].toString());
            prefs.setString("correo",emailControllerText);
            prefs.setString("intruciones de pago",json["datos"]["pl_empresas"][0][0]["pv_instrucciones_pago"].toString());
            debugPrint("intruciones de pago");
            debugPrint(prefs.getString("intruciones de pago"));
            prefs.setString("NombreUser",json["datos"]["pv_usuario_nombre"].toString());
            //prefs.setString("UserCode",json["datos"]["pv_token"].toString());

            empresaID = json["datos"]["pl_empresas"][0][0]["pn_empresa"].toString();
            empresaNombreID = json["datos"]["pl_empresas"][0][0]["pv_empresa_nombre"].toString();

            final empresasList = json["datos"]["pl_empresas"] as List;

            debugPrint(empresasList.toString());
            final flatList = empresasList.expand((e) => e).toList();
            final List<int> empresasIds = flatList.map((e) => e["pn_empresa"] as int).toList();
            final List<String> empresasNombres = flatList.map((e) => e["pv_empresa_nombre"] as String).toList();
            final List<String> empresasPropiedad = flatList.map((e) => e["pv_propiedad_tipo"] as String).toList();



            empresasIdsSet = empresasIds;
            empresasNombresSet = empresasNombres;
            empresasPropiedadSet = empresasPropiedad;

            debugPrint("Info LogIn");
            debugPrint(empresasIds.toString());
            debugPrint(empresasNombres.toString());
            debugPrint(empresasPropiedad.toString());



            if(json["datos"]["pn_junta_directiva"] == 2)
            {
              debugPrint("Es Un Agente");
              GestionTickets1C();
            }
            else
            {
              GestionTickets1();
            }

            if(json["datos"]["pn_clave_vencida"] == 1)
            {
              msgxToast("Su contraseña se encuentra vencida");

              Get.toNamed(MyRoute.forgotPasswordScreen);

            }
            else
            {
              GestionTickets1();
            }
          }
        else{
          errorMensaje = json["resultado"]["pv_error_descripcion"].toString();
          msgxToast(json["resultado"]["pv_error_descripcion"].toString());
        }
      }
    }
    catch(e)
    {
      Get.back();
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
  }

  Future<List<Map<String, dynamic>>>GestionTickets1()async
  {

    debugPrint("**********G1***********");

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
          //"https://apidesa.komuvita.com/portal/tickets/propiedades_listado");
          "$baseUrl/portal/tickets/propiedades_listado");
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
      debugPrint("Lista Clientes");
       debugPrint( body.toString());
      debugPrint("clientes");

      debugPrint(json["datos"][0]["pv_cliente"].toString());
      debugPrint("Set cliente");
      clienteIDset = json["datos"][0]["pv_cliente"].toString();
      prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());
      debugPrint(prefs.getString("cliente"));
      String? clineteIDs = prefs.getString("cliente");
      debugPrint("$clineteIDs + LoL");
      //prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());

      //prefs.setStringList('ListaPropiedad', json["datos"]["pv_descripcion"]);
     // prefs.setStringList('ListaPropiedadID', json["datos"]["pn_propiedad"]);



      final empresasList = json["datos"] as List;

      debugPrint(empresasList.toString());


      //final List<int> propiedadIds = flatList.map((e) => e["pn_propiedad"] as int).toList();
      final List<String> clientesIds = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIds = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcion = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcion = empresasList.map((e) => e["pv_direccion"] as String).toList();

      final List<String> clientesIdsB = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIdsB = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcionB = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcionB = empresasList.map((e) => e["pv_direccion"] as String).toList();

      debugPrint("Propiedad_1");

      prefs.setStringList("clientesInternos", clientesIds);


      clientesIdsSet.clear();
      propiedadesInternasIdsSet.clear();
      propiedadesInternaNombresSet.clear();
      propiedadesDireccionNombresSet.clear();

      clientesIdsSetB.clear();
      propiedadesInternasIdsSetB.clear();
      propiedadesInternaNombresSetB.clear();
      propiedadesDireccionNombresSetB.clear();

      clientesIdsSetB = clientesIdsB;
      propiedadesInternasIdsSetB = propiedadIdsB;
      propiedadesInternaNombresSetB = propiedadDescripcionB;
      propiedadesDireccionNombresSetB = direccionDescripcionB;

      clientesIds.insert(0, "-1");
      propiedadIds.insert(0, "-1");
      propiedadDescripcion.insert(0, "Todos");
      direccionDescripcion.insert(0, "");

      clientesIdsSet = clientesIds;
      propiedadesInternasIdsSet = propiedadIds;
      propiedadesInternaNombresSet = propiedadDescripcion;
      propiedadesDireccionNombresSet = direccionDescripcion;



      debugPrint("clientes ID");
      debugPrint(clientesIds.toString());
      debugPrint(clientesIds.length.toString());
      debugPrint("propiedadesInternasIdsSet");
      debugPrint(propiedadesInternasIdsSet.toString());
      debugPrint(propiedadesInternasIdsSet.length.toString());
      debugPrint("propiedadesInternaNombresSet");
      debugPrint(propiedadesInternaNombresSet.toString());
      debugPrint(propiedadesInternaNombresSet.length.toString());
      debugPrint("propiedadesDireccionNombresSet");
      debugPrint(propiedadesDireccionNombresSet.toString());
      debugPrint(propiedadesDireccionNombresSet.length.toString());

      debugPrint("clientes IDB");
      debugPrint(clientesIdsSetB.toString());
      debugPrint(clientesIdsSetB.length.toString());
      debugPrint("propiedadesInternasIdsSetB");
      debugPrint(propiedadesInternasIdsSetB.toString());
      debugPrint(propiedadesInternasIdsSetB.length.toString());
      debugPrint("propiedadesInternaNombresSetB");
      debugPrint(propiedadesInternaNombresSetB.toString());
      debugPrint(propiedadesInternaNombresSetB.length.toString());
      debugPrint("propiedadesDireccionNombresSetB");
      debugPrint(propiedadesDireccionNombresSetB.toString());
      debugPrint(propiedadesDireccionNombresSetB.length.toString());


      prefs.setString("propiedad", json["datos"][0]["pn_propiedad"].toString());
      debugPrint(json["datos"][0]["pv_propiedad"].toString());

      debugPrint("Tickest100");
      debugPrint(response.body.toString());
      if(response.statusCode == 200)

      {
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          Get.offNamedUntil(MyRoute.home,(route) => route.isFirst,);
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
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offAllNamed(MyRoute.loginScreen);
      }
      debugPrint(e.toString());
      return [];
    }
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>GestionTickets1B()async
  {

    debugPrint("**********G1B***********");

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
          //"https://apidesa.komuvita.com/portal/tickets/propiedades_listado");
      "$baseUrl/portal/tickets/propiedades_listado");
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
      debugPrint("Objetos Perdidos");
      //debugPrint(response.body.toString());
      debugPrint("clientes");

      debugPrint(json["datos"][0]["pv_cliente"].toString());
      debugPrint("Set cliente");
      clienteIDset = json["datos"][0]["pv_cliente"].toString();
      prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());
      debugPrint(prefs.getString("cliente"));
      String? clineteIDs = prefs.getString("cliente");
      debugPrint("$clineteIDs + LoL");
      //prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());

      //prefs.setStringList('ListaPropiedad', json["datos"]["pv_descripcion"]);
      // prefs.setStringList('ListaPropiedadID', json["datos"]["pn_propiedad"]);



      final empresasList = json["datos"] as List;

      debugPrint(empresasList.toString());


      //final List<int> propiedadIds = flatList.map((e) => e["pn_propiedad"] as int).toList();
      final List<String> clientesIds = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIds = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcion = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcion = empresasList.map((e) => e["pv_direccion"] as String).toList();

      final List<String> clientesIdsB = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIdsB = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcionB = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcionB = empresasList.map((e) => e["pv_direccion"] as String).toList();

      debugPrint("Propiedad_1");

      prefs.setStringList("clientesInternos", clientesIds);


      clientesIdsSet.clear();
      propiedadesInternasIdsSet.clear();
      propiedadesInternaNombresSet.clear();
      propiedadesDireccionNombresSet.clear();

      clientesIdsSetB.clear();
      propiedadesInternasIdsSetB.clear();
      propiedadesInternaNombresSetB.clear();
      propiedadesDireccionNombresSetB.clear();

      clientesIdsSetB = clientesIdsB;
      propiedadesInternasIdsSetB = propiedadIdsB;
      propiedadesInternaNombresSetB = propiedadDescripcionB;
      propiedadesDireccionNombresSetB = direccionDescripcionB;


      clientesIds.insert(0, "-1");
      propiedadIds.insert(0, "-1");
      propiedadDescripcion.insert(0, "Todos");
      direccionDescripcion.insert(0, "");

      clientesIdsSet = clientesIds;
      propiedadesInternasIdsSet = propiedadIds;
      propiedadesInternaNombresSet = propiedadDescripcion;
      propiedadesDireccionNombresSet = direccionDescripcion;


      debugPrint("clientes ID");
      debugPrint(clientesIds.toString());
      debugPrint(clientesIds.length.toString());
      debugPrint("propiedadesInternasIdsSet");
      debugPrint(propiedadesInternasIdsSet.toString());
      debugPrint(propiedadesInternasIdsSet.length.toString());
      debugPrint("propiedadesInternaNombresSet");
      debugPrint(propiedadesInternaNombresSet.toString());
      debugPrint(propiedadesInternaNombresSet.length.toString());
      debugPrint("propiedadesDireccionNombresSet");
      debugPrint(propiedadesDireccionNombresSet.toString());
      debugPrint(propiedadesDireccionNombresSet.length.toString());

      debugPrint("clientes IDB");
      debugPrint(clientesIdsSetB.toString());
      debugPrint(clientesIdsSetB.length.toString());
      debugPrint("propiedadesInternasIdsSetB");
      debugPrint(propiedadesInternasIdsSetB.toString());
      debugPrint(propiedadesInternasIdsSetB.length.toString());
      debugPrint("propiedadesInternaNombresSetB");
      debugPrint(propiedadesInternaNombresSetB.toString());
      debugPrint(propiedadesInternaNombresSetB.length.toString());
      debugPrint("propiedadesDireccionNombresSetB");
      debugPrint(propiedadesDireccionNombresSetB.toString());
      debugPrint(propiedadesDireccionNombresSetB.length.toString());

      prefs.setString("propiedad", json["datos"][0]["pn_propiedad"].toString());
      debugPrint(json["datos"][0]["pv_propiedad"].toString());

      debugPrint("Tickest100");
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
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offAllNamed(MyRoute.loginScreen);
      }
      debugPrint(e.toString());
      return [];
    }
    throw Exception("Error en conexión");
  }

  Future<List<Map<String, dynamic>>>GestionTickets1C()async
  {

    debugPrint("**********G1C***********");

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
          //"https://apidesa.komuvita.com/portal/tickets/propiedades_listado");
      "$baseUrl/portal/tickets/propiedades_listado");
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
      debugPrint("Objetos Perdidos");
      //debugPrint(response.body.toString());
      debugPrint("clientes");

      debugPrint(json["datos"][0]["pv_cliente"].toString());
      debugPrint("Set cliente");
      clienteIDset = json["datos"][0]["pv_cliente"].toString();
      prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());
      debugPrint(prefs.getString("cliente"));
      String? clineteIDs = prefs.getString("cliente");
      debugPrint("$clineteIDs + LoL");
      //prefs.setString("cliente", json["datos"][0]["pv_cliente"].toString());

      //prefs.setStringList('ListaPropiedad', json["datos"]["pv_descripcion"]);
      // prefs.setStringList('ListaPropiedadID', json["datos"]["pn_propiedad"]);



      final empresasList = json["datos"] as List;

      debugPrint(empresasList.toString());


      //final List<int> propiedadIds = flatList.map((e) => e["pn_propiedad"] as int).toList();
      final List<String> clientesIds = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIds = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcion = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcion = empresasList.map((e) => e["pv_direccion"] as String).toList();

      final List<String> clientesIdsB = empresasList.map((e) => e["pv_cliente"] as String).toList();
      final List<String> propiedadIdsB = empresasList.map((e) => e["pn_propiedad"] as String).toList();
      final List<String> propiedadDescripcionB = empresasList.map((e) => e["pv_descripcion"] as String).toList();
      final List<String> direccionDescripcionB = empresasList.map((e) => e["pv_direccion"] as String).toList();

      debugPrint("Propiedad_1");

      prefs.setStringList("clientesInternos", clientesIds);


      clientesIdsSet.clear();
      propiedadesInternasIdsSet.clear();
      propiedadesInternaNombresSet.clear();
      propiedadesDireccionNombresSet.clear();

      clientesIdsSetB.clear();
      propiedadesInternasIdsSetB.clear();
      propiedadesInternaNombresSetB.clear();
      propiedadesDireccionNombresSetB.clear();

      clientesIdsSetB = clientesIdsB;
      propiedadesInternasIdsSetB = propiedadIdsB;
      propiedadesInternaNombresSetB = propiedadDescripcionB;
      propiedadesDireccionNombresSetB = direccionDescripcionB;


      clientesIds.insert(0, "-1");
      propiedadIds.insert(0, "-1");
      propiedadDescripcion.insert(0, "Todos");
      direccionDescripcion.insert(0, "");

      clientesIdsSet = clientesIds;
      propiedadesInternasIdsSet = propiedadIds;
      propiedadesInternaNombresSet = propiedadDescripcion;
      propiedadesDireccionNombresSet = direccionDescripcion;


      debugPrint("clientes ID");
      debugPrint(clientesIds.toString());
      debugPrint(clientesIds.length.toString());
      debugPrint("propiedadesInternasIdsSet");
      debugPrint(propiedadesInternasIdsSet.toString());
      debugPrint(propiedadesInternasIdsSet.length.toString());
      debugPrint("propiedadesInternaNombresSet");
      debugPrint(propiedadesInternaNombresSet.toString());
      debugPrint(propiedadesInternaNombresSet.length.toString());
      debugPrint("propiedadesDireccionNombresSet");
      debugPrint(propiedadesDireccionNombresSet.toString());
      debugPrint(propiedadesDireccionNombresSet.length.toString());

      debugPrint("clientes IDB");
      debugPrint(clientesIdsSetB.toString());
      debugPrint(clientesIdsSetB.length.toString());
      debugPrint("propiedadesInternasIdsSetB");
      debugPrint(propiedadesInternasIdsSetB.toString());
      debugPrint(propiedadesInternasIdsSetB.length.toString());
      debugPrint("propiedadesInternaNombresSetB");
      debugPrint(propiedadesInternaNombresSetB.toString());
      debugPrint(propiedadesInternaNombresSetB.length.toString());
      debugPrint("propiedadesDireccionNombresSetB");
      debugPrint(propiedadesDireccionNombresSetB.toString());
      debugPrint(propiedadesDireccionNombresSetB.length.toString());

      prefs.setString("propiedad", json["datos"][0]["pn_propiedad"].toString());
      debugPrint(json["datos"][0]["pv_propiedad"].toString());

      debugPrint("Tickest100");
      debugPrint(response.body.toString());
      if(response.statusCode == 200)

      {
        debugPrint("Regreso correcto");
        if(json["resultado"]["pn_tiene_datos"] == 1)
        {
          debugPrint("Debo ir a paquetes!!!");
          Get.offNamedUntil(MyRoute.paquetesListado,(route) => route.isFirst,);
          //Get.toNamed(MyRoute.paquetesListado);
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
      if(e.toString() == "Exception: El token ha expirado")
      {
        msgxToast(e.toString());
        debugPrint("Si funciona verificar el mensaje");

        Get.offAllNamed(MyRoute.loginScreen);
      }
      debugPrint(e.toString());
      return [];
    }
    throw Exception("Error en conexión");
  }


  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void updateButtonState() {
    isButtonEnabled.value = emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty;

  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    emailController.value.addListener(updateButtonState);
    passwordController.value.addListener(updateButtonState);
    updateButtonState();
    getUserInfoB();
  }
  @override
  void onClose() {
    super.onClose();
    emailController.value.dispose();
    passwordController.value.dispose();
  }



  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty ) {
      return enterYourEmail;
    }
    if(!regex.hasMatch(value)){
      return emailPattern;

    }
    else {
      return null;
    }
  }

  String? validatePassword(String? value1) {
    String pattern =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&])[A-Za-z\d@$#!%*?&]{8,}$";
    RegExp regex2 = RegExp(pattern);
    if (value1 == null || value1.isEmpty) {
      return requiredText;
    }

    if (!regex2.hasMatch(value1)) {
      return passwordValidation;
    }
    return null;
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
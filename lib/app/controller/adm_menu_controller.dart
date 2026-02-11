import 'dart:core';
import 'package:administra/app/views/adm_Comunicacion_Junta_Directiva/adm_Comunicacion_Junta_Directiva_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import all your app screens
import 'package:administra/app/views/adm_Renta_ventas/adm_Renta_Ventas_screen.dart';
import 'package:administra/app/views/adm_comunicacion_Admin_ticket/adm_comunicacion_Admin_ticket_screen.dart';
import 'package:administra/app/views/adm_estado_de_cuenta/adm_estado_de_cuenta_screen.dart';
import 'package:administra/app/views/adm_home/adm_home_screen.dart';
import 'package:administra/app/views/adm_news/adm_news_screen.dart';
import 'package:administra/app/views/adm_objetos_perdidos/adm_objetos_perdidos_screen.dart';
import 'package:administra/app/views/adm_password_creation/adm_password_creation_screen.dart';
import 'package:administra/app/views/adm_creacion_reserva/adm_creacion_reserva_screen.dart';
import 'package:administra/app/views/adm_paquetes/adm_paquetes_screen.dart';
import 'package:administra/adm_theme/theme_controller.dart';

// Import your Home controller
import '../views/adm_ComunicacionJuntadirectiva_ResultadoGestion/adm_ComunicacionJuntadirectiva_ResultadoGestion_screen.dart';
import '../views/adm_Visitas/adm_visitasA_screen.dart';
import '../views/adm_Visitas/adm_visitasB_screen.dart';
import 'adm_home_controller.dart';

class AdmMenuController extends GetxController {

  final ThemeController themeController = Get.put(ThemeController());
  final AdmHomeController homeController = Get.put(AdmHomeController());

  /// Reactive variables
  var isAdmin = false.obs;
  var jundaDir = false.obs;
  var helpAndSupport = <String>[].obs;
  var screens = <Widget>[].obs;
  var isMenuReady = false.obs;

  String adminCheck = "";
  String juntaDirec = "";
  String inquilino = "";

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Example flags for testing — set these in real usage
       adminCheck = prefs.getString("Admin") ?? "0";
       juntaDirec = prefs.getString("JuntaDirectiva") ?? "0";
       inquilino = prefs.getString("Inquilino") ?? "0";
      debugPrint("Info_Usuario");
      debugPrint(adminCheck.toString());
      debugPrint(juntaDirec.toString());
      debugPrint(inquilino.toString());

      isAdmin.value = adminCheck == "1";
      jundaDir.value = juntaDirec == "2";

      _setMenuForUser();

      isMenuReady.value = true;
    } catch (e) {
      debugPrint("Error loading user info: $e");
    }
  }

  /// Updates menu and screens according to user type
  void _setMenuForUser() {

    if (juntaDirec == "1") {
      // 👑 Admin menu
      helpAndSupport.assignAll([
        'Inicio',
        'Estado de cuenta',
        'Noticias y Avisos',
        'Rentas y Ventas',
        'Objetos Perdidos',
        'Reservar Amenidad',
        'Comunicación con Administrador',
        'Comunicación Junta',
        'Resultados Gestion',
        'Visitas',
        'Paquetes',
        //'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        AdmHomeScreen(),
        AdmEstadoDeCuentaScreen(),
        AdmNoticiasScreen(),
        AdmRentasVnetasScreen(),
        AdmObjetosPerdidsoScreen(),
        AdmCreacionReservaScreen(),
        AdmComunicacionAdministradorScreen(),
        AdmComunicacionJuntaDirectivaScreen(),
        AdmComunicacionJuntaDirectivaResultadoGestionScreen(),
        AdmVisitasBScreen(),
        AdmPaquetesListadosScreen(),

        //AdmPasswordCreationScreen(),
      ]);
    }
    else if (adminCheck == "1") {
      // 👑 Admin menu
      helpAndSupport.assignAll([
        'Inicio',
        'Estado de cuenta',
        'Noticias y Avisos',
        'Rentas y Ventas',
        'Objetos Perdidos',
        'Reservar Amenidad',
        'Comunicación con Administrador',
        'Comunicación Junta',
        'Resultados Gestion',
        'Visitas',
        'Paquetes',
        //'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        AdmHomeScreen(),
        AdmEstadoDeCuentaScreen(),
        AdmNoticiasScreen(),
        AdmRentasVnetasScreen(),
        AdmObjetosPerdidsoScreen(),
        AdmCreacionReservaScreen(),
        AdmComunicacionAdministradorScreen(),
        AdmComunicacionJuntaDirectivaScreen(),
        AdmComunicacionJuntaDirectivaResultadoGestionScreen(),
        AdmVisitasAScreen(),
        AdmPaquetesListadosScreen(),

        //AdmPasswordCreationScreen(),
      ]);
    }
    else if (juntaDirec == "2") {
      // 👥 Junta Directiva
      helpAndSupport.assignAll([
        //'Inicio',
        'Visitas',
        'Listado de Paquetes',
        //'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        //AdmHomeScreen(),
        AdmVisitasAScreen(),
        AdmPaquetesListadosScreen(),

        //AdmPasswordCreationScreen(),
      ]);
    }else if (inquilino == "1") {
      // 👑 Admin menu
      helpAndSupport.assignAll([
        'Inicio',
        //'Estado de cuenta',
        'Noticias y Avisos',
        'Rentas y Ventas',
        'Objetos Perdidos',
        'Reservar Amenidad',
        'Comunicación con Administrador',
        'Visitas',
        'Paquetes',
        //'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        AdmHomeScreen(),
        //AdmEstadoDeCuentaScreen(),
        AdmNoticiasScreen(),
        AdmRentasVnetasScreen(),
        AdmObjetosPerdidsoScreen(),
        AdmCreacionReservaScreen(),
        AdmComunicacionAdministradorScreen(),
        AdmVisitasBScreen(),
        AdmPaquetesListadosScreen(),

        //AdmPasswordCreationScreen(),
      ]);} else if (juntaDirec == "0") {
      // 👑 Admin menu
      helpAndSupport.assignAll([
        'Inicio',
        'Estado de cuenta',
        'Noticias y Avisos',
        'Rentas y Ventas',
        'Objetos Perdidos',
        'Reservar Amenidad',
        'Comunicación con Administrador',
        'Visitas',
        'Paquetes',
        //'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        AdmHomeScreen(),
        AdmEstadoDeCuentaScreen(),
        AdmNoticiasScreen(),
        AdmRentasVnetasScreen(),
        AdmObjetosPerdidsoScreen(),
        AdmCreacionReservaScreen(),
        AdmComunicacionAdministradorScreen(),
        AdmVisitasBScreen(),
        AdmPaquetesListadosScreen(),

        //AdmPasswordCreationScreen(),
      ]);

      /*
      // 🧍 Regular user
      helpAndSupport.assignAll([
        'Inicio',
        'Estado de cuenta',
        'Noticias y Avisos',
        'Rentas y Ventas',
        'Objetos Perdidos',
        'Reservar Amenidad',
        'Comunicación con Administrador',
        'Visitas',
        'Paquetes pendientes',
        'Cambio de contraseña',
        'Cerrar Sesión',
      ]);

      screens.assignAll([
        AdmHomeScreen(),
        AdmEstadoDeCuentaScreen(),
        AdmNoticiasScreen(),
        AdmRentasVnetasScreen(),
        AdmObjetosPerdidsoScreen(),
        AdmCreacionReservaScreen(),
        AdmComunicacionAdministradorScreen(),
        AdmVisitasBScreen(),
        AdmPaquetesListadosScreen(),
        AdmPasswordCreationScreen(),
      ]);
    */}
  }



  /// Called when a user taps a menu option
  void onMenuItemPressed(BuildContext context, String title) {
    // Always close the drawer first
    Navigator.pop(context);

    if (title == 'Paquetes pendientes') {
      // 👇 Trigger scroll on the home screen instead of navigating
      debugPrint("Bajando paquetes");

      return;
    }


    if (title == 'Cerrar Sesión') {

      debugPrint("Cerrando sesión...");
      return;
    }



    // Otherwise, navigate to the corresponding screen
    final index = helpAndSupport.indexOf(title);
    if (index != -1 && index < screens.length) {
      Get.to(() => screens[index]);
    }
  }
}

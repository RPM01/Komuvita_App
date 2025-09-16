import 'package:administra/app/views/adm_Renta_ventas/adm_Renta_Ventas_screen.dart';
import 'package:administra/app/views/adm_comunicacion_Admin_ticket/adm_comunicacion_Admin_ticket_screen.dart';
import 'package:administra/app/views/adm_estado_de_cuenta/adm_estado_de_cuenta_screen.dart';
import 'package:administra/app/views/adm_home/adm_home_screen.dart';
import 'package:administra/app/views/adm_news/adm_news_screen.dart';
import 'package:administra/app/views/adm_notification/adm_notification_screen.dart';
import 'package:administra/app/views/adm_objetos_perdidos/adm_objetos_perdidos_screen.dart';
import 'package:administra/app/views/adm_password_creation/adm_password_creation_screen.dart';
import 'package:get/get.dart';
import '../views/adm_creacion_reserva/adm_creacion_reserva_screen.dart';
import '../views/adm_privacy_policy/adm_privacy_policy_screen.dart';
import '../views/adm_terms_service/adm_terms_service_screen.dart';
import 'package:administra/adm_theme/theme_controller.dart';

class AdmMenuController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  List helpAndSupport = [
    'Inicio',
    'Estado de cuenta',
    'Noticias y Avisos',
    'Rentas y Ventas',
    'Objetos Perdidos',
    'Reservar Amenidad',
    'Comunicación con Administrador',
    //'Comunicación con Administrador',
    //'Visitas',
    //'Paquetes pendientes',
    //'Notificaciones',
    'Cambio de contraseña',
    'Cerrar Sesion',

  ];
  List screens = const [
    AdmHomeScreen(),
    AdmEstadoDeCuentaScreen(),
    AdmNoticiasScreen(),
    AdmRentasVnetasScreen(),
    AdmObjetosPerdidsoScreen(),
    AdmCreacionReservaScreen(),
    AdmComunicacionAdministradorScreen(),
    //AdmTermsAndServiceScreen(),
    //AdmPrivacyPolicyScreen(),
    //AdmTermsAndServiceScreen(),
    //AdmPrivacyPolicyScreen(),
    //AdmTermsAndServiceScreen(),
    //AdmPrivacyPolicyScreen(),
    //AdmTermsAndServiceScreen(),
    //AdmNotificationScreen(),
    AdmPasswordCreationScreen(),
   // AdmTermsAndServiceScreen(),
  ];
}
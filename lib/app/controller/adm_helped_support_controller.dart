import 'package:get/get.dart';

import '../views/adm_contact_support/adm_contact_support_screen.dart';
import '../views/adm_faq_screen/adm_faq.dart';
import '../views/adm_privacy_policy/adm_privacy_policy_screen.dart';
import '../views/adm_terms_service/adm_terms_service_screen.dart';

class AdmHelpAndSupportController extends GetxController {
  List helpAndSupport = [
    'Preguntas Frecuentes',
    'Contactar con Soporte',
    'Políticas de Privacidad',
    'Términos de Uso',
    'Partner',
    'Ofertas de empleo',
    'Accesibilidad',
    'Feedback',
    'Sobre Nosotros',
    'Califícanos',
    'Visite nuestro sitio web',
    'Síguenos en las Redes Sociales'
  ];
  List screens = const [
    AdmFaqScreen(),
    AdmContactSupportScreen(),
    AdmPrivacyPolicyScreen(),
    AdmTermsAndServiceScreen(),

  ];
}

import 'package:administra/app/views/adm_estado_de_cuenta/adm_estado_de_cuenta_screen.dart';
import 'package:administra/app/views/adm_home/adm_home_screen.dart';
import 'package:get/get.dart';

import '../app/views/adm_about_yourself/adm_about_yourself_screen.dart';
import '../app/views/adm_breed_preference/adm_breed_preference_screen.dart';
import '../app/views/adm_categories_screens/adm_categories_screen.dart';
import '../app/views/adm_chat/adm_chat_screen.dart';
import '../app/views/adm_chat/adm_message_screen.dart';
import '../app/views/adm_chat/adm_share_screen.dart';
import '../app/views/adm_chat/adm_video_call.dart';
import '../app/views/adm_chat/adm_voice_call.dart';
import '../app/views/adm_contact_support/adm_contact_support_screen.dart';
import '../app/views/adm_dashboard/adm_dashboard.dart';
import '../app/views/adm_detail/adm_detail_screen.dart';
import '../app/views/adm_faq_screen/adm_faq.dart';
import '../app/views/adm_favourites/adm_favourites_screen.dart';
import '../app/views/adm_final_steps/adm_final_step_screen.dart';
import '../app/views/adm_find_match/adm_find_match_screen.dart';
import '../app/views/adm_forgot_password/adm_forgot_password_screen.dart';
import 'package:administra/app/views/adm_menu/adm_menu.dart';
//import '../app/views/adm_location/adm_location_screen.dart';
import '../app/views/adm_login/adm_login_screen.dart';
import '../app/views/adm_notification/adm_notification_screen.dart';
import '../app/views/adm_onboaring/adm_onboarding_screen.dart';
import '../app/views/adm_other_category/adm_other_category.dart';
import '../app/views/adm_otp_code/adm_otp_code_screen.dart';
import '../app/views/adm_owner_detail/adm_owner_detail_screen.dart';
import '../app/views/adm_paquetes/adm_paquetes_screen.dart';
import '../app/views/adm_password_creation/adm_password_creation_screen.dart';
import '../app/views/adm_privacy_policy/adm_privacy_policy_screen.dart';
import '../app/views/adm_profile/app_appearence.dart';
import '../app/views/adm_profile/adm_app_language.dart';
import '../app/views/adm_profile/adm_data_anlystics.dart';
import '../app/views/adm_profile/adm_help_support.dart';
import '../app/views/adm_profile/adm_linked_accounts.dart';
import '../app/views/adm_profile/adm_my_profile_screen.dart';
import '../app/views/adm_profile/adm_notification.dart';
import '../app/views/adm_profile/adm_profile_screen.dart';
import '../app/views/adm_register/adm_register_screen.dart';
import '../app/views/adm_search/adm_search_screen.dart';
import '../app/views/adm_search_result/adm_search_result_screen.dart';
import '../app/views/adm_splash/adm_splash_screen.dart';
import '../app/views/adm_successfully_register/adm_successfully_register_screen.dart';
import '../app/views/adm_terms_service/adm_terms_service_screen.dart';
import '../app/views/adm_view_all/adm_view_all_screen.dart';
import '../app/views/adm_welcome/adm_welcome_screen.dart';

class MyRoute {
  /*------------------------------ Adm Adoption App -------------------------------------------*/
  static const admEstadoCuenta = '/adm_estado_de_cuenta';
  static const paquetesListado = "/adm_paquetes_screen.dart";
  static const admSplash = '/adm_splash';
  static const admOnboardingScreen = '/adm_onboarding';
  static const welcomeScreen = '/adm_welcome';
  static const loginScreen = '/adm_login';
  static const registerScreen = '/adm_register';
  static const forgotPasswordScreen = '/adm_forgot_password';
  static const otpCodeScreen = '/adm_otp_code';
  static const passwordCreation = '/adm_passwordCreation';
  static const successfullyRegister = '/adm_successfullyRegister';
  static const aboutYourselfScreen = '/adm_about_yourself';
  static const findScreen = '/adm_findScreen';
  static const breedScreen = '/adm_breedScreen';
  static const finalStep = '/adm_finalStep';
  static const dashboard = '/adm_dashboard';
  static const home = '/adm_home';
  static const location = '/adm_location';
  static const menu = '/adm_menu';
  static const favourite = '/adm_favourite';
  static const messageScreen = '/adm_chat';
  static const profile = '/adm_profile';
  static const admSearch = '/adm_search';
  static const admSearchResult = '/adm_searchResult';
  static const admDetail = '/adm_Detail';
  static const admOwnerDetail = '/adm_OwnerDetail';
  static const admNotification = '/adm_Notification';
  static const admCategories = '/adm_DogsCategories';
  static const admCats = '/adm_CatsCategories';
  static const admRabbits = '/adm_RabbitsCategories';
  static const admChats = '/adm_Chats';
  static const admVideoCall = '/adm_VideoCall';
  static const shareScreen = '/adm_shareScreen';
  static const admVoiceCall = '/adm_VoiceCall';
  static const admMyProfile = '/adm_MyProfile ';
  static const admProfileNotification = '/adm_ProfileNotification ';
  static const admLinked = '/adm_Linked';
  static const admData = '/adm_Data';
  static const admAppearance = '/adm_Appearance';
  static const admLanguage = '/adm_Language';
  static const admHelp = '/adm_Help';
  static const admFaq = '/adm_Faq';
  static const admContact = '/adm_Contact';
  static const admPrivacy = '/adm_privacy';
  static const admTerms = '/adm_Terms ';
  static const admView = '/adm_view ';
  static const admOther = '/adm_OtherCategory ';

  /*-----------------------------------------------------------------------------------*/

  static final routes = [
    /*------------------------------ Adm Adoption App-------------------------------------------*/
    GetPage(
      name: admSplash,
      page: () => const AdmSplashScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admEstadoCuenta,
      page: () => const AdmEstadoDeCuentaScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: paquetesListado,
      page: () => const AdmPaquetesListadosScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admOnboardingScreen,
      page: () => const AdmOnboardingScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: welcomeScreen, page: () => const AdmWelcomeScreen()), 
    GetPage(
      name: loginScreen,
      page: () => const AdmLoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: registerScreen,
      page: () => const AdmRegisterScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const AdmForgotPassword(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: otpCodeScreen, page: () => const AdmOtpCodeScreen()),
    GetPage(
        name: passwordCreation, page: () => const AdmPasswordCreationScreen()),
    GetPage(
        name: successfullyRegister,
        page: () => const AdmSuccessfullyRegister()),
    GetPage(name: aboutYourselfScreen, page: () => const AdmAboutYourself()),
    GetPage(name: findScreen, page: () => const AdmFindMatchScreen()),
    GetPage(name: breedScreen, page: () => const AdmBreedPreference()),
    GetPage(name: finalStep, page: () => const AdmFinalStepScreen()),
    GetPage(name: dashboard, page: () => const AdmDashboardScreen()),
    GetPage(name: home, page: () => const AdmHomeScreen()),
    GetPage(name: menu, page: () => const AdmMenu()),
    GetPage(name: favourite, page: () => const AdmFavouriteScreen()),
    GetPage(name: messageScreen, page: () => const AdmMessageScreen()),
    GetPage(name: profile, page: () => const AdmProfileScreen()),
    GetPage(
      name: admSearch,
      page: () => const AdmSearchScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admSearchResult,
      page: () => const AdmSearchResult(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admDetail,
      page: () => const AdmDetailScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admOwnerDetail,
      page: () => const AdmOwnerDetailScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admNotification,
      page: () => const AdmNotificationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admCategories,
      page: () => const AdmsCategoriesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admChats,
      page: () => const AdmChatScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admVideoCall,
      page: () => const AdmVideoCallScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: shareScreen, page: () => const AdmShareScreen()),
    GetPage(
      name: admVoiceCall,
      page: () => const AdmVoiceCallScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admMyProfile,
      page: () => const AdmMyProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admProfileNotification,
      page: () => const NotificationScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admLinked,
      page: () => const AdmLinkedAccounts(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admData,
      page: () => const AdmDataAnalytics(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admAppearance,
      page: () => AdmAppAppearance(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admLanguage,
      page: () => const AdmAppLanguage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: admHelp, page: () => const AdmHelpSupport()),
    GetPage(
      name: admFaq,
      page: () => const AdmFaqScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admContact,
      page: () => const AdmContactSupportScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admPrivacy,
      page: () => const AdmPrivacyPolicyScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admTerms,
      page: () => const AdmTermsAndServiceScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: admView,
      page: () => const AdmsViewAllScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: admOther, page: () => const AdmOtherCategoryScreen()),
    /*-----------------------------------------------------------------------------------*/
  ];
}

import 'package:get/get.dart';

import '../../constant/adm_images.dart';
import '../../constant/adm_strings.dart';

class AdmContactSupportController extends GetxController {
  List<Map<String, dynamic>> contactDetail = [
    {
      'name': customerSupportText,
      'image': customerSupport,
    },
    {
      'name': websiteText,
      'image': websiteImage,
    },
    {
      'name': whatsAppText,
      'image': whatsApp,
    },
    {
      'name': facebookText,
      'image': facebookImage,
    },
    {
      'name': twitterText,
      'image': newTwitterLogo,
    },
    {
      'name': instagram,
      'image': instagramImage,
    },
  ];
}

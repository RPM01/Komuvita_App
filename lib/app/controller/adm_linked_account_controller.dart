
import 'package:get/get.dart';

import '../../constant/adm_images.dart';
import '../../constant/adm_strings.dart';



class AdmLinkedAccountController extends GetxController {
  List<Map<String, dynamic>> accounts = [
    {'name': googleText, 'image': googleImg, 'Connected': 'Conectado', 'isSelected': false},
    {'name': appleText, 'image': appleImg, 'Connected': 'Conectado', 'isSelected': false},
    {'name': facebookText, 'image': facebookImg, 'Connected': 'Conectado', 'isSelected': false},
    {'name': twitterText, 'image': twitterImg, 'Connected': 'Conectado', 'isSelected': true},
  ];

}

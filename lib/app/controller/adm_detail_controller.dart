
import 'package:get/get.dart';
import '../modal/adms_home_modal.dart';
class AdmDetailController extends GetxController{

  late AdmsModal admDetail;
  var currentIndex = 1.obs;
  @override
  void onInit() {
    super.onInit();
    admDetail = Get.arguments as AdmsModal;
  }
  void toggleFavorite(AdmsModal adm) {
    adm.isFavorite.value = !adm.isFavorite.value;
  }
  void onPageChanged(int index) {
    currentIndex.value = index+1;
  }

}
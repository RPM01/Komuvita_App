import 'package:get/get.dart';
import '../../constant/adm_strings.dart';




class AdmOtpController extends GetxController {
  var isLoading = false.obs;
  var canResend = true.obs;
  var timerValue = 30.obs;
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    canResend.value = false;
    timerValue.value = 30;
    Future.delayed(const Duration(seconds: 1), countdown);
  }
  void countdown() {
    if (timerValue.value > 0) {
      timerValue.value--;
      Future.delayed(const Duration(seconds: 1), countdown);
    } else {
      canResend.value = true;
    }
  }

  void resendCode() async {
    if (canResend.value) {
      isLoading.value = true;
      try {

        Get.snackbar(
          success,
          codeRecentSuccessFully,
          snackPosition: SnackPosition.BOTTOM,

        );
        startTimer();
      } catch (error) {
        Get.snackbar(
          errorText,
          failedToResendCode,
          snackPosition: SnackPosition.BOTTOM,

        );
      } finally {
        isLoading.value = false;
      }
    }
  }

}
import 'package:get/get.dart';
// class AdmFaqData {
//   final String question;
//   final String answer;
//   RxBool isSelected = false.obs;
//
//   AdmFaqData(
//       {required this.question, required this.answer, bool isSelected = false})
//       : isSelected = isSelected.obs;
// }
// import 'package:get/get.dart';

class AdmFaqData {
  final String question;
  final String answer;
  final RxBool isExpanded;

  AdmFaqData({
    required this.question,
    required this.answer,
    bool isExpanded = false,
  }) : isExpanded = isExpanded.obs;
}

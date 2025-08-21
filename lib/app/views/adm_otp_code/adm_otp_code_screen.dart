import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../controller/adm_otp_controller.dart';

class AdmOtpCodeScreen extends StatefulWidget {
  const AdmOtpCodeScreen({super.key});

  @override
  State<AdmOtpCodeScreen> createState() => _AdmOtpCodeScreenState();
}

class _AdmOtpCodeScreenState extends State<AdmOtpCodeScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  final AdmOtpController controller = Get.put(AdmOtpController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: commonAppBar(image: '', context: context, text: '', theme: theme),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                enterCode,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              20.height,
              Text(
                codeDes,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              25.height,
              OtpInputField(
                otpInputFieldCount: 4,
                width: 0.2,
                onOtpEntered: (otp) {
                  // print('Entered OTP: $otp');
                  // Perform actions with the entered OTP
                },
              ),
              25.height,
              Obx(
                () {
                  return !controller.canResend.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              resendCodeDes,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            3.width,
                            Text(
                              '00:${controller.timerValue.value.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: admColorPrimary,
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            controller.resendCode();
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              resendCode,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: darkGreyColor,

                              ),

                            ),
                          ),
                        );
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text: receiveCode,
                  //     style: theme.textTheme.bodySmall?.copyWith(
                  //       fontWeight: FontWeight.w500,
                  //       color: controller.themeController.isDarkMode?smartWhiteColor:smartMainTextColor,
                  //     ),
                  //     children: [
                  //       const WidgetSpan(child: SizedBox(width: 5)),
                  //
                  //       TextSpan(
                  //         recognizer: TapGestureRecognizer()..onTap = () => () {
                  //           controller.resendCode();
                  //         },
                  //         text: sendAgain,
                  //         style: theme.textTheme.bodySmall?.copyWith(
                  //             fontWeight: FontWeight.w500,
                  //             color: smartColorPrimary,
                  //             decoration: TextDecoration.underline,
                  //             decorationColor: smartColorPrimary,
                  //             decorationThickness: 1.5
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
              ),
              20.height,

            ],
          ),
        ),
      ),
    );
  }
}

class OtpInputField extends StatefulWidget {
  final int otpInputFieldCount;
  final double width;
  final Function(String) onOtpEntered;

  const OtpInputField({
    Key? key,
    required this.otpInputFieldCount,
    required this.width,
    required this.onOtpEntered,
  }) : super(key: key);

  @override
  OtpInputFieldState createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  late List<String> otpNumbers;
  late List<FocusNode> focusNodes;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    otpNumbers = List.filled(widget.otpInputFieldCount, '');
    focusNodes = List.generate(widget.otpInputFieldCount, (_) => FocusNode());
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.otpInputFieldCount,
        (index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * widget.width,
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {}); // Update UI when focus changes
              },
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                key: Key('otpField_$index'),
                autofocus: index == 0,
                focusNode: focusNodes[index],
                onChanged: (value) {
                  otpNumbers[index] = value;
                  if (value.isNotEmpty &&
                      index < widget.otpInputFieldCount - 1) {
                    focusNodes[index + 1].requestFocus();
                  }
                  if (otpNumbers.every((String value) => value.isNotEmpty)) {
                    widget.onOtpEntered(otpNumbers.join());
                    Get.toNamed(MyRoute.passwordCreation);
                  }
                },
                keyboardType: TextInputType.number,
                maxLength: 1,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: focusNodes[index].hasFocus
                      ? Get.isDarkMode
                          ? admDarkPrimaryColor
                          : lightPrimaryColor
                      : Get.isDarkMode
                          ? admDarkBorderColor
                          : lightGreyColor,
                  counterText: "",
                  border: InputBorder.none,

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: admColorPrimary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

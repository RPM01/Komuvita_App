
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/app/controller/adm_forgot_password_controller.dart';
import 'package:administra/widgets/common_button.dart';
import 'package:administra/route/my_route.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import 'package:get/get.dart';

import '../../../widgets/custum_textfeild.dart';

class AdmForgotPassword extends StatefulWidget {
  const AdmForgotPassword({super.key});

  @override 
  State<AdmForgotPassword> createState() => _AdmForgotPasswordState();
}

class _AdmForgotPasswordState extends State<AdmForgotPassword> {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: PrimaryButton(text: sendOtpCode,onTap: (){
        controller.resetPassword();
        //Get.toNamed(MyRoute.passwordCreation);
      },),
        appBar:
            commonAppBar(image: '', context: context, text: '', theme: theme),
        body: GetBuilder<ForgotPasswordController>(
            init: controller,
            tag: 'adm_forgot_password',
            // theme: theme,
            builder: (controller) => (Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              forgotYourPassword,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            20.height,
                            Text(
                              forgotDes,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            25.height,
                            Text(
                              yourRegisteredEmail,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              onFieldSubmitted: (p0) {
                                controller.resetPassword();
                                //Get.toNamed(MyRoute.passwordCreation);
                                //Get.toNamed(MyRoute.otpCodeScreen);
                              },
                              focusNode: FocusNode(
                                onKeyEvent: (node, event) {
                                  if (event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
                                    node.unfocus();
                                    controller.formKey.currentState?.validate();
                                    return KeyEventResult.handled;
                                  }
                                  return KeyEventResult.ignored;
                                },
                              ),
                              onChanged: (value) {
                                controller.emailController.value.text = value;
                              },
                              autovalidateMode: controller.emailFieldFocused.value
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              textEditingController:
                                  controller.emailController.value,
                              hintText: email,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  mail,
                                  height: 15,
                                  width: 15,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)
                                ),
                              ),
                              obscureText: false,
                              validator: controller.validateEmail,
                              textInputAction: TextInputAction.done,

                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ))));
  }
}

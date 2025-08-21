import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/custum_textfeild.dart';
import '../../controller/adm_register_controller.dart';
import '../adm_terms_service/adm_terms_service_screen.dart';

class AdmRegisterScreen extends StatefulWidget {
  const AdmRegisterScreen({super.key});

  @override
  State<AdmRegisterScreen> createState() => _AdmRegisterScreenState();
}

class _AdmRegisterScreenState extends State<AdmRegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());
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
        bottomNavigationBar:Obx(() =>  MyButton(
          text: signUp,
          color: controller.isButtonEnabled.value
              ? admColorPrimary
              : admColorDarkPrimary.withOpacity(0.20),
          onTap: () => controller.isButtonEnabled.value
              ? (controller.formKey.currentState?.validate() ?? false)

              ? showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(
                  const Duration(seconds: 2),
                    () {
                  Get.back();
                  Get.toNamed(MyRoute.aboutYourselfScreen); // Navigate
                },

              );
              return AlertDialog(
                backgroundColor:
                Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
                content: SizedBox(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: admColorPrimary,
                        valueColor: AlwaysStoppedAnimation(
                            admWhiteColor.withOpacity(0.7)),
                        strokeWidth: 6,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      20.height,
                      Text(
                        signUpHere,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },)
              : controller.formKey.currentState?.validate()
              : null,

        ),),

        appBar: commonAppBar(
            image: '',
            context: context,
            text: 'Registro',
            theme: theme),
        body: GetBuilder<RegisterController>(
            init: controller,
            tag: 'adm_register',
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
                              justAdt,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            10.height,
                            Text(
                              justDes,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            25.height,
                            Text(
                              controller.emailController.value.text,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              autofocus: true,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).nextFocus(); // Move focus to the next field
                              },
                              onChanged: (value) {
                                controller.emailController.value.text = value;
                                controller.emailFieldFocused.value = true;
                                controller.passwordFieldFocused.value = false;
                                },
                              autovalidateMode: controller.emailFieldFocused.value
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                              textEditingController: controller.emailController.value,
                              hintText: email,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(mail,
                                    height: 15,
                                    width: 15,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)),
                              ),
                              obscureText: false,
                              validator: controller.validateEmail,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            20.height,
                            Text(
                              controller.passwordController.value.text,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              autofocus: true,
                              onChanged: (value) {
                                controller.passwordController.value.text = value;
                                  controller.emailFieldFocused.value = false;
                                  controller.passwordFieldFocused.value = true;
                                  },
                              autovalidateMode:
                                  controller.passwordFieldFocused.value
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                              textInputAction: TextInputAction.done,
                              textEditingController:
                                  controller.passwordController.value,
                              hintText: password,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(lock,
                                    height: 22,
                                    width: 22,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.passwordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor),
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                              ),
                              obscureText: controller.passwordVisible.value,
                              validator: controller.validatePassword,
                            ),
                            10.height,
                            Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    checkColor: admWhiteColor,
                                    activeColor: admColorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    side: WidgetStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                          width: 2.0, color: admColorPrimary),
                                    ),
                                    // autofocus: true,
                                    value: controller.isChecked.value,
                                    onChanged: (value) {
                                      controller.isChecked.value = value!;
                                      controller.updateButtonState();
                                    },
                                  ),
                                ),
                                5.width,
                                Text(agree,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    )
                                ),
                                TextButton(onPressed: ()
                                {
                                  debugPrint("Presionado Terminos y condiciones");
                                  Get.to(AdmTermsAndServiceScreen());
                                },
                                    child: Text(termsAndConditions,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(
                                      fontSize: MediaQuery.of(context).size.width*0.035,
                                      fontWeight: FontWeight.w500,
                                      color: admColorPrimary),
                                      maxLines: 2,
                                ))
                              ],
                            ),
                            20.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  alreadyAccount,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offNamed(MyRoute.loginScreen);
                                  },
                                  child: Text(
                                    signIn,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: admColorPrimary),
                                  ),
                                ),
                              ],
                            ),
                            //20.height,
                            //Row(children: <Widget>[
                            //  Expanded(
                            //      child: Divider(
                            //    color: Get.isDarkMode
                            //        ? admDarkLightColor
                            //        : greyColor,
                            //  )),
                            //  10.width,
                            //  Text(
                            //    or,
                            //    style: theme.textTheme.labelSmall?.copyWith(
                            //      fontWeight: FontWeight.w500,
                            //    ),
                            //  ),
                            //  10.width,
                            //  Expanded(
                            //      child: Divider(
                            //    color: Get.isDarkMode
                            //        ? admDarkLightColor
                            //        : greyColor,
                            //  )),
                            //]),
                            //20.height,
                            //const CustomButton(
                            //  text: google,
                            //  image: googleImg,
                            //),
                            //15.height,
                            //CustomButton(
                            //  text: apple,
                            //  image: appleImg,
                            //  color: Get.isDarkMode
                            //      ? admWhiteColor
                            //      : admBlackColor,
                            //),
                            //15.height,
                            //const CustomButton(
                            //  text: facebook,
                            //  image: facebookImg,
                            //),
                            //15.height,
                            //twitterButton(theme),
                            // const CustomButton(
                            //   text: twitter,
                            //   image: twitterImg,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))));
  }
}

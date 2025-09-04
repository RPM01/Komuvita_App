import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/widgets/common_button.dart';
import 'package:administra/route/my_route.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_appbar.dart';
import 'package:get/get.dart';
import '../../../widgets/custum_textfeild.dart';
import '../../controller/adm_password_creation_controller.dart';
class AdmPasswordCreationScreen extends StatefulWidget {
  const AdmPasswordCreationScreen({super.key});

  @override
  State<AdmPasswordCreationScreen> createState() => _AdmPasswordCreationScreenState();
}

class _AdmPasswordCreationScreenState extends State<AdmPasswordCreationScreen> {
  late ThemeData theme;
  final PasswordCreationController controller = Get.put(PasswordCreationController());

  @override
  void initState() {
    super.initState();
    theme = Get.isDarkMode ? AdmTheme.admDarkTheme : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: PrimaryButton(
        text: saveNewPassword,
        onTap: (){
          if (controller.formKey.currentState?.validate() ??
              false) {
            controller.cambioPassWord();
          } else {
            // Form is not valid, auto-validate the form
            controller.formKey.currentState?.validate();
          }
        },
      ),
      appBar: commonAppBar(image: '', context: context, text: '', theme: theme),
        body: GetBuilder<PasswordCreationController>(
            init: controller,
            tag: 'adm_passwordCreation',
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
                              secureAccount,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            20.height,
                            Text(
                              secureDes,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            25.height,
                            Text(
                              oldPassword,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              autofocus: true,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(controller.confirmPasswordFocusNode);
                              },
                              onChanged: (value) {
                                controller.oldPasswordController.value.text = value;
                                controller.oldPasswordFocused.value = true;
                                controller.oldPasswordVisible.value = false;
                              },

                              autovalidateMode: controller.oldPasswordFocused.value
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              textInputAction: TextInputAction.next,
                              textEditingController:
                              controller.oldPasswordController.value,
                              hintText: password,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                    lock,
                                    height: 22,
                                    width: 22,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.oldPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor),
                                onPressed: () {
                                  controller.oldPasswordVisibility();
                                },
                              ),
                              obscureText: controller.oldPasswordVisible.value,
                              //validator: controller.validatePassword,
                            ),
                            25.height,
                            Text(
                              newPassword,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              autofocus: true,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(controller.confirmPasswordFocusNode);
                              },
                              onChanged: (value) {
                                controller.newPasswordController.value.text = value;
                                controller.newPasswordFocused.value = true;
                                controller.confirmPasswordFocused.value = false;

                              },
                              autovalidateMode: controller.newPasswordFocused.value
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              textInputAction: TextInputAction.next,
                              textEditingController:
                              controller.newPasswordController.value,
                              hintText: password,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  lock,
                                  height: 22,
                                  width: 22,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.newPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor),
                                onPressed: () {
                                  controller.newPasswordVisibility();
                                },
                              ),
                              obscureText: controller.newPasswordVisible.value,
                              //validator: controller.validatePassword,
                            ),
                            20.height,
                            Text(
                              confirmPassword,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            10.height,
                            CustomTextField(
                              focusNode: controller.confirmPasswordFocusNode,
                              onChanged: (value) {
                                controller.confirmPasswordController.value.text = value;
                                controller.confirmPasswordFocused.value = true;
                                  controller.newPasswordFocused.value = false;
                              },
                              autovalidateMode: controller.confirmPasswordFocused.value
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              textInputAction: TextInputAction.done,
                              textEditingController: controller.confirmPasswordController.value,
                              hintText: password,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  lock,
                                  height: 22,
                                  width: 22,
                                    colorFilter: ColorFilter.mode(
                                        Get.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                        BlendMode.srcIn)
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    controller.confirmPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Get.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor),
                                onPressed: () {
                                  controller.confirmPasswordVisibility();
                                },
                              ),
                              obscureText: controller.confirmPasswordVisible.value,
                              validator: controller.validateRepeatPassword,

                            ),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                            Get.isDarkMode ? admDarkBorderColor : admWhiteColor,
                                            content: SizedBox(
                                              height: 160,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                   Text("Lamentamos que desee remover su cuenta de Komuvita. Nuestro administrador se pondrá en contacto con usted para continuar con el proceso"),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                                  ),
                                                  child:  Text('Aceptar',style: TextStyle(fontSize: 20),),
                                                  onPressed: () {
                                                    Get.back();
                                                    Get.offAllNamed(MyRoute.loginScreen);
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                    );
                                },
                                child: Text(
                                  "Eliminar mi cuenta",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Get.isDarkMode
                                        ? admWhiteColor
                                        : admColorPrimary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              )
            )
        )
    );
  }
}


void msgxToast(String msxg){

  Fluttertoast.showToast(
    msg: msxg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 20,
  );
}









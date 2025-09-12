import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:administra/constant/adm_colors.dart';
import 'package:administra/route/my_route.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/custum_textfeild.dart';
import '../../controller/adm_login_controller.dart';
import 'package:get/get.dart';

class AdmLoginScreen extends StatefulWidget {
  const AdmLoginScreen({super.key});

  @override
  State<AdmLoginScreen> createState() => _AdmLoginScreenState();
}

class _AdmLoginScreenState extends State<AdmLoginScreen> {

  final LoginController controller = Get.put(LoginController());
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    getUserInfo();

    theme = controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }


  String userName ="";
  void setRememeberMe(String email,bool recuerdame) async
  {
    final prefs = await SharedPreferences.getInstance();
    userName =  prefs.getString("correo")!;

    setState(() {
      prefs.setBool("Recuerdame", recuerdame);
      debugPrint("Recuerdame...");
      debugPrint(recuerdame.toString());
      if(recuerdame == true)
      {
        controller.emailController.value.text = userName;
      }
    });
  }

  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
    bool? recuerdaMe = prefs.getBool("Recuerdame");
    debugPrint("Recuerdame2...");
    debugPrint(recuerdaMe.toString());
      if(recuerdaMe == true)
      {
        //LoginController.emailController().text = prefs.getString("correo")!;
        userName =  prefs.getString("correo")!;
      }
    setRememeberMe(userName,recuerdaMe!);
    });

  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: theme.scaffoldBackgroundColor,
         /* bottomNavigationBar: Obx(
            () => MyButton(
              text: signIn,
              color: controller.isButtonEnabled.value
                  ? admColorPrimary
                  : admColorDarkPrimary.withOpacity(0.20),
              onTap: () => controller.isButtonEnabled.value
                  ? (controller.formKey.currentState?.validate() ?? false)
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(
                                const Duration(seconds: 1),
                                    () {
                                  Get.back();
                                  //debugPrint("TEST....");
                                  controller.LogIn();
                                },
                            //     () =>
                            //         //Get.toNamed(MyRoute.dashboard)
                            //        // Get.offNamedUntil('/adm_dashboard', ModalRoute.withName(MyRoute.dashboard)));
                            // Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,)
                                );
                            return AlertDialog(
                              backgroundColor:
                                  controller.themeController.isDarkMode
                                      ? admDarkBorderColor
                                      : admWhiteColor,
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
                                      signInHere,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: controller
                                                  .themeController.isDarkMode
                                              ? admWhiteColor
                                              : admTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : controller.formKey.currentState?.validate()
                  : null,
            ),
          ),
          */

          // appBar: commonAppBar(image: '', context: context, text: '', theme: theme),
          body: SafeArea(
            child: GetBuilder<LoginController>(
              init: controller,
              tag: 'adm_login',
              builder: (controller) => Obx(
                    () => Stack(
                      fit: StackFit.expand,
                  children: [
                    // Background image
                     Positioned.fill(
                      child: Image.asset(
                        banner, // your asset path constant
                        fit: BoxFit.fill,
                      ),
                    ),

                     Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            12.height,
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                              child: Image.asset(logoLogin),
                            ),
                            Card(
                              elevation: 8,
                              color: Colors.white.withOpacity(1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: controller.formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Ingresar",
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      10.height,
                                      Text(
                                        "Inicie sesión para continuar",
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      12.height,
                                      25.height,

                                      /// Email field
                                      CustomTextField(
                                        autofocus: true,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(context).nextFocus();
                                        },
                                        onChanged: (value) {
                                          controller.emailFieldFocused.value = true;
                                          controller.passwordFieldFocused.value = false;
                                          controller.emailController.value.text = value;
                                        },
                                        autovalidateMode: controller.emailFieldFocused.value
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        textEditingController:
                                        controller.emailController.value,
                                        hintText: user,
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            userProfile,
                                            height: 15,
                                            width: 15,
                                            colorFilter: ColorFilter.mode(
                                              Get.isDarkMode ? admWhiteColor : admTextColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        obscureText: false,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      20.height,

                                      /// Password field
                                      CustomTextField(
                                        autofocus: true,
                                        onChanged: (value) {
                                          controller.emailFieldFocused.value = false;
                                          controller.passwordFieldFocused.value = true;
                                          controller.passwordController.value.text = value;
                                        },
                                        autovalidateMode: controller.passwordFieldFocused.value
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        textInputAction: TextInputAction.done,
                                        textEditingController:
                                        controller.passwordController.value,
                                        hintText: password,
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            lock,
                                            height: 22,
                                            width: 22,
                                            colorFilter: ColorFilter.mode(
                                              Get.isDarkMode ? admWhiteColor : admTextColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            controller.passwordVisible.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Get.isDarkMode
                                                ? admWhiteColor
                                                : admTextColor,
                                          ),
                                          onPressed: () {
                                            controller.togglePasswordVisibility();
                                          },
                                        ),
                                        obscureText: controller.passwordVisible.value,
                                      ),
                                      10.height,

                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Checkbox(
                                              checkColor: admWhiteColor,
                                              activeColor: admColorPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              side: WidgetStateBorderSide.resolveWith(
                                                    (states) => const BorderSide(
                                                  width: 2.0,
                                                  color: admColorPrimary,
                                                ),
                                              ),
                                              value: controller.isChecked.value,
                                              onChanged: (value) {
                                                controller.isChecked.value = value!;
                                                setRememeberMe(
                                                  controller.emailController.value.text,
                                                  controller.isChecked.value,
                                                );
                                              },
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: Text(
                                              rememberMe,
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: controller.themeController.isDarkMode
                                                    ? admWhiteColor
                                                    : admTextColor,
                                                  fontSize: MediaQuery.of(context).size.width*0.030
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(MyRoute.forgotPasswordScreen);
                                            },
                                            child: Text(
                                              forgotPassword,
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Get.isDarkMode
                                                    ? admWhiteColor
                                                    : admColorPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      20.height,
                                      /// Sign up row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            doNotHaveAnAccount,
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: MediaQuery.of(context).size.width*0.035
                                            ),
                                          ),
                                          3.width,
                                          InkWell(
                                            onTap: () {
                                                Get.toNamed(MyRoute.registerScreen);
                                            },
                                            child: Text(
                                              signUp,
                                              style: theme.textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: admColorPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      MyButton(
                                        text: signIn,
                                        color: controller.isButtonEnabled.value
                                            ? Color.fromRGBO(34,55,74,1)
                                            : Color.fromRGBO(83,139,189,1).withOpacity(0.20),
                                        onTap: () => controller.isButtonEnabled.value
                                            ? (controller.formKey.currentState?.validate() ?? false)
                                            ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(
                                              const Duration(seconds: 1),
                                                  () {
                                                Get.back();
                                                //debugPrint("TEST....");
                                                controller.LogIn();
                                              },
                                              //     () =>
                                              //         //Get.toNamed(MyRoute.dashboard)
                                              //        // Get.offNamedUntil('/adm_dashboard', ModalRoute.withName(MyRoute.dashboard)));
                                              // Get.offNamedUntil(MyRoute.dashboard,(route) => route.isFirst,)
                                            );
                                            return AlertDialog(
                                              backgroundColor:
                                              controller.themeController.isDarkMode
                                                  ? admDarkBorderColor
                                                  : admWhiteColor,
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
                                                      signInHere,
                                                      style: theme.textTheme.titleLarge?.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          color: controller
                                                              .themeController.isDarkMode
                                                              ? admWhiteColor
                                                              : admTextColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                            : controller.formKey.currentState?.validate()
                                            : null,
                                      ),
                                      /*
                                      10.height,
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
                                                            Get.back();
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
                                      ),
                                       */
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}

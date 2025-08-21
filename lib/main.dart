import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'adm_theme/adm_theme.dart';
import 'adm_theme/theme_controller.dart';
import 'route/my_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ThemeController controller = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark,
      statusBarIconBrightness:
          Get.isDarkMode ? Brightness.light : Brightness.dark,
    ));
    return Obx(
      () {
        return GetMaterialApp(
          locale: const Locale('es', 'ES'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'), // Asegúrate de agregar el idioma español
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: controller.isDarkMode
              ? AdmTheme.admDarkTheme
              : AdmTheme.admLightTheme,
          getPages: MyRoute.routes,
          initialRoute: MyRoute.admSplash,
          // home: BottomNavBar(),
        );
      },
      // ),
    );
  }
}

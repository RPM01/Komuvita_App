import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:administra/app/controller/adm_noticias_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/app/views/adm_view_all/adm_view_all_screen.dart';
import 'package:administra/widgets/common_progress.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_Clases/class_Document5.dart';
import '../../../api_Clases/class_RentasVentas5.dart';
import '../../../api_Clases/class_Reservas5.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../../widgets/home_widgets.dart';
import '../../../widgets/adm_detail_view.dart';
import '../../controller/adm_home_controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import '../../controller/adm_noticias_controller.dart';
import '../../modal/adms_home_modal.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../adm_menu/adm_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image/image.dart' as img;
//import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class AdmNoticiasScreen extends StatefulWidget {
  const AdmNoticiasScreen({super.key});

  @override
  State<AdmNoticiasScreen> createState() => _AdmNoticiasScreenState();
  
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmNoticiasScreenState extends State<AdmNoticiasScreen>
{
  late ThemeData theme;

  String? selectedValueA;
  String? selectedValueB;
  String? selectedValueC;

  AdmMenuController menuController = Get.put(AdmMenuController());
  AdmNoticiasController newsController = Get.put(AdmNoticiasController());

  String userName = "";
  String edificioID = "";
  String edificioDescripcion = "";
  List<String> periodeDeCuenta = ["Del día","Semana en Curso","Mes en Curso","Año en Curso"];
  List<int> periodeDeCuentaID = [1,2,3,4];
  String periodoCuentaID = "";
  String periodoCuentaDescripcion = "";

  Future<List<Map<String, dynamic>>>? _futureNoticias;

  TextEditingController criterionNoticiasController  = TextEditingController();

  List<TextEditingController>  comentarioNoticiasController =[];


  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  List<String>radioTipo =["1","2","-1"];
  List<String>radioImportatne =["1","0","-1"];

 late String tipoOpcion = radioTipo[2];
 late String importanteOpcion = radioImportatne[2];

 List<bool> comentariosVisibles = [];
  List<String> comentarioBoton =[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();

    setState(() {
      periodoCuentaID = periodeDeCuentaID[0].toString();
      debugPrint(periodoCuentaID);
      theme = newsController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;
    });
  }

  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("NombreUser")!;
      /*
      instrucionesPago = prefs.getString("intruciones de pago")!;
      debugPrint("Intruciones");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
       */
      _futureNoticias = getNewsC5(tipoOpcion.toString(),importanteOpcion.toString(),criterionNoticiasController.text,periodoCuentaID).importanNoticias5();

    });
  }

  Widget _buildDrawerHeader(BuildContext context, AdmMenuController controller, String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: controller.themeController.isDarkMode ? admDarkPrimary : admLightGrey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoLogin,
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width * 0.30,
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(6, 78, 116, 1),
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index, bool isAdmin, bool jundaDir) {
    if (isAdmin) {
      switch (index) {
        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return FontAwesomeIcons.boxesPacking;
        case 8: return Icons.person;
        case 9: return Icons.lock_reset;
        default: return Icons.logout;
      }
    } else if (jundaDir) {
      switch (index) {
        case 0: return FontAwesomeIcons.boxesPacking;
        case 1: return FontAwesomeIcons.person;
        default: return Icons.logout;
      }
    } else {
      switch (index) {
        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return FontAwesomeIcons.boxesPacking;
        case 8: return Icons.person;
        case 9: return Icons.lock_reset;
        default: return Icons.logout;
      }
    }
  }

  Future<void> decodeBase64ToPdf(String base64String, String fileName) async {
    try {
      // Decode base64 string
      final bytes = base64Decode(base64String);

      // Get the temporary directory of the app
      final dir = await getApplicationDocumentsDirectory();

      // Create the full path
      final file = File('${dir.path}/$fileName.pdf');

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      // Optional: Open the PDF
      await OpenFilex.open(file.path);

      debugPrint('✅ PDF saved at: ${file.path}');
    } catch (e) {
      debugPrint('❌ Error decoding PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    backgroundColor:newsController.themeController.isDarkMode?admDarkPrimary:admWhiteColor,
    appBar: AppBar(
      backgroundColor: newsController.themeController.isDarkMode
          ? admDarkPrimary
          : admWhiteColor,
      centerTitle: true,
      leading: Builder(
        builder: (context) => Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              color: newsController.themeController.isDarkMode
                  ? admWhiteColor
                  : admTextColor,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Title(color: Colors.black, child: Text("Estado de cuenta"))
              ),
            ),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          splashLogoName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: newsController.themeController.isDarkMode
                ? admWhiteColor
                : admTextColor,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              10.width,
              InkWell(
                onTap: () {
                  Get.toNamed(MyRoute.admNotification);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    //color: Colors.yellow,
                      border: Border.all(
                          color: newsController.themeController.isDarkMode
                              ? darkGreyColor
                              : greyColor,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            notification,
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                newsController.themeController.isDarkMode
                                    ? admWhiteColor
                                    : admTextColor,
                                BlendMode.srcIn),
                          ),
                          const Positioned(
                            right: 0,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: admLightRed,
                            ),
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        )
      ],
    ),
        drawer: Drawer(
          child: SafeArea(
            child: Obx(() {
              // 🧠 Get values reactively
              if (!menuController.isMenuReady.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final isAdmin = menuController.isAdmin.value;
              final jundaDir = menuController.jundaDir.value;
              final helpAndSupport = menuController.helpAndSupport;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDrawerHeader(context, menuController, userName),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemCount: helpAndSupport.length,
                        itemBuilder: (context, index) {
                          final menuTitle = helpAndSupport[index];
                          final isLast = index == helpAndSupport.length - 1;
                          final iconData = _getIconForIndex(index, isAdmin, jundaDir);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () async {
                                if (isLast) {
                                  Get.snackbar("Sesión", "Cerrando sesión...");
                                  _showLogOutBottomSheet(context);
                                  return;
                                }

                                // 👇 Handle "Paquetes pendientes"
                                if (menuTitle == "Paquetes pendientes") {
                                  Navigator.pop(context); // close drawer first
                                  Get.toNamed(MyRoute.home, arguments: {'fromDrawer': true});
                                  return;
                                }

                                // 👇 Normal navigation
                                Navigator.pop(context);
                                await Future.delayed(const Duration(milliseconds: 200));
                                Get.to(menuController.screens[index]);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    iconData,
                                    size: 22,
                                    color: isLast
                                        ? Colors.red
                                        : (menuController.themeController.isDarkMode
                                        ? admWhiteColor
                                        : admDarkPrimary),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      menuTitle,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isLast
                                            ? Colors.red
                                            : (menuController.themeController.isDarkMode
                                            ? admWhiteColor
                                            : admDarkPrimary),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: isLast
                                        ? Colors.red
                                        : (menuController.themeController.isDarkMode
                                        ? admWhiteColor
                                        : admDarkPrimary),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

    body: GetBuilder<AdmNoticiasController>(
        init: newsController,
        tag: 'adm_estadoCuenta',
        // theme: theme,
        builder: (newsController) => SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                                elevation: 3,
                                color:Color.fromRGBO(146,162,87,1),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Selección de Periodo",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(6,78,116,1),
                                              fontSize: MediaQuery.of(context).size.width*0.030,
                                            )),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.45,
                                              child: DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                // allow multi-line heights in dropdown
                                                itemHeight: null,
                                                value: periodeDeCuentaID[0].toString(),
                                                hint: const Text("Seleccione periodo"),
                                                decoration: InputDecoration(
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(
                                                      color: Color.fromRGBO(6, 78, 116, 1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: const BorderSide(
                                                      color: Color.fromRGBO(6, 78, 116, 1),
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                ),

                                                // 🔹 Custom selected item builder to support multi-line when collapsed
                                                selectedItemBuilder: (context) {
                                                  return List.generate(periodeDeCuentaID.length, (index) {
                                                    return ConstrainedBox(
                                                      constraints: const BoxConstraints(minHeight: 48),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          periodeDeCuenta[index],
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },

                                                // 🔹 Dropdown items
                                                items: List.generate(periodeDeCuentaID.length, (index) {
                                                  return DropdownMenuItem<String>(
                                                    value: periodeDeCuentaID[index].toString(),
                                                    child: ConstrainedBox(
                                                      constraints: const BoxConstraints(minHeight: 48),
                                                      child: Text(
                                                        periodeDeCuenta[index],
                                                        maxLines: 10, // allow long text
                                                        softWrap: true,
                                                        overflow: TextOverflow.visible,
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),

                                                onChanged: (value) {
                                                  setState(() {
                                                    int index = periodeDeCuentaID.indexOf(int.parse(value!));
                                                    debugPrint(periodeDeCuentaID[index].toString());
                                                    periodoCuentaID = value;
                                                    debugPrint(periodoCuentaID);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Criterio",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(6,78,116,1),
                                              fontSize: MediaQuery.of(context).size.width*0.030,
                                            )),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*0.45,
                                              child: TextFormField(
                                                controller: criterionNoticiasController ,

                                                onChanged: (value) {
                                                  criterionNoticiasController .text = value;
                                                },
                                                onFieldSubmitted: (value) {
                                                  criterionNoticiasController .text = value;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    17.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.45,
                                          child: Column(
                                            children: [
                                              Text("Tipo",style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Color.fromRGBO(6,78,116,1),
                                                fontSize: MediaQuery.of(context).size.width*0.025,
                                              )),
                                              ListTile(
                                                title: Text("Noticias"),
                                                leading: Radio<String>(
                                                  value: radioTipo[0],
                                                  groupValue: tipoOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      tipoOpcion = value!;
                                                      debugPrint(tipoOpcion.toString());
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text("Avisos"),
                                                leading: Radio<String>(
                                                  value: radioTipo[1],
                                                  groupValue: tipoOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      tipoOpcion = value!;
                                                      debugPrint(tipoOpcion.toString());
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text("Todos"),
                                                leading: Radio<String>(
                                                  value: radioTipo[2],
                                                  groupValue: tipoOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      tipoOpcion = value!;
                                                      debugPrint(tipoOpcion.toString());
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.45,
                                          child: Column(
                                            children: [
                                              Text("Importante",style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Color.fromRGBO(6,78,116,1),
                                                fontSize: MediaQuery.of(context).size.width*0.025,
                                              )),
                                              ListTile(
                                                title: Text("Sí"),
                                                leading: Radio<String>(
                                                  value: radioImportatne[0],
                                                  groupValue: importanteOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      importanteOpcion = value!;
                                                      debugPrint(importanteOpcion);
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text("No"),
                                                leading: Radio<String>(
                                                  value: radioImportatne[1],
                                                  groupValue: importanteOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      importanteOpcion = value!;
                                                      debugPrint(importanteOpcion);
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text("Todos"),
                                                leading: Radio<String>(
                                                  value: radioImportatne[2],
                                                  groupValue: importanteOpcion,
                                                  onChanged: (value){
                                                    setState(() {
                                                      importanteOpcion = value!;
                                                      debugPrint(importanteOpcion);
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    17.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                              // set the background color
                                            ),
                                            onPressed: () async{ },
                                            child: Text(
                                              "Limpiar",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context).size.width*0.035,
                                              ),
                                            ),),
                                        ),
                                        SizedBox(
                                          height: 35,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                              // set the background color
                                            ),
                                            onPressed: () async{
                                              setState(() {

                                                debugPrint(periodoCuentaID);
                                                debugPrint(criterionNoticiasController.text);
                                                debugPrint(tipoOpcion.toString());
                                                debugPrint(importanteOpcion.toString());
                                                if(criterionNoticiasController.text.isEmpty)
                                                  {
                                                    setState(() {
                                                      criterionNoticiasController.text = "";
                                                      _futureNoticias = getNewsC5(tipoOpcion.toString(),importanteOpcion.toString(),criterionNoticiasController.text,periodoCuentaID).importanNoticias5();
                                                    });
                                                  }
                                              });
                                            },
                                            child: Text(
                                              "Filtrar",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context).size.width*0.035,
                                              ),
                                            ),),
                                        )
                                      ],
                                    ),
                                    17.height,
                                  ],
                                )
                            ),
                            17.height,
                            FutureBuilder(
                              future:_futureNoticias,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return  Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError)
                                {
                                  debugPrint(snapshot.hasError.toString());
                                  return  Center(
                                      child: Title(color: Color.fromRGBO(6,78,116,1),
                                        child: Text("No hay noticias del día de hoy A",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      ));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  debugPrint(snapshot.hasData.toString());
                                  return  Center(child: Text("No hay noticias disponibles para ese periodo"),);
                                }
                                final events = snapshot.data!;

                                debugPrint("Evento");
                                debugPrint(events.toString());
                                return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height > 400 ? MediaQuery.of(context).size.height*0.45:MediaQuery.of(context).size.height*0.10,
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final cardWidth = constraints.maxWidth * 0.9;
                                          final cardHeight = constraints.maxHeight * 0.65;
                                          final titleFontSize = constraints.maxWidth * 0.035;
                                          final subtitleFontSize = constraints.maxWidth * 0.03;
                                          double noticiaSize = constraints.maxHeight;

                                          return ListView.builder(
                                            physics: const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: events.length,
                                            itemBuilder: (context, index) {
                                              final event = events[index];
                                              final fotos = event["pl_fotografias"] as List?;
                                              List<int> cantidadComentarios = [];
                                              final carouselKey = GlobalKey<CarouselSliderState>();

                                               /*final images = event["plFotografias"]
                                                  ?.where((f) => f["pv_fotografiab64"] != null && f["pv_fotografiab64"]!.isNotEmpty)
                                                  .map((f) => f["pv_fotografiab64"]!)
                                                  .toList() ?? [];
                                               */
                                              _controllers.putIfAbsent(index, () => CarouselSliderController());
                                              _currentIndex[index] = _currentIndex[index] ?? 0;
                                              for (int i = 0; i < events.length; i++)
                                                {
                                                  cantidadComentarios.add(0);
                                                  comentarioNoticiasController.add(TextEditingController(text:""));
                                                  comentariosVisibles.add(false);

                                                  if(event["pl_comentarios"] != null )
                                                  {
                                                    cantidadComentarios[i] = event["pl_comentarios"].length;
                                                    debugPrint("$i ${event ["pl_comentarios"].length}");
                                                  }
                                                  else
                                                  {
                                                    cantidadComentarios[i] = 0;
                                                  }
                                                }
                                              for (int i = 0; i < events.length; i++)
                                                {
                                                  comentarioBoton.add("Ver comentarios (${cantidadComentarios[i]})");
                                                }

                                              final images = (event["pl_fotografias"] as List<dynamic>?)
                                                  ?.where((f) => f["pv_fotografiab64"] != null && f["pv_fotografiab64"].toString().isNotEmpty)
                                                  .map((f) => f["pv_fotografiab64"].toString())
                                                  .toList()
                                                  ?? [];
                                              _controllers.putIfAbsent(index, () => CarouselSliderController());
                                              _currentIndex[index] = _currentIndex[index] ?? 0;

                                              return Card(
                                                    elevation: 3,
                                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(event["pv_descripcion"].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize: constraints.maxWidth * 0.055,
                                                        )),
                                                        Row(
                                                          children: [
                                                            Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event["pf_fecha"].toString())),style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),//color: Colors.grey[600],
                                                              fontSize: constraints.maxWidth * 0.035,)),
                                                          ],
                                                        ),
                                                        if (fotos == null || fotos.isEmpty)
                                                          const Center(child: Text("Sin fotos"))
                                                        else
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              CarouselSlider(
                                                                key: carouselKey,
                                                                options: CarouselOptions(
                                                                  aspectRatio: 16 / 9,
                                                                  viewportFraction: 1.0,
                                                                  enableInfiniteScroll: false,
                                                                  enlargeCenterPage: true,
                                                                ),
                                                                items: fotos.map((foto) {
                                                                  final base64Img = foto["pv_fotografiab64"]?.toString();
                                                                  if (foto["pn_adjunto"] == 1) {
                                                                    return Column(
                                                                      children: [
                                                                        const SizedBox(height: 10),
                                                                        if (foto["pv_nombre"] != null)
                                                                          Center(
                                                                            child: Text(
                                                                              foto["pv_nombre"],
                                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        Center(
                                                                          child: SizedBox(
                                                                            width: MediaQuery.of(context).size.width * 0.60,
                                                                            child: ElevatedButton.icon(
                                                                              icon: const Icon(Icons.download, color: Colors.white),
                                                                              label: Text(
                                                                                "Descargar",
                                                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                              ),
                                                                              onPressed: () async {
                                                                                await decodeBase64ToPdf(base64Img!, foto["pv_nombre"]);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }

                                                                  final bytes = base64Decode(base64Img!);
                                                                  return GestureDetector(
                                                                    onTap: ()=>showImageDialog(context,base64Img!),
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      child: Image.memory(
                                                                        bytes,
                                                                        fit: BoxFit.cover,
                                                                        width: double.infinity,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),

                                                              // ⬅️ Left Arrow
                                                              Positioned(
                                                                left: 10,
                                                                child: IconButton(
                                                                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 30),
                                                                  onPressed: () {
                                                                    final controller = carouselKey.currentState?.pageController;
                                                                    if (controller != null && controller.hasClients) {
                                                                      controller.previousPage(
                                                                        duration: const Duration(milliseconds: 300),
                                                                        curve: Curves.easeInOut,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),

                                                              // ➡️ Right Arrow
                                                              Positioned(
                                                                right: 10,
                                                                child: IconButton(
                                                                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.black87, size: 30),
                                                                  onPressed: () {
                                                                    final controller = carouselKey.currentState?.pageController;
                                                                    if (controller != null && controller.hasClients) {
                                                                      controller.nextPage(
                                                                        duration: const Duration(milliseconds: 300),
                                                                        curve: Curves.easeInOut,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(12),
                                                          child:  Center(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Title(color:Color.fromRGBO(6,78,116,1), child:Text("Comentario",style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(6,78,116,1),
                                                                      fontSize: MediaQuery.of(context).size.width*0.040,
                                                                            )
                                                                          )
                                                                        ),
                                                                      ],
                                                                     ),
                                                                    Center(
                                                                      child: SizedBox(
                                                                        width: constraints.maxWidth,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.multiline,
                                                                          maxLines: null,
                                                                           controller: comentarioNoticiasController[index],
                                                                          onChanged: (value)
                                                                          {
                                                                            setState(() {
                                                                              comentarioNoticiasController[index].text = value;
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              width: constraints.maxWidth *0.45,
                                                              height: constraints.maxHeight *0.10,
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1), // set the background color
                                                                  ),
                                                                  onPressed: () async{
                                                                   if(comentarioNoticiasController[index].text != "")
                                                                   {
                                                                      makeApiCall2(
                                                                      event["pn_noticia"].toString(), comentarioNoticiasController[index].text);
                                                                      setState(() {comentarioNoticiasController[index].text = "";}
                                                                      );
                                                                      msgxToast("El comentario fue enviado para su aprobación");
                                                              }
                                                            },
                                                                  child:  Text(
                                                                    "Ingresar comentario",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white,
                                                                      fontSize:  MediaQuery.of(context).size.height > 400 ? constraints.maxWidth * 0.04: constraints.maxWidth * 0.015,
                                                                    ),
                                                                    maxLines:3,
                                                                  ),
                                                              )
                                                            ),SizedBox(
                                                                width: constraints.maxWidth *0.45,
                                                                height: constraints.maxHeight *0.10,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                                    // set the background color
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      if (comentariosVisibles[index] == false)
                                                                      {
                                                                        comentariosVisibles[index] = true;
                                                                        comentarioBoton[index] = "Ocultar comentarios";
                                                                      }
                                                                      else
                                                                        {
                                                                          comentariosVisibles[index] = false;
                                                                          comentarioBoton[index] = "Ver comentarios (${cantidadComentarios[index]})";
                                                                        }
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    comentarioBoton[index],
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white,
                                                                      fontSize:  MediaQuery.of(context).size.height > 400 ? constraints.maxWidth * 0.04: constraints.maxWidth * 0.015,
                                                                    ),
                                                                    maxLines: 3,
                                                                  ),
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8),
                                                          child: comentariosVisibles[index] ? Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Title(color:Color.fromRGBO(6,78,116,1), child:Text("Comentarios:",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize: MediaQuery.of(context).size.width*0.060,
                                                                 )
                                                                )
                                                              ),
                                                              SizedBox(
                                                                width: constraints.maxWidth * 0.8,
                                                                child: event["pl_comentarios"] == null || (event["pl_comentarios"] as List).isEmpty
                                                                    ? const Center(child: Text("Sin comentarios"))
                                                                    : SingleChildScrollView(
                                                                       scrollDirection: Axis .vertical,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: (event["pl_comentarios"] as List<dynamic>)
                                                                        .map((comentario) => Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(comentario["pv_autor"].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color:Color.fromRGBO(6, 78, 116, 1),
                                                                              fontSize: constraints.maxWidth * 0.055,
                                                                            ),maxLines: 4,),
                                                                          /*
                                                                            Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(comentario["pf_fecha"].toString())),style: theme.textTheme.headlineSmall?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color:Color.fromRGBO(6, 78, 116, 1),
                                                                              fontSize: constraints.maxWidth * 0.045,
                                                                            ),maxLines: 4,
                                                                            ),
                                                                           */
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(bottom: 8.0),
                                                                          child: Text(
                                                                            comentario["pv_descripcion"].toString(),
                                                                            style: theme.textTheme.headlineSmall?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: const Color.fromRGBO(167, 167, 132, 1),
                                                                              fontSize: constraints.maxWidth * 0.035,
                                                                            ),
                                                                            maxLines: 5,
                                                                            overflow: TextOverflow.ellipsis,),
                                                                        ),
                                                                      ],
                                                                    )).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ):Center(),
                                                        ),

                                                      ],
                                                    )

                                                );

                                            },
                                          );
                                        }
                                    )
                                );
                              },
                            ),
                            50.height,
                          ]
                      )
                  )
                ]
            )
        )
    )
    );
  }
}

Future<void> makeApiCall2(String noticiasID,String comentario)
async {
 debugPrint("Comentario tratando de ingresar");
  setNewsComentC7(noticiasID,comentario);
  await setNewsComentC7(noticiasID,comentario).ComentarioNoticias7();

}

Future<void> makeApiCall(String noticiaTipo,String importante,String criterio, String periodo)
async {
  // Example API call
  getNewsC5(noticiaTipo,importante,criterio,periodo);
  await getNewsC5(noticiaTipo,importante,criterio,periodo).importanNoticias5();
}

void _showLogOutBottomSheet(BuildContext context,) {
  final ThemeData theme = Theme.of(context);
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Container(
            decoration: BoxDecoration(
                color: Get.isDarkMode ? admDarkPrimary : whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                )),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.height,
                    Divider(
                      indent: 180,
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      endIndent: 180,
                      thickness: 4,
                    ),
                    15.height,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        logoutText,
                        style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700, color: admLightRed),
                      ),
                    ),
                    15.height,
                    Divider(
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    18.height,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        logoutDes,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    18.height,
                    Divider(
                      color: Get.isDarkMode ? admDarkLightColor : greyColor,
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    15.height,
                    Padding(
                      padding:  EdgeInsets.only(left: 8, right: 8,bottom: GetPlatform.isIOS
                          ? MediaQuery.of(context).padding.bottom
                          : 8,top:8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
                                //Get.back();
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? admDarkLightColor
                                      : lightPrimaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    cancel,
                                    style:
                                    theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Get.isDarkMode
                                          ? admWhiteColor
                                          : admColorPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Adjust as needed
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Get.offNamedUntil('/adm_login',
                                //     ModalRoute.withName(MyRoute.loginScreen));
                                Get.snackbar("Sesión", "Cerrando sesión...");
                                Get.offNamedUntil(MyRoute.loginScreen, (route) => route.isFirst);
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: admColorPrimary,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    yesLogout,
                                    style:
                                    theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: admWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
void showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
  );
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
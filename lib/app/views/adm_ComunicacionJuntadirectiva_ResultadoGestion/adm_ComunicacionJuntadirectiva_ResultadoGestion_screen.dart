import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../../api_Clases/class_Cuentas7.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_Comunicacion_JuntaDirectiva_ResultadoGestion_controller.dart';
import '../../controller/adm_Comunicacion_Junta_Directiva_Controller.dart';
import '../../controller/adm_comunicacion_Admin_ticket_controller.dart';
import '../../controller/adm_estado_de_cuenta_controller.dart';
import '../../controller/adm_home_controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';


class AdmComunicacionJuntaDirectivaResultadoGestionScreen extends StatefulWidget {
  const AdmComunicacionJuntaDirectivaResultadoGestionScreen({super.key});

  @override
  State<AdmComunicacionJuntaDirectivaResultadoGestionScreen> createState() => _AdmComunicacionJuntaDirectivaScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmComunicacionJuntaDirectivaScreenState extends State<AdmComunicacionJuntaDirectivaResultadoGestionScreen> {

  late ThemeData theme;

  //AdmHomeController AdmComunicacionJuntaDirectivaResultadoGestionController = Get.put(AdmHomeController());
  AdmComunicacionJuntaDirectivaResultadoGestionController admComunicacionJuntaDirectivaResultadoGestionController = Get.put(AdmComunicacionJuntaDirectivaResultadoGestionController());
  AdmHomeController homeController = Get.put(AdmHomeController());

  AdmMenuController menuController = Get.put(AdmMenuController());

  String userName = "";
  String edificioID = "";
  String edificioDescripcion = "";

  String periodoCuentaID = "";
  String periodoCuentaDescripcion = "";

  String propiedadCuentaID = "";
  String propiedadCuentaDescripcion = "";

  List<String> periodeDeCuenta = ["Todos","Mes En Curso","Mes Anterior","Año En Curso","Año Anterior"];
  List<int> periodeDeCuentaID = [-1,1,2,3,4];


  List<String> estadoTicket = ["Todos","Ingresada","En Proceso","Finalizada","Aperturada","Cerrada"];
  List<int> estadoTicketID = [-1,1,2,3,4,0];

  //Future<List<CuentasH7>> ? _futureCuentasH7;
  TextEditingController busquedaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController comentarioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController criterioController  = TextEditingController();

  String periodoElegido = "3";
  String propiedadElegido = "-1";
  String TipoElegido = "-1";
  String EstadoTicketElegido = "-1";

  String propiedadElegidoB = "-1";
  String PropiedadElegidaDEscripcion = "";
  String TipoElegidoB = "-1";

  List<String>radioTipo =["1","2","-1"];
  List<String>radioImportatne =["1","0","-1"];

  late String tipoOpcion = radioTipo[2];
  late String importanteOpcion = radioImportatne[2];

  String? selectedValueA;
  String? selectedValueB;
  String? selectedValueC;

  Future<List<TickestG5>> ?_futureTickets;
  File ? iamgenSelect;

  List<File> imagenesSeleccionadas = [];
  List<String> base64Images = [];

  List<File> imagenesSeleccionadas_B = [];
  List<String> base64Images_B = [];


  String base64Image = "";
  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  final Map<int, CarouselSliderController> _controllers2 = {};
  final Map<int, int> _currentIndex2 = {};

  String? getion;

  String? gestionDescipcion;
  late Future _FuterComunicacionDirectivaresultadoGestion;
  String admincheck = "";
  String juntaDirect = "";
  String inquilino = "";
  @override
  void initState() {
    super.initState();
    getUserInfo();
    _FuterComunicacionDirectivaresultadoGestion = ComunicacionJuntaDirectivaFinancieraClass("-1",busquedaController.text).ColumicacionesListadosK5();
    setState(() {
      theme = admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;

      if(juntaDirectivaID_ResultadoGestion.isEmpty || juntaDirectivaNombreResultadoGestion.isEmpty)
        {
          propiedadCuentaID = "-1";
          periodoCuentaID = "Seleccione";
        }
      else
        {
          propiedadCuentaID = juntaDirectivaID_ResultadoGestion[0].toString();
          periodoCuentaID = juntaDirectivaNombreResultadoGestion[0].toString();
        }
    }
    );
  }

  getUserInfo() async
  {
    //_futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
    _FuterComunicacionDirectivaresultadoGestion = ComunicacionJuntaDirectivaFinancieraClass(periodoCuentaID,busquedaController.text).ColumicacionesListadosK5();

    final prefs = await SharedPreferences.getInstance();
    setState(() {

      userName = prefs.getString("NombreUser")!;
      admincheck = prefs.getString("Admin")!;
      juntaDirect = prefs.getString("JuntaDirectiva")!;
      inquilino = prefs.getString("Inquilino") ?? "0";
      /*
      instrucionesPago = prefs.getString("intruciones de pago")!;
      debugPrint("Intruciones");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
       */
    });

  }
  /*Future<void> makeApiCall(String comunicacionTipo,String estado,String criterio)
  async {
    // Example API call
    debugPrint("crear pago");
    ComunicacionJuntaDirectivaClass(comunicacionTipo,estado,criterio);
    await ComunicacionJuntaDirectivaClass(comunicacionTipo,estado,criterio)
        .ColumicacionesListadosJ5();

    //Navigator.of(context).pop();
    //msgxToast("Pago realizado correctamente");
  }*/
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

  IconData _getIconForIndex(int index, String isAdmin, String jundaDir,String inquilino)
  {
    if (jundaDir == "1") {
      switch (index) {
        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return FontAwesomeIcons.gear;
        case 8: return Icons.chat;
        case 9: return Icons.person;
        case 10: return FontAwesomeIcons.boxesPacking;
        case 11: return Icons.lock_reset;
        default: return Icons.logout;
      }
    } else if (jundaDir =="2") {
      switch (index) {
        case 0: return FontAwesomeIcons.person;
        case 1:  return FontAwesomeIcons.boxesPacking;
        default: return Icons.logout;
      }
    } else if (inquilino == "1") {
      switch (index) {
        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return Icons.person;
        case 8: return FontAwesomeIcons.boxesPacking;
      //case 8: return Icons.lock_reset;
        default: return Icons.logout;

      /*        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return  Icons.person;
        case 8: return FontAwesomeIcons.boxesPacking;
        case 9: return Icons.lock_reset;
        default: return Icons.logout;*/
      }
    }
    else {
      switch (index) {
        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return Icons.person;
        case 8: return FontAwesomeIcons.boxesPacking;
      //case 8: return Icons.lock_reset;
        default: return Icons.logout;

      /*        case 0: return Icons.house;
        case 1: return FontAwesomeIcons.clipboardList;
        case 2: return FontAwesomeIcons.newspaper;
        case 3: return FontAwesomeIcons.doorOpen;
        case 4: return FontAwesomeIcons.boxesStacked;
        case 5: return FontAwesomeIcons.calendarCheck;
        case 6: return FontAwesomeIcons.phoneFlip;
        case 7: return  Icons.person;
        case 8: return FontAwesomeIcons.boxesPacking;
        case 9: return Icons.lock_reset;
        default: return Icons.logout;*/
      }
    }
  }

  Widget _infoColumn(ThemeData theme, String title, String value, double width) {
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(167, 167, 132, 1),
            fontSize: width * 0.04,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: width * 0.04,
          ),
        ),
      ],
    );
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

  String _formatDuration(dynamic raw) {
    if (raw == null || raw == "") return 'Sin atender';
    final seconds = raw is String ? int.tryParse(raw) ?? 0 : raw;
    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    return "${days}d ${hours}h ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor:admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
        appBar: AppBar(
          backgroundColor: admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
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
                color: admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
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
                              color: admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
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
                                    admComunicacionJuntaDirectivaResultadoGestionController.themeController.isDarkMode
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
                          final iconData = _getIconForIndex(index, admincheck, juntaDirect,inquilino);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () async {
                                if (isLast) {
                                  _showLogOutBottomSheet(context);
                                  return;
                                }

                                // 👇 Handle "Paquetes pendientes"
                                /*if (menuTitle == "Paquetes pendientes") {
                                  Navigator.pop(context); // close drawer first
                                  Get.toNamed(MyRoute.home, arguments: {'fromDrawer': true});
                                  return;
                                }*/

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

        body: GetBuilder<AdmComunicacionJuntaDirectivaResultadoGestionController>(
            init: admComunicacionJuntaDirectivaResultadoGestionController,
            tag: 'adm_estadoCuenta',
            // theme: theme,
            builder: (admComunicacionJuntaDirectivaResultadoGestionController) => SingleChildScrollView(
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
                                                Text("Tipo",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Color.fromRGBO(6,78,116,1),
                                                  fontSize: MediaQuery.of(context).size.width*0.030,
                                                )),
                                                /*List<String> juntaDirectivaNombreResultadoGestion = [];
List<int> juntaDirectivaID_ResultadoGestion = [];*/
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.45,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    // allow multi-line heights in dropdown
                                                    itemHeight: null,

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
                                                      return List.generate(juntaDirectivaID_ResultadoGestion.length, (index) {
                                                        return ConstrainedBox(
                                                          constraints: const BoxConstraints(minHeight: 48),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              juntaDirectivaNombreResultadoGestion[index],
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

                                                    items: List.generate(juntaDirectivaID_ResultadoGestion.length, (index) {
                                                      return DropdownMenuItem<String>(
                                                        value: juntaDirectivaID_ResultadoGestion[index].toString(),
                                                        child: ConstrainedBox(
                                                          constraints: const BoxConstraints(minHeight: 48),
                                                          child: Text(
                                                            juntaDirectivaNombreResultadoGestion[index],
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
                                                        int index = juntaDirectivaID_ResultadoGestion.indexOf(int.parse(value!));
                                                        debugPrint(juntaDirectivaID_ResultadoGestion[index].toString());
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
                                                    controller: criterioController ,

                                                    onChanged: (value) {
                                                      criterioController .text = value;
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      criterioController .text = value;
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

                                                    debugPrint("periodoCuentaID");
                                                    debugPrint(periodoCuentaID);
                                                    debugPrint(criterioController.text);
                                                    debugPrint(tipoOpcion.toString());
                                                    //debugPrint(importanteOpcion.toString());
                                                    if(criterioController.text.isEmpty)
                                                    {
                                                      setState(() {
                                                        criterioController.text = "";
                                                        //_FuterComunicacionDirectivaresultadoGestion = ComunicacionJuntaDirectivaClass(tipoOpcion,propiedadCuentaID,busquedaController.text).ColumicacionesListadosJ5();
                                                        _FuterComunicacionDirectivaresultadoGestion = ComunicacionJuntaDirectivaFinancieraClass(periodoCuentaID,busquedaController.text).ColumicacionesListadosK5();
                                                      });
                                                    }
                                                    else
                                                    {
                                                      setState(() {
                                                        _FuterComunicacionDirectivaresultadoGestion = ComunicacionJuntaDirectivaFinancieraClass(periodoCuentaID,busquedaController.text).ColumicacionesListadosK5();
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
                                  future: _FuterComunicacionDirectivaresultadoGestion,
                                  builder: (context, snapshot) {
                                    // ⏳ Loading
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    // ❌ Error / vacío
                                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text(
                                          "No hay noticias del mes",
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).size.width * 0.035,
                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                          ),
                                        ),
                                      );
                                    }

                                    final events = snapshot.data!;

                                    return LayoutBuilder(
                                      builder: (context, constraints) {
                                        final screenWidth = constraints.maxWidth;
                                        final titleFontSize = screenWidth * 0.045;
                                        final subtitleFontSize = screenWidth * 0.03;

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: events.length,
                                          itemBuilder: (context, index) {
                                            final event = events[index];
                                            final fotos = event["pl_fotografias"] as List?;
                                            final documentos = event["pl_adjuntos"] as List?;
                                            final carouselKey = GlobalKey<CarouselSliderState>();

                                            return Card(
                                              elevation: 3,
                                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 12),

                                                    // 📰 TITLES
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Title(
                                                          color: const Color.fromRGBO(167, 167, 132, 1),
                                                          child: Text(
                                                            event["pv_descripcion"],
                                                            style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color.fromRGBO(167, 167, 132, 1),
                                                              fontSize: titleFontSize,
                                                            ),
                                                          ),
                                                        ),
                                                        Title(
                                                          color: const Color.fromRGBO(167, 167, 132, 1),
                                                          child: Text(
                                                            event["pv_informacion_financiera_tipo_descripcion"],
                                                            style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color.fromRGBO(167, 167, 132, 1),
                                                              fontSize: titleFontSize,
                                                            ),
                                                          ),
                                                        ),
                                                        Title(
                                                          color: const Color.fromRGBO(167, 167, 132, 1),
                                                          child: Text(
                                                            DateFormat('dd/MM/yyyy')
                                                                .format(DateTime.parse(event["pf_fecha"]!)),
                                                            style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color.fromRGBO(167, 167, 132, 1),
                                                              fontSize: titleFontSize,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 12),

                                                    // 📄 DOCUMENTOS - CAROUSEL
                                                    if (documentos == null || documentos.isEmpty)
                                                      const Center(child: Text("Sin documentos"))
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
                                                            items: documentos.map((documento) {
                                                              final base64Img =
                                                              documento["pv_adjuntob64"]?.toString();

                                                              // 📥 DESCARGA PDF
                                                              if (documento["pn_adjunto"] == 1) {
                                                                return Column(
                                                                  children: [
                                                                    const SizedBox(height: 10),
                                                                    if (documento["pv_descripcion"] != null)
                                                                      const SizedBox(height: 12),
                                                                    Center(
                                                                      child: SizedBox(
                                                                        width:
                                                                        MediaQuery.of(context).size.width *
                                                                            0.60,
                                                                        child: ElevatedButton.icon(
                                                                          icon: const Icon(Icons.download,
                                                                              color: Colors.white),
                                                                          label: Text(
                                                                            "Descargar",
                                                                            style: theme.textTheme.bodyMedium
                                                                                ?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize:
                                                                              MediaQuery.of(context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.035,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                            const Color.fromRGBO(
                                                                                6, 78, 116, 1),
                                                                            padding:
                                                                            const EdgeInsets.symmetric(
                                                                                vertical: 20),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius.circular(20),
                                                                            ),
                                                                          ),
                                                                          onPressed: () async {
                                                                            log(base64Img);
                                                                            await decodeBase64ToPdf(
                                                                              base64Img!,
                                                                                event["pv_descripcion"]
                                                                                  .toString(),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }

                                                              // 🖼️ IMAGEN
                                                              final bytes = base64Decode(base64Img!);
                                                              return GestureDetector(
                                                                onTap: () => showImageDialog4(context, base64Img),
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

                                                          // ⬅️ Flecha izquierda
                                                          Positioned(
                                                            left: 10,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.arrow_back_ios,
                                                                color: Colors.black87,
                                                                size: 30,
                                                              ),
                                                              onPressed: () {
                                                                final controller =
                                                                    carouselKey.currentState?.pageController;
                                                                if (controller != null &&
                                                                    controller.hasClients) {
                                                                  controller.previousPage(
                                                                    duration:
                                                                    const Duration(milliseconds: 300),
                                                                    curve: Curves.easeInOut,
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),

                                                          // ➡️ Flecha derecha
                                                          Positioned(
                                                            right: 10,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.arrow_forward_ios,
                                                                color: Colors.black87,
                                                                size: 30,
                                                              ),
                                                              onPressed: () {
                                                                final controller =
                                                                    carouselKey.currentState?.pageController;
                                                                if (controller != null &&
                                                                    controller.hasClients) {
                                                                  controller.nextPage(
                                                                    duration:
                                                                    const Duration(milliseconds: 300),
                                                                    curve: Curves.easeInOut,
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                    const SizedBox(height: 8),

                                                    // 💬 COMENTARIOS
                                                    if (event["pl_comentarios"] != null &&
                                                        event["pl_comentarios"].isNotEmpty)
                                                      Text(
                                                        event["pl_comentarios"][0]["pv_descripcion"]
                                                            .toString(),
                                                        maxLines: 5,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          color: const Color.fromRGBO(167, 167, 132, 1),
                                                          fontSize: subtitleFontSize,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                50.height,
                              ]
                          )
                      )
                    ]
                )
            ))
    );
  }

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
void showImageDialog4(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
  );
}
void showImageDialog2(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
  );
}
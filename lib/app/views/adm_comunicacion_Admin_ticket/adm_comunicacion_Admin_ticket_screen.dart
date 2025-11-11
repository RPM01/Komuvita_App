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
import '../../../api_Clases/class_Cuentas7.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_comunicacion_Admin_ticket_controller.dart';
import '../../controller/adm_estado_de_cuenta_controller.dart';
import '../../controller/adm_home_controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';


class AdmComunicacionAdministradorScreen extends StatefulWidget {
  const AdmComunicacionAdministradorScreen({super.key});

  @override
  State<AdmComunicacionAdministradorScreen> createState() => _AdmComunicacionAdminScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmComunicacionAdminScreenState extends State<AdmComunicacionAdministradorScreen> {

  late ThemeData theme;

  //AdmHomeController admComunicacionAdminController = Get.put(AdmHomeController());
  AdmComunicacionAdministraController admComunicacionAdminController = Get.put(AdmComunicacionAdministraController());
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

  String periodoElegido = "3";
  String propiedadElegido = "-1";
  String TipoElegido = "-1";
  String EstadoTicketElegido = "-1";

  String propiedadElegidoB = "-1";
  String PropiedadElegidaDEscripcion = "";
  String TipoElegidoB = "-1";

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();

    setState(() {
      theme = admComunicacionAdminController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;

      propiedadCuentaID = clientesIdsSet[0];
      periodoCuentaID = periodeDeCuentaID[0].toString();
    }
    );
  }

  getUserInfo() async
  {
    _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();

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
        backgroundColor:admComunicacionAdminController.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
        appBar: AppBar(
          backgroundColor: admComunicacionAdminController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: admComunicacionAdminController.themeController.isDarkMode
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
                color: admComunicacionAdminController.themeController.isDarkMode
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
                              color: admComunicacionAdminController.themeController.isDarkMode
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
                                    admComunicacionAdminController.themeController.isDarkMode
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

        body: GetBuilder<AdmComunicacionAdministraController>(
            init: admComunicacionAdminController,
            tag: 'adm_estadoCuenta',
            // theme: theme,
            builder: (admComunicacionAdminController) => SingleChildScrollView(
                child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image.asset(doggy),
                                17.height,
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
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: Text("Período",style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                                    color: Color.fromRGBO(6,78,116,1),
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: periodeDeCuentaID[3].toString(),
                                                    //hint: const Text("Seleccione una empresa"),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 1),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 2),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(6,78,116,1)),
                                                    items: List.generate(periodeDeCuentaID.length, (index) {
                                                      return DropdownMenuItem<String>(
                                                        value: periodeDeCuentaID[index].toString(),
                                                        child: Text(
                                                          periodeDeCuenta[index],
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        int index = periodeDeCuentaID.indexOf(int.parse(value!));
                                                        periodoCuentaID = value;
                                                        periodoElegido = value;
                                                        debugPrint(periodoElegido);
                                                        debugPrint(periodoCuentaID);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: Text("Propiedades",style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                                    color: Color.fromRGBO(6,78,116,1),
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: clientesIdsSet[0].toString(),
                                                    hint: const Text("Seleccione una empresa"),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 1),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 2),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(6,78,116,1)),
                                                    items: List.generate(clientesIdsSet.length, (index) {
                                                      return DropdownMenuItem<String>(
                                                        value: clientesIdsSet[index],
                                                        child: Text("${propiedadesInternaNombresSet[index]} ${propiedadesDireccionNombresSet[index]}",
                                                          style: const TextStyle(
                                                            fontSize:  20,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        int index = propiedadesInternasIdsSet.indexOf(value!);
                                                        propiedadElegido = value;
                                                        propiedadCuentaID = value;
                                                        debugPrint(propiedadElegido);
                                                        debugPrint(propiedadCuentaID);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        17.height,
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: Text("Tipo",style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                                    color: Color.fromRGBO(6,78,116,1),
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: gestionDescripcion[0].toString(),
                                                    //hint: const Text("Seleccione una empresa"),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 1),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 2),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(6,78,116,1)),
                                                    items: List.generate(gestionDescripcion.length, (index) {
                                                      return DropdownMenuItem<String>(
                                                        value: gestionDescripcion[index].toString(),
                                                      child: Text(
                                                        gestionDescripcion[index],
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          overflow: TextOverflow.ellipsis,                                                      ),
                                                        maxLines: 2,
                                                      ),
                                                      );
                                                    }),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        int index = gestionIDs.indexOf(int.parse(value!));
                                                        TipoElegido = value;
                                                        debugPrint(TipoElegido);
                                                        debugPrint(index.toString());
                                                        debugPrint(gestionDescripcion[index].toString());
                                                        debugPrint(gestionIDs[index].toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: Text("Estado",style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                                    color: Color.fromRGBO(6,78,116,1),
                                                  ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: estadoTicketID[0].toString(),
                                                    hint: const Text(" "),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 1),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                        borderSide: const BorderSide(color: Color.fromRGBO(6,78,116,1), width: 2),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(6,78,116,1)),
                                                    items: List.generate(estadoTicket.length, (index) {
                                                      return DropdownMenuItem<String>(
                                                        value: estadoTicketID[index].toString(),
                                                        child: Text(estadoTicket[index],
                                                          style: const TextStyle(
                                                            fontSize:  20,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        int index = estadoTicketID.indexOf(int.parse(value!));
                                                        EstadoTicketElegido = value!;
                                                        debugPrint(EstadoTicketElegido);
                                                        debugPrint(estadoTicketID[index].toString());
                                                        debugPrint((estadoTicket[index].toString()));
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        17.height,
                                        SizedBox(
                                        width: MediaQuery.of(context).size.width*0.50,
                                        child: Text("Criterio",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.050,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.50,
                                          child: TextFormField(
                                            controller: busquedaController ,

                                            onChanged: (value) {
                                              busquedaController .text = value;
                                            },
                                            onFieldSubmitted: (value) {
                                              busquedaController .text = value;
                                            },
                                          ),
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
                                                    fontSize: 25,
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
                                                  final prefs = await SharedPreferences.getInstance();
                                                  setState(() {
                                                    _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                  });
                                                },
                                                child: Text(
                                                  "Filtrar",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                  ),
                                                ),),
                                            )
                                          ],
                                        ),
                                        17.height,
                                        SizedBox(
                                          height: 35,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                              // set the background color
                                            ),
                                              onPressed: ()
                                              {
                                                showDialog<void>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setStateDialog2) {
                                                        return AlertDialog(
                                                          title: const Text("Agregar una nueva gestión"),
                                                          content: Builder(
                                                            builder: (context) {
                                                              return SingleChildScrollView(
                                                                scrollDirection: Axis.vertical,
                                                                child: Form(
                                                                  key: _formKey,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                        child: Text(
                                                                          "Tipo",
                                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                        child: DropdownButtonFormField<String>(
                                                                          validator: (String? value) {
                                                                            if (value == null || value.isEmpty) {
                                                                              return 'Información requerida'; // Error message if empty
                                                                            }
                                                                            return null; // Return null if the input is valid
                                                                          },
                                                                          isExpanded: true,
                                                                          value: gestionIDsB[0].toString(),
                                                                          hint: const Text("Seleccione una Tipo"),
                                                                          decoration: InputDecoration(
                                                                            contentPadding: const EdgeInsets.symmetric(
                                                                                horizontal: 16, vertical: 12),
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              borderSide: const BorderSide(
                                                                                  color: Color.fromRGBO(6, 78, 116, 1), width: 1),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              borderSide: const BorderSide(
                                                                                  color: Color.fromRGBO(6, 78, 116, 1), width: 2),
                                                                            ),
                                                                          ),
                                                                          style: const TextStyle(
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.black87,
                                                                          ),
                                                                          icon: const Icon(Icons.arrow_drop_down,
                                                                              color: Color.fromRGBO(6, 78, 116, 1)),
                                                                          items: List.generate(gestionDescripcionB.length, (index) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: gestionIDsB[index].toString(),
                                                                              child: Text(
                                                                                gestionDescripcionB[index],
                                                                                style: const TextStyle(
                                                                                  fontSize: 18,
                                                                                  color: Colors.black,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                                maxLines: 2,
                                                                              ),
                                                                            );
                                                                          }),
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              int index =
                                                                              gestionIDsB.indexOf(int.parse(value!));
                                                                              TipoElegidoB = value;
                                                                              debugPrint(TipoElegidoB);

                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                        child: Text(
                                                                          "Propiedad",
                                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.45,
                                                                    child: DropdownButtonFormField<String>(
                                                                      validator: (String? value) {
                                                                        if (value == null || value.isEmpty) {
                                                                          return 'Información requerida'; // Mensaje si está vacío
                                                                        }
                                                                        return null; // Si es válido
                                                                      },
                                                                      isExpanded: true,
                                                                      // Si el primer elemento (-1) es solo "Todos", mejor usar null como valor inicial
                                                                      value: (clientesIdsSetB.isNotEmpty && clientesIdsSetB.first != -1)
                                                                          ? clientesIdsSetB.first.toString()
                                                                          : null,
                                                                      hint: const Text("Seleccione una Propiedad"),
                                                                      decoration: InputDecoration(
                                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

                                                                      // --- Construcción segura de los ítems ---
                                                                      items: List.generate(clientesIdsSetB.length, (index) {
                                                                        // Evita errores si las listas no tienen la misma longitud
                                                                        String nombre = (index < propiedadesInternaNombresSetB.length)
                                                                            ? propiedadesInternaNombresSetB[index]
                                                                            : "Desconocido";

                                                                        String direccion = (index < propiedadesDireccionNombresSetB.length)
                                                                            ? propiedadesDireccionNombresSetB[index]
                                                                            : "Sin dirección";

                                                                        return DropdownMenuItem<String>(
                                                                          value: clientesIdsSetB[index].toString(),
                                                                          child: Text(
                                                                            "$nombre $direccion",
                                                                            style: const TextStyle(fontSize: 16, color: Colors.black),
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        );
                                                                      }),

                                                                      // --- Manejo seguro del cambio de valor ---
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          if (value == null) return;

                                                                          // Buscar el índice usando la lista correcta
                                                                          int index = clientesIdsSetB.indexOf(value);

                                                                          if (index != -1 && index < propiedadesDireccionNombresSetB.length) {
                                                                            propiedadElegidoB = value;
                                                                            PropiedadElegidaDEscripcion =
                                                                                propiedadesDireccionNombresSetB[index].toString();

                                                                            debugPrint("✅ Propiedad seleccionada: $propiedadElegidoB");
                                                                            debugPrint("📍 Dirección: $PropiedadElegidaDEscripcion");
                                                                          } else {
                                                                            debugPrint("⚠️ Valor no encontrado o fuera de rango: $value");
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                        child: Text(
                                                                          "Descripción",
                                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.45,

                                                                        child: TextFormField(
                                                                          controller: descripcionController,
                                                                          validator: (String? value) {
                                                                            if (value == null || value.isEmpty) {
                                                                              return 'Información requerida'; // Error message if empty
                                                                            }
                                                                            return null; // Return null if the input is valid
                                                                          },
                                                                          onChanged: (value) {
                                                                            descripcionController.text = value;
                                                                          },
                                                                          onFieldSubmitted: (value) {
                                                                            descripcionController.text = value;
                                                                          },
                                                                        ),
                                                                      ),
                                                                      10.height,

                                                                      // ---------- BOTÓN SELECCIONAR IMÁGENES ----------
                                                                      Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                          ),
                                                                          onPressed: () async {

                                                                            final regresarImagenesSelect =
                                                                            await ImagePicker().pickMultiImage();

                                                                            setStateDialog2(() {
                                                                              if (regresarImagenesSelect.isEmpty) return;
                                                                              imagenesSeleccionadas = regresarImagenesSelect
                                                                                  .map((x) => File(x.path))
                                                                                  .toList();
                                                                              debugPrint("Imagenes recibidas");
                                                                              debugPrint(regresarImagenesSelect.toString());
                                                                              debugPrint("Imagenes enlistadas");
                                                                              debugPrint(imagenesSeleccionadas.toString());
                                                                              debugPrint("Listas creadas");
                                                                            });
                                                                            for (var img in imagenesSeleccionadas) {
                                                                              List<int> imageBytes =
                                                                              await img.readAsBytes();
                                                                              base64Images.add(base64Encode(imageBytes));
                                                                            }
                                                                            debugPrint("Imagenes en String");
                                                                            debugPrint(base64Images.toString());
                                                                            msgxToast("Cargando imágenes...");
                                                                          },
                                                                          child: Text(
                                                                            "Elegir Fotografías de Galería",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize:
                                                                              MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      10.height,
                                                                      // ---------- LISTADO DE IMÁGENES ----------
                                                                  imagenesSeleccionadas.isNotEmpty
                                                                      ? SizedBox(
                                                                    height:  MediaQuery.of(context).size.width*0.4,
                                                                    width:  MediaQuery.of(context).size.width*0.4,
                                                                      child: CarouselSlider(
                                                                      options: CarouselOptions(
                                                                        height:  MediaQuery.of(context).size.width * 0.4,
                                                                        enableInfiniteScroll: false,
                                                                        enlargeCenterPage: true,
                                                                        viewportFraction: 1.0,
                                                                        autoPlay: true,
                                                                      ),
                                                                      items: imagenesSeleccionadas.map((imgFile) {
                                                                        return Builder(
                                                                          builder: (BuildContext context) {
                                                                            return SizedBox(
                                                                              width: MediaQuery.of(context).size.width* 0.4,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                                child: Image.file(
                                                                                  imgFile,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ) : const Text("Selecione una imagen como minimo"),
                                                                      10.height,
                                                                      // ---------- CREAR TICKET ----------
                                                                      Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                            const Color.fromRGBO(6, 78, 116, 1),
                                                                          ),

                                                                          onPressed: () async {
                                                                            debugPrint("boton presionado");
                                                                            if (!_formKey.currentState!.validate()) {
                                                                              msgxToast("1 Por favor complete todos los campos requeridos.");
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text("Por favor complete todos los campos requeridos."),
                                                                                ),
                                                                              );
                                                                              return;
                                                                            }

                                                                            final prefs = await SharedPreferences.getInstance();
                                                                            String? cliente = "";
                                                                            cliente = prefs.getString("cliente");
                                                                            debugPrint(base64Images.toString());
                                                                            debugPrint("Seting tickets");
                                                                            debugPrint(propiedadElegidoB);
                                                                            debugPrint(TipoElegidoB);
                                                                            debugPrint(descripcionController.text);
                                                                            debugPrint(prefs.getString("cliente"));
                                                                            debugPrint(base64Images.toString());
                                                                            debugPrint(clienteIDset);
                                                                            debugPrint("Total imágenes convertidas: ${base64Images.length}");
                                                                            ServicioTickets(propiedadElegidoB,PropiedadElegidaDEscripcion,TipoElegidoB,descripcionController.text,prefs.getString("cliente")!,base64Images);
                                                                            await ServicioTickets(propiedadElegidoB,PropiedadElegidaDEscripcion,TipoElegidoB,descripcionController.text,prefs.getString("cliente")!,base64Images).listadoCreacionTickets();

                                                                            setState(() {
                                                                              _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                                            });
                                                                            Navigator.of(context).pop();
                                                                            imagenesSeleccionadas.clear();
                                                                            base64Images.clear();
                                                                          },
                                                                          child: Text(
                                                                            "Crear gestión",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize:
                                                                              MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              style: TextButton.styleFrom(
                                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                                              ),
                                                              child: const Text('Cerrar'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                                debugPrint("test Press");
                                              },
                                              child: Text(
                                                "Crear ticket",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:   Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width* 0.05,
                                                ),
                                              ),
                                          ),
                                        ),
                                        17.height,
                                        ]
                                    ),
                                      )],
                                    )
                                ),
                                17.height,
            FutureBuilder<List<TickestG5>>(
              future: _futureTickets,
              builder: (context, snapshot) {
                final theme = Theme.of(context);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error cargando tickets",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: const Color.fromRGBO(6, 78, 116, 1),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay tickets pendientes",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: const Color.fromRGBO(6, 78, 116, 1),
                      ),
                    ),
                  );
                }

                final documentos = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    final event = documentos[index];
                    final images = event.plFotografias
                        ?.where((f) => f.pvFotografiaB64 != null && f.pvFotografiaB64!.isNotEmpty)
                        .map((f) => f.pvFotografiaB64!)
                        .toList() ??
                        [];

                    _controllers.putIfAbsent(index, () => CarouselSliderController());
                    _currentIndex[index] = _currentIndex[index] ?? 0;

                    final screenWidth = MediaQuery.of(context).size.width;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
                      child: Card(
                        color: const Color.fromRGBO(237, 237, 237, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 🔹 Auto-adjust height
                            children: [
                              // Estado
                              Text(
                                event.pvEstadoDescripcion ?? "",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: screenWidth * 0.045,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 10),

                              // Imagen + Datos principales
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // 🖼️ Carrusel de imágenes
                                      SizedBox(
                                        width: constraints.maxWidth * 0.45,
                                        child: images.isNotEmpty
                                            ? Stack(
                                          children: [
                                            CarouselSlider(
                                              carouselController: _controllers[index],
                                              options: CarouselOptions(
                                                viewportFraction: 1.0,
                                                enableInfiniteScroll: false,
                                                enlargeCenterPage: true,
                                                height: constraints.maxWidth * 0.45,
                                                onPageChanged: (page, reason) {
                                                  _currentIndex[index] = page;
                                                },
                                              ),
                                              items: images.map((base64Img) {
                                                final bytes = base64Decode(base64Img);
                                                return GestureDetector(
                                                  onTap: () => showImageDialog2(context, base64Img),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.memory(
                                                      bytes,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        )
                                            : const Center(child: Text("Sin fotos")),
                                      ),

                                      // 📄 Información del ticket
                                      SizedBox(width: constraints.maxWidth * 0.05),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Ticket ${event.pnGestion}",
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(167, 167, 132, 1),
                                                fontSize: screenWidth * 0.045,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              event.pvDescripcion ?? "",
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(167, 167, 132, 1),
                                                fontSize: screenWidth * 0.04,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              event.pvPropiedadDescripcion ?? "",
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(167, 167, 132, 1),
                                                fontSize: screenWidth * 0.04,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              DateFormat('dd MMMM yyyy', "es_ES").format(
                                                  DateTime.parse(event.pfFecha ?? DateTime.now().toString())),
                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(167, 167, 132, 1),
                                                fontSize: screenWidth * 0.04,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 15),

                              // CREACIÓN / ATENCIÓN
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _infoColumn(
                                    theme,
                                    "CREACIÓN",
                                    _formatDuration(event.pvTiempoCreacion),
                                    screenWidth,
                                  ),
                                  _infoColumn(
                                    theme,
                                    "ATENCIÓN",
                                    _formatDuration(event.pvTiempoAtencion),
                                    screenWidth,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // GESTIÓN / CALIFICACIÓN
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _infoColumn(
                                    theme,
                                    "GESTIÓN",
                                    event.pvGestionTipoDescripcion ?? "",
                                    screenWidth,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "CALIFICACIÓN",
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(167, 167, 132, 1),
                                          fontSize: screenWidth * 0.04,
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating: event.pnCalificacion?.toDouble() ?? 0,
                                        minRating: 1,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: screenWidth * 0.05,
                                        itemPadding:
                                        const EdgeInsets.symmetric(horizontal: 2.0),
                                        itemBuilder: (context, _) =>
                                        const Icon(Icons.star, color: Colors.amber),
                                        onRatingUpdate: (rating) {
                                          debugPrint("New rating: $rating");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                             event.pnPermiteSeguimiento == 1 ? SizedBox(
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                    // set the background color
                                  ),
                                  onPressed: ()
                                  {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                            return AlertDialog(
                                              scrollable: true,
                                              title:  Text("Ticket ${event.pnGestion} ${event.pvDescripcion.toString()} ${event.pvEstadoDescripcion.toString()}",maxLines: 3,),
                                              content: SizedBox(
                                              width: screenWidth * 0.9,
                                              child: Column(
                                                  children: [
                                                    20.height,
                                                    event.plSeguimiento != null ? SizedBox(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height * 0.4,
                                                      child: ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics: const BouncingScrollPhysics(),
                                                        itemCount: event.plSeguimiento?.length ?? 0,
                                                        itemBuilder: (context, index)
                                                        {
                                                          return  Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [

                                                              const SizedBox(height: 10),
                                                              Text(event.plSeguimiento![index].pvUsuario,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                                fontSize: screenWidth * 0.045,
                                                              ),),
                                                              Row(
                                                                children: [
                                                                  Text(() {
                                                                    final raw = event.pvTiempoCreacion;
                                                                    if (raw == null || raw == "") return 'Sin atender';
                                                                    Duration duration = Duration(seconds: raw);
                                                                    int days = duration.inDays;
                                                                    int hours = duration.inHours % 24;
                                                                    int minutes = duration.inMinutes % 60;
                                                                    return "${days}d ${hours}h ${minutes}m";
                                                                  }(),
                                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: const Color.fromRGBO(6, 78, 116, 1),
                                                                      fontSize: screenWidth * 0.04,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Text(
                                                                DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.plSeguimiento![index].pfFecha!)),
                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                                  fontSize: screenWidth * 0.045,
                                                                ),
                                                                maxLines: 2,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Text(
                                                                event.plSeguimiento![index].pvComentario,
                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                                  fontSize: screenWidth* 0.045,
                                                                ),
                                                                maxLines: 2,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 10),
                                                              SizedBox(
                                                                width: screenWidth* 0.40,
                                                                height:screenWidth * 0.30,
                                                                child: event.plSeguimiento![index].plFotografias != null
                                                                    ? ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: Image.memory(
                                                                    base64Decode(event.plSeguimiento![index].plFotografias[0].pvFotografiaB64.toString()),
                                                                    fit: BoxFit.fill,
                                                                    width: double.infinity,
                                                                  ),
                                                                )
                                                                    : Icon(Icons.image_not_supported,size: 80,),
                                                              ),

                                                              const SizedBox(height: 10),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ):Center(),
                                                    20.height,
                                                    Form(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "Comentario",
                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize:
                                                                MediaQuery.of(context).size.width * 0.045,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                              child: TextFormField(
                                                                keyboardType: TextInputType.multiline,
                                                                controller: comentarioController,
                                                                onChanged: (value) =>
                                                                comentarioController.text = value,
                                                                onFieldSubmitted: (value) =>
                                                                comentarioController.text = value,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            // ---------- BOTÓN SELECCIONAR IMÁGENES ----------
                                                            Container(
                                                              padding: const EdgeInsets.all(10),
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                  const Color.fromRGBO(6, 78, 116, 1),
                                                                ),
                                                                onPressed: () async {
                                                                  final regresarImagenesSelect =
                                                                  await ImagePicker().pickMultiImage();

                                                                  setStateDialog(() {
                                                                    if (regresarImagenesSelect.isEmpty) return;
                                                                    imagenesSeleccionadas_B = regresarImagenesSelect
                                                                        .map((x) => File(x.path))
                                                                        .toList();
                                                                  });

                                                                  for (var img in imagenesSeleccionadas_B) {
                                                                    List<int> imageBytes = await img.readAsBytes();
                                                                    base64Images_B.add(base64Encode(imageBytes));
                                                                  }

                                                                  msgxToast("Cargando imágenes...");
                                                                },
                                                                child: Text(
                                                                  "Elegir Fotografías de Galería",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize:
                                                                    MediaQuery.of(context).size.width * 0.03,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            // ---------- LISTADO DE IMÁGENES ----------
                                                            imagenesSeleccionadas_B.isNotEmpty
                                                                ? SizedBox(
                                                              height:
                                                              MediaQuery.of(context).size.width * 0.4,
                                                              width: MediaQuery.of(context).size.width * 0.4,
                                                              child: CarouselSlider(
                                                                options: CarouselOptions(
                                                                  height:
                                                                  MediaQuery.of(context).size.width * 0.4,
                                                                  enableInfiniteScroll: false,
                                                                  enlargeCenterPage: true,
                                                                  viewportFraction: 1.0,
                                                                  autoPlay: true,
                                                                ),
                                                                items: imagenesSeleccionadas_B.map((imgFile) {
                                                                  return Builder(
                                                                    builder: (BuildContext context) {
                                                                      return SizedBox(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                            0.4,
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                          BorderRadius.circular(12),
                                                                          child: Image.file(
                                                                            imgFile,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            )
                                                                : const Text("Seleccione una imagen como mínimo"),
                                                            const SizedBox(height: 10),
                                                            // ---------- CREAR TICKET ----------
                                                            Container(
                                                              padding: const EdgeInsets.all(10),
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                  const Color.fromRGBO(6, 78, 116, 1),
                                                                ),
                                                                onPressed: () async {
                                                                  await ServicioSeguimientoTickets(
                                                                    comentarioController.text,
                                                                    base64Images_B,
                                                                    event.pnGestion.toString(),
                                                                  ).listadoSeguimientoTickets();

                                                                  comentarioController.clear();
                                                                  Navigator.of(context).pop();
                                                                  imagenesSeleccionadas_B.clear();
                                                                  base64Images_B.clear();
                                                                  setState(() {
                                                                    _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Ingresar seguimiento",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize:
                                                                    MediaQuery.of(context).size.width * 0.03,
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
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Seguimiento",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  ),
                                ),
                              ):Center(),
                              event.pnPermiteEnProceso == 1 ? SizedBox(
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                    // set the background color
                                  ),
                                  onPressed: ()
                                  {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                            return AlertDialog(
                                              title:  Text("Ticket en ${event.pvEstadoDescripcion.toString()}",maxLines: 3,),
                                              content: Column(
                                                children: [
                                                  Text("La gestion: ${event.pvDescripcion.toString()}"),
                                                  Text("Cambiará a estado: En Proceso. "),
                                                  TextButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                      // set the background color
                                                    ),
                                                    child: const Text('Confirmar '),
                                                    onPressed: () async{
                                                      ServicioProcesoTickets(event.pnGestion.toString()).listadoProcesoTickets();
                                                      setState(() {
                                                        _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              )
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("En Proceso",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  ),
                                ),
                              ):Center(),
                             event.pnPermiteFinalizar == 1 ? SizedBox(
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                    // set the background color
                                  ),
                                  onPressed: ()
                                  {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                            return AlertDialog(
                                                title:  Text("Finalizar la Gestión ",maxLines: 3,),
                                                content: Column(
                                                  children: [
                                                    Text("La gestion: ${event.pvDescripcion.toString()}"),
                                                    Text("Cambiará a estado: Finalizada."),
                                                    TextButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                        // set the background color
                                                      ),
                                                      child: const Text('Confirmar'),
                                                      onPressed: () async{
                                                        ServicioFinalizarTickets(event.pnGestion.toString()).listadoFinalizarTickets();
                                                        setState(() {
                                                          _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                        });
                                                        Navigator.of(context).pop();
                                                        },
                                                    ),
                                                  ],
                                                )
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Finalizar",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  ),
                                ),
                              ):Center(),
                            event.pnPermiteCerrar == 1 ?  SizedBox(
                                width: MediaQuery.of(context).size.width*0.35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                    // set the background color
                                  ),
                                  onPressed: ()
                                  {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                            return AlertDialog(
                                                title:  Text("Cerrar la Gestión ",maxLines: 3,),
                                                content: Column(
                                                  children: [
                                                    Text("La gestion: ${event.pvDescripcion.toString()}"),
                                                    Text("Cambiará a estado: Finalizada. "),
                                                    TextButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                        // set the background color
                                                      ),
                                                      child: const Text('Confirmar '),
                                                      onPressed: () async{
                                                        ServicioCerrarTickets(event.pnGestion.toString(),event.pnCalificacion.toString()).listadoCerrarTickets();
                                                        setState(() {
                                                          _futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                )
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Cerrar",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  ),
                                ),
                              ):Center(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
                                17.height,
                              ]
                          )
                      )
                )
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

void showImageDialog2(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
  );
}
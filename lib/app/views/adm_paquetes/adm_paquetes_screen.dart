import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:administra/api_Clases/class_Paquetes6.dart';
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
import '../../controller/adm_lista_de_paquetes.controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:developer'as devLog;


class AdmPaquetesListadosScreen extends StatefulWidget {
  const AdmPaquetesListadosScreen({super.key});

  @override
  State<AdmPaquetesListadosScreen> createState() => _AdmComunicacionAdminScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmComunicacionAdminScreenState extends State<AdmPaquetesListadosScreen> {

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

  List<String> periodeDeCuenta = ["Todos","Del día","Semana En Curso","Mes En Curso","Año En Curso"];
  List<int> periodeDeCuentaID = [-1,1,2,3,4];


  List<String> estadoTicket = ["Todos","Ingresada","En Proceso","Finalizada","Aperturada","Cerrada"];
  List<int> estadoTicketID = [-1,1,2,3,4,0];

  Future<List<PaqueteG6>> ? _futurePaqueteG6;

  TextEditingController busquedaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  TextEditingController comentarioController = TextEditingController();
  TextEditingController controllerFecha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyEdicion = GlobalKey<FormState>();
  final _formKeyRecolecta = GlobalKey<FormState>();
  String periodoElegido = "2";
  String propiedadElegido = "-1";
  String propiedadElegidoDescripcion = " ";
  String TipoElegido = "-1";
  String EstadoTicketElegido = "-1";

  String propiedadElegidoB = "-1";
  String propiedadElegidoID_B = " ";
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

  TextEditingController controllerFechaEditada = TextEditingController();
  TextEditingController controllerFechaRecolectar = TextEditingController();
  TextEditingController controllerObsevacionesRecolectar = TextEditingController();
  TextEditingController descripcionControllerEdit = TextEditingController();
  String propiedadElegidoEdicion = "-1";
  String propiedadElegidoID_Edicion = " ";
  String PropiedadElegidaDEscripcionEdicion = "";

  List<File> imagenesSeleccionadas_Edicion = [];
  List<String> base64Images_Edicion = [];

  List<String>radioTipo =["1","0","-1"];

  late String tipoOpcion = radioTipo[2];

  String base64Image = "";
  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  final Map<int, CarouselSliderController> _controllers2 = {};
  final Map<int, int> _currentIndex2 = {};
    DateTime fechaHora = DateTime.now();
    DateTime fechaHoraEditar = DateTime.now();
    DateTime fechaHoraRecolecta = DateTime.now();
    String NotadminCheck = "";
    bool notCreateAdmin = false;
  String admincheck = "";
  String juntaDirect = "";
  String inquilino = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();

    setState(() {
      theme = admComunicacionAdminController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;

      propiedadCuentaID = propiedadesInternasIdsSet[0];
      periodoCuentaID = periodeDeCuentaID[2].toString();
    }
    );
  }

  getUserInfo() async
  {
    if(propiedadElegido == "-1")
    {
      if(admincheck == "0")
        {
          _futurePaqueteG6 = ServiciosListadoDePaquetes("",periodoElegido,"1","").paquetesG6();
        }
      _futurePaqueteG6 = ServiciosListadoDePaquetes("",periodoElegido,TipoElegido,"").paquetesG6();
    }
    else {
      _futurePaqueteG6 =
          ServiciosListadoDePaquetes(
              propiedadElegido,
              periodoElegido,
              TipoElegido,
              propiedadCuentaID)
              .paquetesG6();
        }
    //_futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();

    final prefs = await SharedPreferences.getInstance();
    setState(() {

      userName = prefs.getString("NombreUser")!;
      NotadminCheck = prefs.getString("Admin") ?? "0";
      admincheck = prefs.getString("Admin")!;
      juntaDirect = prefs.getString("JuntaDirectiva")!;
      inquilino = prefs.getString("Inquilino") ?? "0";

      if(NotadminCheck == "0")
        {
          notCreateAdmin = true;
        }
      else
        {
          notCreateAdmin = false;
        }

      /*
      instrucionesPago = prefs.getString("intruciones de pago")!;
      debugPrint("Intruciones");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
       */
    });
  }
  reloadPage()
  {
    setState(() {
      if(propiedadElegido == "-1")
      {
        _futurePaqueteG6 = ServiciosListadoDePaquetes("",periodoElegido,TipoElegido,"").paquetesG6();
      }
      else {
        _futurePaqueteG6 =
            ServiciosListadoDePaquetes(
                propiedadElegido,
                periodoElegido,
                TipoElegido,
                propiedadCuentaID)
                .paquetesG6();
      }
    });
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

  bool _canPop = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PopScope(
        // Set canPop dynamically based on the variable.
        canPop: _canPop,
        onPopInvoked: (bool didPop) {
      if (didPop) {
        return; // The navigation happened, so nothing else to do.
      }

      // Custom logic here if needed when pop is blocked (e.g., show a dialog).
      if (!_canPop) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor cierre sesión apropiadamente')),
        );
      }
    },
      child: Scaffold(
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
                                                  value: periodeDeCuentaID[2].toString(),
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
                                                  value: clientesIdsSet.isNotEmpty ? clientesIdsSet[0] : null,
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
                                                      child: Text(
                                                          "${propiedadesInternaNombresSet[index]} (${propiedadesDireccionNombresSet[index]})",
                                                        style: const TextStyle(fontSize: 20, color: Colors.black),
                                                      ),
                                                    );
                                                  }),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      // Get index of selected value
                                                      int selectedIndex = clientesIdsSet.indexOf(value!);

                                                      // Optional: print and use it
                                                      debugPrint('Selected index: $selectedIndex');
                                                      debugPrint('Selected value: ${propiedadesInternasIdsSet[selectedIndex]}');
                                                      debugPrint('Selected value: $value');
                                                      debugPrint('Selected name: ${propiedadesInternaNombresSet[selectedIndex]}');


                                                      // Store selected info
                                                      propiedadElegido = value;
                                                      propiedadCuentaID = propiedadesInternasIdsSet[selectedIndex];
                                                      propiedadElegidoDescripcion = propiedadesInternaNombresSet[selectedIndex];
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      17.height,
                                      /*
                                      * SizedBox(
                                        width: MediaQuery.of(context).size.width*0.50,
                                        child: Text("Criterio",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.050,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),),
                                      ),*/
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
                                                  if(propiedadElegido == "-1")
                                                  {
                                                    _futurePaqueteG6 = ServiciosListadoDePaquetes("",periodoElegido,TipoElegido,"").paquetesG6();
                                                  }
                                                  else {
                                                    _futurePaqueteG6 =
                                                        ServiciosListadoDePaquetes(
                                                            propiedadElegido,
                                                            periodoElegido,
                                                            TipoElegido,
                                                            propiedadCuentaID)
                                                            .paquetesG6();
                                                  }
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
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Column(
                                          children: [
                                            Text("Recolectado",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(6,78,116,1),
                                              fontSize: MediaQuery.of(context).size.width*0.050,
                                            )),
                                            ListTile(
                                              title: Text("Sí"),
                                              leading: Radio<String>(
                                                value: radioTipo[0],
                                                groupValue: TipoElegido,
                                                onChanged: (value){
                                                  setState(() {
                                                    TipoElegido = value!;
                                                    debugPrint(TipoElegido.toString());
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: Text("No"),
                                              leading: Radio<String>(
                                                value: radioTipo[1],
                                                groupValue: TipoElegido,
                                                onChanged: (value){
                                                  setState(() {
                                                    TipoElegido = value!;
                                                    debugPrint(TipoElegido.toString());
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: Text("Todos"),
                                              leading: Radio<String>(
                                                value: radioTipo[2],
                                                groupValue: TipoElegido,
                                                onChanged: (value){
                                                  setState(() {
                                                    TipoElegido = value!;
                                                    debugPrint(TipoElegido.toString());
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      17.height,
                                      admincheck == "1" || juntaDirect == "2"?  SizedBox(
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
                                                      title: const Text("Agregar un nuevo paquete"),
                                                      content: Builder(
                                                          builder: (context) {
                                                            return SingleChildScrollView(
                                                              scrollDirection: Axis.vertical,
                                                              child: Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  children: [
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Descripción clara del paquete:",
                                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                          color: const Color.fromRGBO(6, 78, 116, 1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    10.height,
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
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Fecha de recepción",
                                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                          color: const Color.fromRGBO(6, 78, 116, 1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    TextFormField(
                                                                      controller: controllerFecha,
                                                                      readOnly: true,
                                                                      decoration: InputDecoration(
                                                                        hintText: "Fecha y hora",
                                                                        border: const OutlineInputBorder(),
                                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                      ),
                                                                      onTap: () async {
                                                                        // Step 1: Pick the date
                                                                        DateTime? fechaSelect = await showDatePicker(
                                                                          context: context,
                                                                          initialDate: DateTime.now(),
                                                                          firstDate: DateTime(2000),
                                                                          lastDate: DateTime(3000),
                                                                          builder: (BuildContext context, Widget? child) {
                                                                            return Theme(
                                                                              data: Theme.of(context).copyWith(
                                                                                colorScheme: const ColorScheme.light(
                                                                                  primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                ),
                                                                              ),
                                                                              child: child!,
                                                                            );
                                                                          },
                                                                        );

                                                                        if (fechaSelect != null) {
                                                                          // Step 2: Pick the time
                                                                          TimeOfDay? horaSelect = await showTimePicker(
                                                                            context: context,
                                                                            initialTime: TimeOfDay.now(),
                                                                            builder: (BuildContext context, Widget? child) {
                                                                              return Theme(
                                                                                data: Theme.of(context).copyWith(
                                                                                  colorScheme: const ColorScheme.light(
                                                                                    primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                  ),
                                                                                ),
                                                                                child: child!,
                                                                              );
                                                                            },
                                                                          );

                                                                          if (horaSelect != null) {
                                                                            // Combine date and time
                                                                            fechaHora = DateTime(
                                                                              fechaSelect.year,
                                                                              fechaSelect.month,
                                                                              fechaSelect.day,
                                                                              horaSelect.hour,
                                                                              horaSelect.minute,
                                                                            );

                                                                            setState(() {
                                                                              debugPrint("Fecha");
                                                                              debugPrint(controllerFecha.text);
                                                                              controllerFecha.text = DateFormat('dd/MM/yyyy').format(fechaHora);
                                                                              debugPrint(controllerFecha.text);
                                                                            });
                                                                          }
                                                                        }
                                                                      },
                                                                      validator: (value) =>
                                                                      (value == null || value.isEmpty) ? 'Información requerida' : null,
                                                                    ),
                                                                    10.height,
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
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: DropdownButtonFormField<String>(
                                                                        validator: (String? value) {
                                                                          debugPrint("✅ Propiedad seleccionada: $propiedadElegidoB");
                                                                          debugPrint("✅ Propiedad seleccionada ID: $propiedadElegidoID_B");
                                                                          debugPrint("📍 Dirección: $PropiedadElegidaDEscripcion");
                                                                          if (propiedadElegidoB == "-1" || value == null || value.isEmpty || clientesIdsSetB.first == "") {
                                                                            return 'Información requerida'; // Mensaje si está vacío
                                                                          }
                                                                          return null; // Si es válido
                                                                        },
                                                                        isExpanded: true,

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
                                                                              "$direccion",
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
                                                                              propiedadElegidoID_B = propiedadesInternasIdsSetB[index].toString();
                                                                              PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[index].toString();

                                                                              debugPrint("✅ Propiedad seleccionada: $propiedadElegidoB");
                                                                              debugPrint("✅ Propiedad seleccionada ID: $propiedadElegidoID_B");
                                                                              debugPrint("📍 Dirección: $PropiedadElegidaDEscripcion");
                                                                            } else {
                                                                              debugPrint("⚠️ Valor no encontrado o fuera de rango: $value");
                                                                            }
                                                                          });
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
                                                                          debugPrint("Seting Paquete");
                                                                          debugPrint(propiedadElegidoB);
                                                                          debugPrint(PropiedadElegidaDEscripcion);
                                                                          debugPrint(propiedadElegidoID_B);
                                                                          debugPrint(descripcionController.text);
                                                                          controllerFecha.text = DateFormat('yyyyMMdd').format(fechaHora);
                                                                          debugPrint(controllerFecha.text);
                                                                          //debugPrint(prefs.getString("cliente"));
                                                                          //debugPrint(base64Images.toString());
                                                                          //devLog.log(base64Images.toString());
                                                                          debugPrint(clienteIDset);
                                                                          debugPrint("Total imágenes convertidas: ${base64Images.length}");

                                                                          setState(() {
                                                                            ServiciosListadoDePaquetesRecepcion(controllerFecha.text, propiedadElegidoID_B,
                                                                                propiedadElegidoB,PropiedadElegidaDEscripcion,
                                                                                descripcionController.text,base64Images).paquetesG7();
                                                                            //_futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();
                                                                          });
                                                                          Future.delayed(const Duration(seconds: 3), ()
                                                                          {
                                                                            if (propiedadElegido ==
                                                                                "-1") {
                                                                              _futurePaqueteG6 =
                                                                                  ServiciosListadoDePaquetes(
                                                                                      "-1",
                                                                                      periodoElegido,
                                                                                      TipoElegido,
                                                                                      "1")
                                                                                      .paquetesG6();
                                                                            }
                                                                            else {
                                                                              _futurePaqueteG6 =
                                                                                  ServiciosListadoDePaquetes(
                                                                                      propiedadElegido,
                                                                                      periodoElegido,
                                                                                      TipoElegido,
                                                                                      propiedadCuentaID)
                                                                                      .paquetesG6();
                                                                            }
                                                                            reloadPage();
                                                                            controllerFechaRecolectar.text = "";
                                                                            controllerObsevacionesRecolectar.text = "";
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .pop();
                                                                            msgxToast(
                                                                                "Paquete Creado");
                                                                            imagenesSeleccionadas.clear();
                                                                            base64Images.clear();
                                                                          }
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "Nuevo paquete gestión",
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
                                            "Crear  paquetes",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:   Colors.white,
                                              fontSize: MediaQuery.of(context).size.width* 0.05,
                                            ),
                                          ),
                                        ),
                                      ):Center(),
                                      17.height,
                                    ]
                                ),
                              )],
                          )
                      ),
                      17.height,
                      FutureBuilder<List<PaqueteG6>>(future: _futurePaqueteG6,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return  Center(
                                child: Title(color: Color.fromRGBO(6,78,116,1),
                                  child: Text("No hay paquetes registrados",style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                    color: Color.fromRGBO(6,78,116,1),
                                  ),
                                  ),
                                )
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return  Center(
                                child: Title(color: Color.fromRGBO(6,78,116,1),
                                  child: Text("No hay paquetes registrados",style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                    color: Color.fromRGBO(6,78,116,1),
                                  ),
                                  ),
                                )
                            );
                          }
                          final events = snapshot.data!;
                          //debugPrint(events.toString());
                          return LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];

                                    final images = event.plFotografias
                                        ?.where((f) => f.pvFotografiaB64 != null && f.pvFotografiaB64!.isNotEmpty)
                                        .map((f) => f.pvFotografiaB64!)
                                        .toList() ?? [];

                                    _controllers.putIfAbsent(index, () => CarouselSliderController());
                                    _currentIndex[index] = _currentIndex[index] ?? 0;
                                    return  Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              15.height,
                                              Row(
                                                children: [
                                                  event.pvRecolectado == "1" ? Text("Recolectado",style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:event.pvRecolectado == "1" ? Colors.amber[600]:Colors.pink[900],
                                                    fontSize: 20,
                                                  )):Text("No Recolectado",style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:event.pvRecolectado == "1" ? Colors.amber[600]:Colors.pink[900],
                                                    fontSize: 20,
                                                  ))
                                                ],
                                              ), 15.height,
                                              Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(event.pvDescripcion,style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),
                                                      ),Text("Recibido el ",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),
                                                      ),
                                                      Text((DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pfFecha!)).toString()),style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),
                                                      Text("Dirección  ",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),Text(event.pvPropiedadDescripcion,style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),

                                                    ],
                                                  ),
                                                  /*SizedBox(
                                                   width: constraints.maxWidth*0.40,
                                                   height: constraints.maxWidth*0.30,
                                                   child:GestureDetector(
                                                     onTap: () => showImageDialog2(
                                                       context,
                                                       event.plFotografias[0].pvFotografiaB64,
                                                     ),
                                                     child: ClipRRect(
                                                       borderRadius: BorderRadius.circular(20),
                                                       child: Image.memory(base64Decode(event.plFotografias[0].pvFotografiaB64),
                                                         fit: BoxFit.contain,
                                                         width: double.infinity,
                                                       ),
                                                     ),
                                                   ),
                                                 ),*/
                                                  StatefulBuilder(
                                                      builder: (context, setLocalState) {
                                                        return  SizedBox(
                                                          width: constraints.maxWidth * 0.40,
                                                          height: constraints.maxWidth * 0.30,
                                                          child: images.isNotEmpty
                                                              ? Stack(
                                                            children: [CarouselSlider(
                                                              carouselController: _controllers[index],
                                                              options: CarouselOptions(
                                                                viewportFraction: 1.0,
                                                                enableInfiniteScroll: false,
                                                                enlargeCenterPage: true,
                                                                height: 200,
                                                                onPageChanged: (page, reason) {
                                                                  setLocalState(() {
                                                                    _currentIndex[index] = page;
                                                                  });
                                                                },
                                                              ),
                                                              items: images.map((base64Img) {
                                                                final bytes = base64Decode(base64Img);
                                                                return GestureDetector(
                                                                  onTap: () => showImageDialog2(context,base64Img),
                                                                  child: ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10),
                                                                    child: Image.memory(
                                                                      bytes,
                                                                      fit: BoxFit.cover,
                                                                      width: double.infinity,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),

                                                              if (images.length > 1)
                                                                Positioned(
                                                                  left: 10,
                                                                  top: 0,
                                                                  bottom: 0,
                                                                  child: IconButton(
                                                                    icon: const Icon(
                                                                      Icons.arrow_back_ios,
                                                                      color: Colors.white,
                                                                      size: 20,
                                                                    ),
                                                                    onPressed: () {
                                                                      _controllers[index]?.previousPage(
                                                                        duration: const Duration(
                                                                            milliseconds: 300),
                                                                        curve: Curves.easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),

                                                              // ➡️ Flecha derecha
                                                              if (images.length > 1)
                                                                Positioned(
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0,
                                                                  child: IconButton(
                                                                    icon: const Icon(
                                                                      Icons.arrow_forward_ios,
                                                                      color: Colors.white,
                                                                      size: 20,
                                                                    ),
                                                                    onPressed: () {
                                                                      _controllers[index]?.nextPage(
                                                                        duration: const Duration(
                                                                            milliseconds: 300),
                                                                        curve: Curves.easeInOut,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          )
                                                              : const Center(child: Text("Sin fotos")),
                                                        );
                                                      }
                                                  ),
                                                  15.height,
                                                  event.pvRecolectado == "1" ? Column(
                                                    children: [
                                                      SizedBox(),
                                                      Text("Recolectado el  ",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),
                                                      Text((DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pvRecolectadoFecha!)).toString()),style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),
                                                      Text("Observaciones ",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),),
                                                      Text(event.pvRecolectadoObservaciones,style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(6,78,116,1),
                                                        fontSize: 20,
                                                      ),)
                                                    ],
                                                  ):Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      admincheck == "1" || juntaDirect == "2"? ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color.fromRGBO(167, 167, 132, 1),
                                                          // set the background color
                                                        ),
                                                        onPressed: () async{
                                                          final prefs = await SharedPreferences.getInstance();
                                                          showDialog<void>(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(
                                                                  builder: (BuildContext context, StateSetter setStateDialog2) {
                                                                    final PageController pageController = PageController();
                                                                    int currentIndex = 0;

                                                                    return AlertDialog(
                                                                        title: Text("¿Está seguro de que desea autorizar la recolección de ${event.pvDescripcion}?"),
                                                                        content: Builder(
                                                                            builder: (context) {
                                                                              return SingleChildScrollView(
                                                                                  scrollDirection: Axis.vertical,
                                                                                  child: Form(
                                                                                    key: _formKeyRecolecta,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text("Observaciones",style: theme.textTheme.bodyMedium?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                            color: const Color.fromRGBO(6, 78, 116, 1))),
                                                                                        10.height,
                                                                                        TextFormField(
                                                                                            controller: controllerObsevacionesRecolectar,
                                                                                            decoration: InputDecoration(
                                                                                              hintText: "Quien lo recolectó, contacto, etc.",
                                                                                              border: const OutlineInputBorder(),
                                                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                            ),
                                                                                            minLines: 2,
                                                                                            maxLines: 3,
                                                                                            onChanged: (value)
                                                                                            {
                                                                                              setStateDialog2(() {
                                                                                                controllerObsevacionesRecolectar.text = value;
                                                                                              });
                                                                                            }
                                                                                        ),
                                                                                        TextFormField(
                                                                                          controller: controllerFechaRecolectar,
                                                                                          readOnly: true,
                                                                                          decoration: InputDecoration(
                                                                                            hintText: "Fecha y hora",
                                                                                            border: const OutlineInputBorder(),
                                                                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                          ),
                                                                                          onTap: () async {
                                                                                            // Step 1: Pick the date
                                                                                            DateTime? fechaSelect = await showDatePicker(
                                                                                              context: context,
                                                                                              initialDate: DateTime.now(),
                                                                                              firstDate: DateTime(2000),
                                                                                              lastDate: DateTime(3000),
                                                                                              builder: (BuildContext context, Widget? child) {
                                                                                                return Theme(
                                                                                                  data: Theme.of(context).copyWith(
                                                                                                    colorScheme: const ColorScheme.light(
                                                                                                      primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                                    ),
                                                                                                  ),
                                                                                                  child: child!,
                                                                                                );
                                                                                              },
                                                                                            );

                                                                                            if (fechaSelect != null) {
                                                                                              // Step 2: Pick the time
                                                                                              TimeOfDay? horaSelect = await showTimePicker(
                                                                                                context: context,
                                                                                                initialTime: TimeOfDay.now(),
                                                                                                builder: (BuildContext context, Widget? child) {
                                                                                                  return Theme(
                                                                                                    data: Theme.of(context).copyWith(
                                                                                                      colorScheme: const ColorScheme.light(
                                                                                                        primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: child!,
                                                                                                  );
                                                                                                },
                                                                                              );

                                                                                              if (horaSelect != null) {
                                                                                                // Combine date and time
                                                                                                fechaHoraRecolecta = DateTime(
                                                                                                  fechaSelect.year,
                                                                                                  fechaSelect.month,
                                                                                                  fechaSelect.day,
                                                                                                  horaSelect.hour,
                                                                                                  horaSelect.minute,
                                                                                                );

                                                                                                setStateDialog2(() {
                                                                                                  debugPrint("Fecha");
                                                                                                  controllerFechaRecolectar.text = DateFormat('dd/MM/yyyy').format(fechaHoraRecolecta);
                                                                                                  debugPrint(controllerFechaRecolectar.text);
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                          },
                                                                                          validator: (value) =>
                                                                                          (value == null || value.isEmpty) ? 'Información requerida' : null,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            ElevatedButton(onPressed: ()
                                                                                            {
                                                                                              Navigator
                                                                                                  .of(
                                                                                                  context)
                                                                                                  .pop();
                                                                                            },child: Text("Cancelar",style: theme.textTheme.bodyMedium?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                              color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                            ),)),
                                                                                           ElevatedButton(onPressed:()
                                                                                            {
                                                                                              if (!_formKeyRecolecta.currentState!.validate()) {
                                                                                                msgxToast("Complete todos los campos requeridos.");
                                                                                                return;
                                                                                              }
                                                                                              controllerFechaRecolectar.text = DateFormat('yyyyMMdd').format(fechaHoraRecolecta);
                                                                                              debugPrint("Fecha");
                                                                                              debugPrint(controllerFechaRecolectar.text);
                                                                                              ServiciosListadoDePaquetesRecoletar(event.pnPaquete.toString(),controllerFechaRecolectar.text,controllerObsevacionesRecolectar.text).paquetesG9();
                                                                                              Future.delayed(const Duration(milliseconds: 250), ()
                                                                                              {
                                                                                                if (propiedadElegido ==
                                                                                                    "-1") {
                                                                                                  _futurePaqueteG6 =
                                                                                                      ServiciosListadoDePaquetes(
                                                                                                          "-1",
                                                                                                          periodoElegido,
                                                                                                          TipoElegido,
                                                                                                          "1")
                                                                                                          .paquetesG6();
                                                                                                }
                                                                                                else {
                                                                                                  _futurePaqueteG6 =
                                                                                                      ServiciosListadoDePaquetes(
                                                                                                          propiedadElegido,
                                                                                                          periodoElegido,
                                                                                                          TipoElegido,
                                                                                                          propiedadCuentaID)
                                                                                                          .paquetesG6();
                                                                                                }
                                                                                                reloadPage();
                                                                                                controllerFechaRecolectar.text = "";
                                                                                                controllerObsevacionesRecolectar.text = "";
                                                                                                Navigator
                                                                                                    .of(
                                                                                                    context)
                                                                                                    .pop();
                                                                                                msgxToast(
                                                                                                    "Paquete Recolectado.");
                                                                                              }
                                                                                              );
                                                                                            },
                                                                                                child: Text("Recolectar",style: theme.textTheme.bodyMedium?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                                ),)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                              );
                                                                            })
                                                                    );
                                                                  },
                                                                );});
                                                        },
                                                        child: Text(
                                                          "Recolectar",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),):Center(),
                                                      admincheck == "1" || juntaDirect == "2"?  ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                          // set the background color
                                                        ),
                                                        onPressed: () async{
                                                          final prefs = await SharedPreferences.getInstance();
                                                          base64Images_Edicion = images;
                                                          debugPrint("Listado de imagenes");
                                                          debugPrint(images.length.toString());
                                                          debugPrint(base64Images_Edicion.length.toString());
                                                          setState(() {
                                                            controllerFechaEditada.text = DateFormat('dd/MM/yyyy').format(DateTime.parse((event.pfFecha).toString()));
                                                            propiedadElegidoEdicion = event.pvCliente;
                                                            propiedadElegidoID_Edicion = event.pvPropiedad;
                                                            PropiedadElegidaDEscripcionEdicion = event.pvPropiedadDescripcion;
                                                            descripcionControllerEdit.text = event.pvDescripcion;
                                                          });

                                                          showDialog<void>(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return StatefulBuilder(
                                                                builder: (BuildContext context, StateSetter setStateDialog2) {
                                                                  final PageController pageController = PageController();
                                                                  int currentIndex = 0;

                                                                  return AlertDialog(
                                                                    title: const Text("Editar Paquete"),
                                                                    content: Builder(
                                                                      builder: (context) {
                                                                        return SingleChildScrollView(
                                                                          scrollDirection: Axis.vertical,
                                                                          child: Form(
                                                                            key: _formKey,
                                                                            child: Column(
                                                                              children: [
                                                                                10.height,
                                                                                Text(
                                                                                  "Descripción clara del paquete:",
                                                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                    color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                  ),
                                                                                ),
                                                                                10.height,
                                                                                TextFormField(
                                                                                  controller: descripcionControllerEdit,
                                                                                  validator: (value) => (value == null || value.isEmpty)
                                                                                      ? 'Información requerida'
                                                                                      : null,
                                                                                ),
                                                                                20.height,
                                                                                10.height,
                                                                                SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.45,
                                                                                  child: Text(
                                                                                    "Fecha de recepción",
                                                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                      color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                10.height,
                                                                                TextFormField(
                                                                                  controller: controllerFechaEditada,
                                                                                  readOnly: true,
                                                                                  decoration: InputDecoration(
                                                                                    hintText: "Fecha y hora",
                                                                                    border: const OutlineInputBorder(),
                                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    // Step 1: Pick the date
                                                                                    DateTime? fechaSelect = await showDatePicker(
                                                                                      context: context,
                                                                                      initialDate: DateTime.now(),
                                                                                      firstDate: DateTime(2000),
                                                                                      lastDate: DateTime(3000),
                                                                                      builder: (BuildContext context, Widget? child) {
                                                                                        return Theme(
                                                                                          data: Theme.of(context).copyWith(
                                                                                            colorScheme: const ColorScheme.light(
                                                                                              primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                            ),
                                                                                          ),
                                                                                          child: child!,
                                                                                        );
                                                                                      },
                                                                                    );

                                                                                    if (fechaSelect != null) {
                                                                                      // Step 2: Pick the time
                                                                                      TimeOfDay? horaSelect = await showTimePicker(
                                                                                        context: context,
                                                                                        initialTime: TimeOfDay.now(),
                                                                                        builder: (BuildContext context, Widget? child) {
                                                                                          return Theme(
                                                                                            data: Theme.of(context).copyWith(
                                                                                              colorScheme: const ColorScheme.light(
                                                                                                primary: Color.fromRGBO(6, 78, 116, 1),
                                                                                              ),
                                                                                            ),
                                                                                            child: child!,
                                                                                          );
                                                                                        },
                                                                                      );

                                                                                      if (horaSelect != null) {
                                                                                        // Combine date and time
                                                                                        fechaHoraEditar = DateTime(
                                                                                          fechaSelect.year,
                                                                                          fechaSelect.month,
                                                                                          fechaSelect.day,
                                                                                          horaSelect.hour,
                                                                                          horaSelect.minute,
                                                                                        );

                                                                                        setStateDialog2(() {
                                                                                          debugPrint("Fecha");
                                                                                          controllerFechaEditada.text = DateFormat('dd/MM/yyyy').format(fechaHoraEditar);
                                                                                          debugPrint(controllerFechaEditada.text);
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  validator: (value) =>
                                                                                  (value == null || value.isEmpty) ? 'Información requerida' : null,
                                                                                ),
                                                                                10.height,
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
                                                                                10.height,
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
                                                                                    value: event.pvCliente,
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
                                                                                          "$direccion",
                                                                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                        ),
                                                                                      );
                                                                                    }),

                                                                                    // --- Manejo seguro del cambio de valor ---
                                                                                    onChanged: (value) {
                                                                                      setStateDialog2(() {
                                                                                        if (value == null) return;

                                                                                        // Buscar el índice usando la lista correcta
                                                                                        int index = clientesIdsSetB.indexOf(value);

                                                                                        if (index != -1 && index < propiedadesDireccionNombresSetB.length) {
                                                                                          propiedadElegidoEdicion = value;
                                                                                          propiedadElegidoID_Edicion = propiedadesInternasIdsSetB[index].toString();
                                                                                          PropiedadElegidaDEscripcionEdicion = propiedadesDireccionNombresSetB[index].toString();

                                                                                          debugPrint("✅ Propiedad seleccionada: $propiedadElegidoEdicion");
                                                                                          debugPrint("✅ Propiedad seleccionada ID: $propiedadElegidoID_Edicion");
                                                                                          debugPrint("📍 Dirección: $PropiedadElegidaDEscripcionEdicion");
                                                                                        } else {
                                                                                          debugPrint("⚠️ Valor no encontrado o fuera de rango: $value");
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ),

                                                                                10.height,
                                                                                Text(
                                                                                  "Imágenes del paquete",
                                                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                    color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                  ),
                                                                                ),
                                                                                10.height,

                                                                                // ======= CAROUSEL WITH REMOVE BUTTON =======
                                                                                if (base64Images_Edicion.isNotEmpty)
                                                                                  Stack(
                                                                                    alignment: Alignment.center,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: MediaQuery.of(context).size.width * 0.45,
                                                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                                                        child: PageView.builder(
                                                                                          controller: pageController,
                                                                                          onPageChanged: (index) {
                                                                                            currentIndex = index;
                                                                                          },
                                                                                          itemCount: base64Images_Edicion.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            final base64Img = base64Images_Edicion[index];
                                                                                            final imageBytes = base64Decode(base64Img);

                                                                                            return ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  Positioned.fill(
                                                                                                    child: Image.memory(
                                                                                                      imageBytes,
                                                                                                      fit: BoxFit.cover,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Positioned(
                                                                                                    top: 8,
                                                                                                    right: 8,
                                                                                                    child: Container(
                                                                                                      decoration: const BoxDecoration(
                                                                                                        color: Colors.black45,
                                                                                                        shape: BoxShape.circle,
                                                                                                      ),
                                                                                                      child: IconButton(
                                                                                                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 26),
                                                                                                        onPressed: () {
                                                                                                          setStateDialog2(() {
                                                                                                            base64Images_Edicion.removeAt(index);
                                                                                                          });
                                                                                                          msgxToast("Imagen eliminada");
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),

                                                                                      // --- Left Arrow ---
                                                                                      Positioned(
                                                                                        left: 0,
                                                                                        child: IconButton(
                                                                                          icon: const Icon(Icons.arrow_back_ios,
                                                                                              color: Colors.white, size: 30),
                                                                                          onPressed: () {
                                                                                            if (pageController.hasClients) {
                                                                                              final newIndex = (currentIndex - 1).clamp(0, base64Images_Edicion.length - 1);
                                                                                              pageController.animateToPage(
                                                                                                newIndex,
                                                                                                duration: const Duration(milliseconds: 300),
                                                                                                curve: Curves.easeInOut,
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),

                                                                                      // --- Right Arrow ---
                                                                                      Positioned(
                                                                                        right: 0,
                                                                                        child: IconButton(
                                                                                          icon: const Icon(Icons.arrow_forward_ios,
                                                                                              color: Colors.white, size: 30),
                                                                                          onPressed: () {
                                                                                            if (pageController.hasClients) {
                                                                                              final newIndex = (currentIndex + 1).clamp(0, base64Images_Edicion.length - 1);
                                                                                              pageController.animateToPage(
                                                                                                newIndex,
                                                                                                duration: const Duration(milliseconds: 300),
                                                                                                curve: Curves.easeInOut,
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                else
                                                                                  const Text(
                                                                                    "No hay imágenes cargadas.",
                                                                                    style: TextStyle(color: Colors.grey),
                                                                                  ),

                                                                                20.height,

                                                                                // ======= ADD IMAGES BUTTON =======
                                                                                ElevatedButton.icon(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                  ),
                                                                                  icon: const Icon(Icons.add_a_photo, color: Colors.white),
                                                                                  label: const Text(
                                                                                    "Agregar imágenes",
                                                                                    style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    final nuevas = await ImagePicker().pickMultiImage();
                                                                                    if (nuevas.isNotEmpty) {
                                                                                      for (var img in nuevas) {
                                                                                        final bytes = await File(img.path).readAsBytes();
                                                                                        base64Images_Edicion.add(base64Encode(bytes));
                                                                                      }
                                                                                      setStateDialog2(() {});
                                                                                      msgxToast("Imágenes agregadas");
                                                                                    }
                                                                                  },
                                                                                ),

                                                                                20.height,

                                                                                // ======= SAVE BUTTON =======
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    if (!_formKey.currentState!.validate()) {
                                                                                      msgxToast("Complete todos los campos requeridos.");
                                                                                      return;
                                                                                    }

                                                                                    debugPrint("Set paquete");
                                                                                    debugPrint("✅ Descripción: ${descripcionControllerEdit.text}");
                                                                                    debugPrint("✅ fecha: ${controllerFechaEditada.text}");
                                                                                    controllerFechaEditada.text = DateFormat('yyyyMMdd').format(fechaHoraEditar);
                                                                                    debugPrint("✅ fecha: ${controllerFechaEditada.text}");
                                                                                    debugPrint("✅Propiedad seleccionada: $propiedadElegidoEdicion");
                                                                                    debugPrint("✅Propiedad seleccionada ID: $propiedadElegidoID_Edicion");
                                                                                    debugPrint("📍Dirección: $PropiedadElegidaDEscripcionEdicion");
                                                                                    debugPrint("🖼️ Total imágenes: ${base64Images_Edicion.length}");
                                                                                    ServiciosListadoDePaquetesEdicion(controllerFechaEditada.text,propiedadElegidoID_Edicion, PropiedadElegidaDEscripcionEdicion,descripcionControllerEdit.text,event.pnPaquete.toString(),base64Images_Edicion,propiedadElegidoEdicion).paquetesG8();
                                                                                    Future.delayed(const Duration(seconds: 3), ()
                                                                                    {
                                                                                      if (propiedadElegido ==
                                                                                          "-1") {
                                                                                        _futurePaqueteG6 =
                                                                                            ServiciosListadoDePaquetes(
                                                                                                "-1",
                                                                                                periodoElegido,
                                                                                                TipoElegido,
                                                                                                "1")
                                                                                                .paquetesG6();
                                                                                      }
                                                                                      else {
                                                                                        _futurePaqueteG6 =
                                                                                            ServiciosListadoDePaquetes(
                                                                                                propiedadElegido,
                                                                                                periodoElegido,
                                                                                                TipoElegido,
                                                                                                propiedadCuentaID)
                                                                                                .paquetesG6();
                                                                                      }
                                                                                      reloadPage();
                                                                                      Navigator
                                                                                          .of(
                                                                                          context)
                                                                                          .pop();
                                                                                      msgxToast(
                                                                                          "Paquete actualizado correctamente.");
                                                                                    }
                                                                                    );
                                                                                  },
                                                                                  child: const Text(
                                                                                    "Guardar cambios",
                                                                                    style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
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

                                                        },
                                                        child: Text(
                                                          "Editar",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ):Center(),
                                                    ],
                                                  ),
                                                  15.height,
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                    );
                                  },
                                );
                              }
                          );
                        },
                      ),
                      17.height,
                    ]
                )
            )
        )
      ),
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
        fit: BoxFit.contain,

      ),
    ),
  );
}
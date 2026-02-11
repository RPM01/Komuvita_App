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
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api_Clases/class_Cuentas7.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../api_Clases/class_Visitas6.dart';
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

import '../../controller/adm_visitas_controller.dart';


class AdmVisitasBScreen extends StatefulWidget {
  const AdmVisitasBScreen({super.key});

  @override
  State<AdmVisitasBScreen> createState() => _AdmVisitasScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmVisitasScreenState extends State<AdmVisitasBScreen> {

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

  String propiedadCuentaID = "-1";
  String propiedadCuentaDescripcion = "";

  List<String> periodeDeCuenta = ["Todos","Del día","Semana En Curso","Mes En Curso","Año En Curso"];
  List<int> periodeDeCuentaID = [-1,1,2,3,4];


  List<String> estadoTicket = ["Todos","Ingresada","En Proceso","Finalizada","Aperturada","Cerrada"];
  List<int> estadoTicketID = [-1,1,2,3,4,0];

  List<String> tipoDeEntrada = ["A pie","Vehículo","Motocicleta"];
  List<int> tipoDeEntradaID = [1,2,3];

  String? entradaID;

  Future<List<Map<String, dynamic>>> ? _futureVisitasList;
  
  TextEditingController busquedaController = TextEditingController();
  TextEditingController motivoVisitaController = TextEditingController();
  TextEditingController nombreVisitaController = TextEditingController();
  TextEditingController _DPI_VisitasController = TextEditingController();
  TextEditingController codigoVisitaController = TextEditingController();
  TextEditingController telefonoVisitasController = TextEditingController();
  TextEditingController placaVehiculoController = TextEditingController();
  TextEditingController observacionesVisitasCrearController = TextEditingController();

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
  TextEditingController controllerFechaVisitaLLegada = TextEditingController();
  TextEditingController controllerHoraVisitaLLegada = TextEditingController();
  TextEditingController controllerObsevacionesRecibir = TextEditingController();
  TextEditingController descripcionControllerEdit = TextEditingController();

  String fechaIngresoVisita = "";
  String horaIngresoVisita = "";

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

  TextEditingController codigoController = TextEditingController();
  TextEditingController observacionesVisitasController = TextEditingController();

  DateTime? fechaSelect = DateTime.now();

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
      periodoCuentaID = periodeDeCuentaID[0].toString();
    }
    );
  }

  getUserInfo() async
  {

    //_futureTickets = ListaFiltradaTickets(periodoElegido,propiedadElegido,TipoElegido,EstadoTicketElegido,busquedaController.text).GestionTickets5B_2();

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _futureVisitasList = visitasListaB("-1","-1","2","-1",tipoOpcion).visitas5();

      //_futureVisitasList = visitasListaB("-1",).visitas5();
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
  reloadPage()
  {
    setState(() {
      if(periodoElegido == "-1")
        {
          setState(() {
            periodoElegido == "";
          });
        }
      if(codigoController.text == "")
        {
          _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,"-1",tipoOpcion).visitas5();
        }
      else
      {
        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();
      }



      /*if(codigoController.text == "")
      {
        _futureVisitasList = visitasListaB("-1","-1","").visitas5();
        //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
      }
      else
      {
        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text).visitas5();

        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text).visitas5();
        //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
      }*/
    });
  }

// Helper function for label:value style
  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.045,
                color: const Color.fromRGBO(6, 78, 116, 1),
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    required BuildContext context,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color.fromRGBO(6, 78, 116, 1),
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onTap: () async {
                fechaSelect = await showDatePicker(
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
                setState(() {
                  controller.text = DateFormat('dd/MM/yyyy').format(fechaSelect!);
                });
              }
            },
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Información requerida' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    required BuildContext context,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color.fromRGBO(6, 78, 116, 1),
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: label,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onTap: () async {
              TimeOfDay? timePicked = await showTimePicker(
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

              if (timePicked != null) {
                final now = DateTime.now();
                final parsedTime = DateTime(now.year, now.month, now.day, timePicked.hour, timePicked.minute);
                final formatted = DateFormat('HH:mm').format(parsedTime);
                setState(() {
                  controller.text = formatted;
                });
              }
            },
            validator: (value) =>
            (value == null || value.isEmpty) ? 'Información requerida' : null,
          ),
        ],
      ),
    );
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
                              //17.height,
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
                                                  fontSize: MediaQuery.of(context).size.width*0.050,
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
                                                      if(periodoElegido == "-1")
                                                        {
                                                          setState(() {
                                                            periodoElegido = "";
                                                          });
                                                        }
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
                                                  fontSize: MediaQuery.of(context).size.width*0.050,
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
                                                        propiedadesDireccionNombresSet[index],
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
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Text("Código",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width*0.45,
                                          child: TextFormField(
                                              controller: codigoController,
                                              onChanged: (value) {
                                                setState(() {
                                                  codigoController.text = value;
                                                });
                                              }
                                          )
                                      ),
                                      17.height,
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
                                            debugPrint("filtrandoPropiedades");
                                            _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();

                                               if(codigoController.text == "")
                                              {
                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,"-1",tipoOpcion).visitas5();
                                              }
                                              else
                                                {
                                                  _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();
                                                }

                                              /*if(propiedadElegido == "-1")
                                              {
                                                _futureVisitasList = visitasListaB("-1","-1","").visitas5();
                                                //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                              }
                                              else
                                              {
                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text).visitas5();

                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text).visitas5();
                                                //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                              }*/
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
                                      ),
                                     17.height,
                                     /* Row(
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
                                                  if(codigoController.text == "")
                                                  {
                                                    codigoController.text = "-1";
                                                    //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                  }
                                                  else
                                                  {
                                                    //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
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
                                      ),*/

                                      /*SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Text("Código",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width*0.45,
                                          child: TextFormField(
                                              controller: codigoController,
                                              onChanged: (value) {
                                                setState(() {
                                                  codigoController.text = value;
                                                });
                                              }
                                          )
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Column(
                                          children: [
                                            Text("Recibida",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(6,78,116,1),
                                              fontSize: MediaQuery.of(context).size.width*0.050,
                                            )),
                                            ListTile(
                                              title: Text("Sí"),
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
                                              title: Text("No"),
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
                                      ),*/
                                      17.height,
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Column(
                                          children: [
                                            Text("Recibida",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(6,78,116,1),
                                              fontSize: MediaQuery.of(context).size.width*0.050,
                                            )),
                                            ListTile(
                                              title: Text("Sí"),
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
                                              title: Text("No"),
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
                                            setState(() {
                                              debugPrint("Listas de Propiedad");
                                              debugPrint(clientesIdsSetB.toString());
                                              debugPrint(propiedadesDireccionNombresSetB.toString());
                                              debugPrint(propiedadesInternasIdsSetB.toString());

                                              propiedadElegidoB =clientesIdsSetB.first.toString();
                                              PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[0];
                                              propiedadElegidoID_B = propiedadesInternasIdsSetB[0].toString();

                                              //PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[0];
                                              controllerFechaVisitaLLegada.text = "";
                                              controllerHoraVisitaLLegada.text = "";
                                              motivoVisitaController.text = "";
                                              nombreVisitaController.text = "";
                                              _DPI_VisitasController.text = "";
                                              telefonoVisitasController.text = "";
                                              //entradaID = "";
                                              placaVehiculoController.text = "";
                                              observacionesVisitasCrearController.text = "";
                                            });
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setStateDialog2) {
                                                    return AlertDialog(
                                                      title: const Text("Registrar nueva visita"),
                                                      content: Builder(
                                                          builder: (context) {
                                                            return SingleChildScrollView(
                                                              scrollDirection: Axis.vertical,
                                                              child: Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  children: [

                                                                    10.height,
                                                                    Column(
                                                                      children: [
                                                                        Wrap(
                                                                          spacing: 30,
                                                                          runSpacing: 16,
                                                                          alignment: WrapAlignment.spaceBetween,
                                                                          children: [
                                                                            _buildDateField(
                                                                              label: "Fecha de llegada",
                                                                              controller: controllerFechaVisitaLLegada,
                                                                              theme: theme,
                                                                              context: context,
                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                            ),
                                                                            _buildTimeField(
                                                                              label: "Hora de llegada",
                                                                              controller: controllerHoraVisitaLLegada,
                                                                              theme: theme,
                                                                              context: context,
                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
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
                                                                          if (value == null || value.isEmpty || value == "-1" || value == "Todos") {
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
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Motivo de visita",
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
                                                                        controller: motivoVisitaController,
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                        onChanged: (value) {
                                                                          motivoVisitaController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          motivoVisitaController.text = value;
                                                                        },
                                                                      ),
                                                                    ),

                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Nombre de la visita",
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
                                                                        controller: nombreVisitaController,
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                        onChanged: (value) {
                                                                          nombreVisitaController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          nombreVisitaController.text = value;
                                                                        },
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "No. de documento de Identificación",
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
                                                                        controller: _DPI_VisitasController,
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                        onChanged: (value) {
                                                                          _DPI_VisitasController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          _DPI_VisitasController.text = value;
                                                                        },
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Teléfono",
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
                                                                        controller: telefonoVisitasController,
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                        onChanged: (value) {
                                                                          telefonoVisitasController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          telefonoVisitasController.text = value;
                                                                        },
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Tipo de entrada",
                                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                          color: const Color.fromRGBO(6, 78, 116, 1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    /*validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Mensaje si está vacío
                                                                          }
                                                                          return null; // Si es válido
                                                                        },*/
                                                                    DropdownButtonFormField<String>(
                                                                      isExpanded: true,
                                                                      value: entradaID,
                                                                      hint: const Text("Seleccionar"),
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
                                                                      items: List.generate(tipoDeEntradaID.length, (index) {
                                                                        return DropdownMenuItem<String>(
                                                                          value: tipoDeEntradaID[index].toString(),
                                                                          child: Text(
                                                                            " ${tipoDeEntrada[index]}",
                                                                            style: const TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                                      onChanged: (value) async{
                                                                        final prefs = await SharedPreferences.getInstance();
                                                                        setState(() {
                                                                          entradaID = value!;
                                                                          debugPrint(entradaID);
                                                                        });
                                                                      },
                                                                    ),
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Placa de vehículo",
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
                                                                        validator: (String? value) {

                                                                          if (value == null || value.isEmpty && entradaID != "1") {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },

                                                                        controller: placaVehiculoController,

                                                                        onChanged: (value) {
                                                                          placaVehiculoController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          placaVehiculoController.text = value;
                                                                        },
                                                                      ),
                                                                    ),
                                                                    10.height,
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width * 0.45,
                                                                      child: Text(
                                                                        "Observaciones",
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
                                                                        controller: observacionesVisitasCrearController,

                                                                        onChanged: (value) {
                                                                          observacionesVisitasCrearController.text = value;
                                                                        },
                                                                        onFieldSubmitted: (value) {
                                                                          observacionesVisitasCrearController.text = value;
                                                                        },
                                                                      ),
                                                                    ),
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
                                                                          setStateDialog2(() {
                                                                            controllerFechaVisitaLLegada.text = DateFormat('yyyyMMdd').format(fechaSelect!);
                                                                          });

                                                                          debugPrint("Cliente ID");
                                                                          debugPrint(propiedadElegidoB);
                                                                          debugPrint("Cliente Nombre");
                                                                          debugPrint(PropiedadElegidaDEscripcion);
                                                                          debugPrint("Propiedad ID");
                                                                          debugPrint(propiedadElegidoID_B);
                                                                          debugPrint("Propiedad Nombre");
                                                                          debugPrint(PropiedadElegidaDEscripcion);
                                                                          debugPrint("Fecha");
                                                                          debugPrint(controllerFechaVisitaLLegada.text);
                                                                          debugPrint("Hora");
                                                                          debugPrint(controllerHoraVisitaLLegada.text);
                                                                          debugPrint("Motivo visita");
                                                                          debugPrint(motivoVisitaController.text);
                                                                          debugPrint("Nombre Visita");
                                                                          debugPrint(nombreVisitaController.text);
                                                                          debugPrint("DPI Visita");
                                                                          debugPrint(_DPI_VisitasController.text);
                                                                          debugPrint("Teléfono visita");
                                                                          debugPrint(telefonoVisitasController.text);
                                                                          debugPrint("Entrada Tipo");
                                                                          debugPrint(entradaID);
                                                                          debugPrint(tipoDeEntrada.toString());
                                                                          debugPrint("Placa de vehiculo");
                                                                          debugPrint(placaVehiculoController.text);
                                                                          debugPrint("Observaciones");
                                                                          debugPrint(observacionesVisitasCrearController.text);
                                                                          crearVisitas(propiedadElegidoID_B,PropiedadElegidaDEscripcion,
                                                                              propiedadElegidoB,PropiedadElegidaDEscripcion,controllerFechaVisitaLLegada.text,
                                                                            controllerHoraVisitaLLegada.text,motivoVisitaController.text,nombreVisitaController.text,
                                                                              _DPI_VisitasController.text,telefonoVisitasController.text,entradaID!,placaVehiculoController.text,observacionesVisitasCrearController.text).visitas7();

                                                                          Future.delayed(const Duration(milliseconds: 250), ()
                                                                          {

                                                                            setState(() {
                                                                              if(codigoController.text == "")
                                                                              {
                                                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,"-1",tipoOpcion).visitas5();
                                                                                //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                              }
                                                                              else
                                                                              {
                                                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();

                                                                                _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();
                                                                                //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                              }
                                                                            });
                                                                          }
                                                                          );
                                                                          msgxToast("Visita creada");
                                                                          Navigator.of(context).pop();

                                                                        },
                                                                        child: Text(
                                                                          "Registrar nuevo visitante",
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontSize:
                                                                            MediaQuery.of(context).size.width * 0.045,
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
                                            "Registrar nueva visita",
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
                      FutureBuilder(
                        future:_futureVisitasList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return  Center(
                                child: Title(color: Color.fromRGBO(6,78,116,1),
                                  child: Text("No hay visitas registrados",style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                    color: Color.fromRGBO(6,78,116,1),
                                  ),
                                  ),
                                )
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                                child: Title(color: Color.fromRGBO(6,78,116,1),
                                  child: Text("No hay visitas registrados",style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                    color: Color.fromRGBO(6,78,116,1),
                                  ),
                                  ),
                                )
                            );
                          }
                          final events = snapshot.data!;
                          return LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];

                                    return  Card(
                                      color: Colors.grey[300],
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: constraints.maxWidth*0.8,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              event.isNotEmpty
                                                  ?GestureDetector(
                                                    onTap: () => showImageDialogB(context, event["pv_imagen_qrb64"].toString()),
                                                      child: SizedBox(
                                                          width: constraints.maxWidth*0.3,
                                                          height: constraints.maxWidth*0.7,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.memory(
                                                              base64Decode(event["pv_imagen_qrb64"].toString()),
                                                              fit: BoxFit.fill,
                                                              width: double.infinity,
                                                            ),
                                                          )),
                                                    )
                                                        : const Center(child: Text("No Image")),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.33,
                                                child: ListTile(
                                                  title: Text("FECHA Y HORA:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(

                                                    DateFormat('dd/MM/yyyy').format(DateTime.parse(event["pf_fecha"].toString()),) +" ${event["pf_hora_llegada"]}",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("PROPIEDAD:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_propiedad_nombre"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("MOTIVO DE VISITA:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth* 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_motivo"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("NOMBRE DE VISITA:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_nombre"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth* 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("IDENTIFICACION DE VISITA:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_no_identificacion"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("TELÉFONO DE VISITA:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize:constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_telefono"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("TIPO DE ENTRADA :",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_entrada_tipo_descripcion"].toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("PLACA DE VEHÍCULO:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_visita_vehiculo_placa"]?.toString() ?? "",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("OBSERVACIONES:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: Text(event["pv_observaciones"]?.toString() ?? "",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(
                                                width: constraints.maxWidth * 0.33,
                                                child: ListTile(
                                                  title: Text("STATUS:",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(167,167,132,1),
                                                        fontSize: constraints.maxWidth * 0.038
                                                    ),),
                                                  subtitle: event["pv_recibida"] == 0 ? Text("Pendiente",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),):Text("Recibida",
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.grey[600],
                                                        fontSize: constraints.maxWidth * 0.035
                                                    ),),
                                                ),
                                              ),
                                              Container(

                                                child: event["pv_recibida"] == 0 ? ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      const Color.fromRGBO(6, 78, 116, 1),
                                                    ),
                                                    onPressed: ()
                                                  {
                                                    setState(() {
                                                      debugPrint("ListadoPropiedades");
                                                      debugPrint(clientesIdsSetB.toString());
                                                      debugPrint(propiedadesDireccionNombresSetB.toString());
                                                      debugPrint(propiedadesInternasIdsSetB.toString());
                                                      propiedadElegidoB =clientesIdsSetB.first.toString();
                                                      PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[0];
                                                      propiedadElegidoID_B = propiedadesInternasIdsSetB[0].toString();

                                                      //PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[0];
                                                      controllerFechaVisitaLLegada.text = event["pf_fecha"].toString();
                                                      controllerHoraVisitaLLegada.text = event["pf_hora_llegada"];
                                                      motivoVisitaController.text = event["pv_visita_motivo"].toString();
                                                      nombreVisitaController.text =event["pv_visita_nombre"];
                                                      _DPI_VisitasController.text = event["pv_visita_no_identificacion"];
                                                      telefonoVisitasController.text = event["pv_visita_telefono"];
                                                      entradaID = event["pn_visita_entrada_tipo"].toString();
                                                      placaVehiculoController.text = event["pv_visita_vehiculo_placa"].toString();
                                                      observacionesVisitasCrearController.text = event["pv_observaciones"].toString();
                                                      codigoVisitaController.text =  event["pn_visita"].toString();

                                                      if(observacionesVisitasCrearController.text == "null" || observacionesVisitasCrearController.text == "")
                                                      {
                                                        observacionesVisitasCrearController.text = "";
                                                      }

                                                      if(placaVehiculoController.text == "null"||placaVehiculoController.text == "")
                                                      {
                                                        placaVehiculoController.text = "";
                                                      }
                                                      //propiedadElegidoB = "";
                                                      propiedadElegidoID_B = event["pv_propiedad"].toString();
                                                      PropiedadElegidaDEscripcion = event["pv_propiedad_nombre"].toString();
                                                      propiedadCuentaID = event["pv_propiedad"].toString();
                                                    }
                                                    );
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setStateDialog2) {
                                                            return AlertDialog(
                                                              title: const Text("Cambiar informacíon de visita"),
                                                              content: Builder(
                                                                  builder: (context) {
                                                                    return SingleChildScrollView(
                                                                      scrollDirection: Axis.vertical,
                                                                      child: Form(
                                                                        key: _formKey,
                                                                        child: Column(
                                                                          children: [
                                                                            10.height,
                                                                            Column(
                                                                              children: [
                                                                                Wrap(
                                                                                  spacing: 30,
                                                                                  runSpacing: 16,
                                                                                  alignment: WrapAlignment.spaceBetween,
                                                                                  children: [
                                                                                    _buildDateField(
                                                                                      label: "Fecha de llegada",
                                                                                      controller: controllerFechaVisitaLLegada,
                                                                                      theme: theme,
                                                                                      context: context,
                                                                                      width: MediaQuery.of(context).size.width * 0.50,
                                                                                    ),
                                                                                    _buildTimeField(
                                                                                      label: "Hora de llegada",
                                                                                      controller: controllerHoraVisitaLLegada,
                                                                                      theme: theme,
                                                                                      context: context,
                                                                                      width: MediaQuery.of(context).size.width * 0.50,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
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
                                                                                  if (value == null || value.isEmpty || value == "-1" || value == "Todos") {
                                                                                    return 'Información requerida'; // Mensaje si está vacío
                                                                                  }
                                                                                  setState(() {
                                                                                    if (value == null) return;

                                                                                    // Buscar el índice usando la lista correcta
                                                                                    int index = propiedadesDireccionNombresSet.indexOf(value);
                                                                                    debugPrint("indice");
                                                                                    debugPrint(index.toString());
                                                                                    debugPrint(clientesIdsSetB[index].toString());
                                                                                    debugPrint(propiedadesDireccionNombresSetB[index].toString());
                                                                                    debugPrint(propiedadesInternasIdsSetB[index].toString());

                                                                                    if (index != -1 && index < propiedadesInternasIdsSetB.length) {
                                                                                      setStateDialog2(() {
                                                                                        if(clientesIdsSetB[index].toString() == "-1")
                                                                                        {
                                                                                          PropiedadElegidaDEscripcion = "Todos";
                                                                                          propiedadElegidoB = clientesIdsSetB[index].toString();
                                                                                          propiedadElegidoID_B =  propiedadesInternasIdsSetB[index].toString();
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                          propiedadElegidoB = clientesIdsSetB[index].toString();
                                                                                          propiedadElegidoID_B =  propiedadesInternasIdsSetB[index].toString();
                                                                                          PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[index].toString();
                                                                                        }
                                                                                      });
                                                                                      debugPrint("✅ Propiedad seleccionada: $propiedadElegidoB");
                                                                                      debugPrint("✅ Propiedad seleccionada ID: $propiedadElegidoID_B");
                                                                                      debugPrint("📍 Dirección: $PropiedadElegidaDEscripcion");
                                                                                    } else {
                                                                                      debugPrint("⚠️ Valor no encontrado o fuera de rango: $value");
                                                                                    }
                                                                                  });
                                                                                  return null;
                                                                                },
                                                                                isExpanded: true,

                                                                                initialValue:  PropiedadElegidaDEscripcion,
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

                                                                                items: List.generate(propiedadesDireccionNombresSet.length, (index) {
                                                                                  // Evita errores si las listas no tienen la misma longitud
                                                                                  String nombre = (index < propiedadesInternaNombresSetB.length)
                                                                                      ? propiedadesInternaNombresSetB[index]
                                                                                      : "Desconocido";

                                                                                  String direccion = (index < propiedadesDireccionNombresSetB.length)
                                                                                      ? propiedadesDireccionNombresSetB[index]
                                                                                      : "Sin dirección";

                                                                                  return DropdownMenuItem<String>(
                                                                                    value: propiedadesDireccionNombresSet[index].toString(),
                                                                                    child: Text(
                                                                                      "$direccion ",
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
                                                                                    int index = propiedadesDireccionNombresSet.indexOf(value);
                                                                                    debugPrint("indice");
                                                                                    debugPrint("SetInfo");
                                                                                    debugPrint(value);
                                                                                    debugPrint(index.toString());
                                                                                    debugPrint(clientesIdsSetB[index].toString());
                                                                                    debugPrint(propiedadesDireccionNombresSetB[index].toString());
                                                                                    debugPrint(propiedadesInternasIdsSetB[index].toString());

                                                                                    if (index != -1 && index < propiedadesInternasIdsSetB.length) {
                                                                                      setStateDialog2(() {
                                                                                        if(clientesIdsSetB[index].toString() == "-1")
                                                                                          {
                                                                                            PropiedadElegidaDEscripcion = "Todos";
                                                                                            propiedadElegidoB = clientesIdsSetB[index].toString();
                                                                                            propiedadElegidoID_B =  propiedadesInternasIdsSetB[index].toString();
                                                                                          }
                                                                                        else
                                                                                          {
                                                                                            propiedadElegidoB = clientesIdsSetB[index].toString();
                                                                                            propiedadElegidoID_B =  propiedadesInternasIdsSetB[index].toString();
                                                                                            PropiedadElegidaDEscripcion = propiedadesDireccionNombresSetB[index].toString();
                                                                                          }
                                                                                      });
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
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Motivo de visita",
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
                                                                                controller: motivoVisitaController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return 'Información requerida'; // Error message if empty
                                                                                  }
                                                                                  return null; // Return null if the input is valid
                                                                                },
                                                                                onChanged: (value) {
                                                                                  motivoVisitaController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  motivoVisitaController.text = value;
                                                                                },
                                                                              ),
                                                                            ),

                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Nombre de la visita",
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
                                                                                controller: nombreVisitaController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return 'Información requerida'; // Error message if empty
                                                                                  }
                                                                                  return null; // Return null if the input is valid
                                                                                },
                                                                                onChanged: (value) {
                                                                                  nombreVisitaController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  nombreVisitaController.text = value;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "No. de documento de identificacion",
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
                                                                                controller: _DPI_VisitasController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return 'Información requerida'; // Error message if empty
                                                                                  }
                                                                                  return null; // Return null if the input is valid
                                                                                },
                                                                                onChanged: (value) {
                                                                                  _DPI_VisitasController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  _DPI_VisitasController.text = value;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Teléfono",
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
                                                                                controller: telefonoVisitasController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return 'Información requerida'; // Error message if empty
                                                                                  }
                                                                                  return null; // Return null if the input is valid
                                                                                },
                                                                                onChanged: (value) {
                                                                                  telefonoVisitasController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  telefonoVisitasController.text = value;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Tipo de entrada",
                                                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045,
                                                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            10.height,
                                                                            /*validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Mensaje si está vacío
                                                                          }
                                                                          return null; // Si es válido
                                                                        },*/
                                                                            DropdownButtonFormField<String>(
                                                                              isExpanded: true,
                                                                              value: entradaID,
                                                                              hint: const Text("Seleccionar"),
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
                                                                              items: List.generate(tipoDeEntradaID.length, (index) {
                                                                                return DropdownMenuItem<String>(
                                                                                  value: tipoDeEntradaID[index].toString(),
                                                                                  child: Text(
                                                                                    " ${tipoDeEntrada[index]}",
                                                                                    style: const TextStyle(
                                                                                      fontSize: 20,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }),
                                                                              onChanged: (value) async{
                                                                                final prefs = await SharedPreferences.getInstance();
                                                                                setState(() {
                                                                                  entradaID = value!;
                                                                                  debugPrint("entradaID");
                                                                                  debugPrint(entradaID);
                                                                                });
                                                                              },
                                                                            ),
                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Placa de vehículo",
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
                                                                                validator: (String? value) {
                                                                                  if (value == null || value.isEmpty && entradaID != "1"|| value == "" && entradaID != "1") {
                                                                                    return 'Información requerida'; // Error message if empty
                                                                                  }
                                                                                  return null; // Return null if the input is valid
                                                                                },
                                                                                controller: placaVehiculoController,

                                                                                onChanged: (value) {
                                                                                  placaVehiculoController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  placaVehiculoController.text = value;
                                                                                },
                                                                              ),
                                                                            ),
                                                                            10.height,
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.45,
                                                                              child: Text(
                                                                                "Observaciones",
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
                                                                                controller: observacionesVisitasCrearController,

                                                                                onChanged: (value) {
                                                                                  observacionesVisitasCrearController.text = value;
                                                                                },
                                                                                onFieldSubmitted: (value) {
                                                                                  observacionesVisitasCrearController.text = value;
                                                                                },
                                                                              ),
                                                                            ),
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
                                                                                  controllerFechaVisitaLLegada.text = DateFormat('yyyyMMdd').format(fechaSelect!);
                                                                                  debugPrint("Codigo de visita");
                                                                                  debugPrint(codigoVisitaController.text);
                                                                                  debugPrint("Cliente ID");
                                                                                  debugPrint(propiedadElegidoB);
                                                                                  debugPrint("Cliente Nombre");
                                                                                  debugPrint(PropiedadElegidaDEscripcion);
                                                                                  debugPrint("Propiedad ID");
                                                                                  debugPrint(propiedadElegidoID_B);
                                                                                  debugPrint("Propiedad Nombre");
                                                                                  debugPrint(PropiedadElegidaDEscripcion);
                                                                                  debugPrint("Fecha");
                                                                                  debugPrint(controllerFechaVisitaLLegada.text);
                                                                                  debugPrint("Hora");
                                                                                  debugPrint(controllerHoraVisitaLLegada.text);
                                                                                  debugPrint("Motivo visita");
                                                                                  debugPrint(motivoVisitaController.text);
                                                                                  debugPrint("Nombre Visita");
                                                                                  debugPrint(nombreVisitaController.text);
                                                                                  debugPrint("DPI Visita");
                                                                                  debugPrint(_DPI_VisitasController.text);
                                                                                  debugPrint("Teléfono visita");
                                                                                  debugPrint(telefonoVisitasController.text);
                                                                                  debugPrint("Entrada Tipo");
                                                                                  debugPrint(entradaID);
                                                                                  debugPrint(tipoDeEntrada.toString());
                                                                                  debugPrint("Placa de vehiculo");
                                                                                  debugPrint(placaVehiculoController.text);
                                                                                  debugPrint("Observaciones");
                                                                                  debugPrint(observacionesVisitasCrearController.text);
                                                                                  EditarVisita(propiedadElegidoID_B,PropiedadElegidaDEscripcion,
                                                                                      propiedadElegidoB,PropiedadElegidaDEscripcion,controllerFechaVisitaLLegada.text,
                                                                                      controllerHoraVisitaLLegada.text,motivoVisitaController.text,nombreVisitaController.text,
                                                                                      _DPI_VisitasController.text,telefonoVisitasController.text,entradaID!,
                                                                                      placaVehiculoController.text,observacionesVisitasCrearController.text,codigoVisitaController.text).visitas9();

                                                                                  Future.delayed(const Duration(milliseconds: 400), ()
                                                                                  {
                                                                                    setState(() {
                                                                                      if(codigoController.text == "")
                                                                                      {
                                                                                        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,"-1",tipoOpcion).visitas5();
                                                                                        //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                                      }
                                                                                      else
                                                                                      {
                                                                                        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();

                                                                                        _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();
                                                                                        //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                  );
                                                                                  Navigator.of(context).pop();

                                                                                },
                                                                                child: Text(
                                                                                  "Guardar cambios visitante",
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.white,
                                                                                    fontSize:
                                                                                    MediaQuery.of(context).size.width * 0.045,
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
                                                  },
                                                   child: Text("Editar",style: theme.textTheme.bodyMedium?.copyWith(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: MediaQuery.of(context).size.width*0.05,
                                                     color: Colors.white,
                                                   ),)):Center()
                                              ),
                                              //if (!isReceived)
                                              event["pv_recibida"] == 0 ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    admincheck == "1" ?  Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                              const Color.fromRGBO(6, 78, 116, 1),
                                                            ),

                                                            onPressed: () {
                                                              debugPrint("Recibir ${event["pv_codigo"]} con observación: ${event["pv_recibida_observaciones"]}");
                                                              observacionesVisitasController.text = "";
                                                              controllerFechaVisitaLLegada.text = "";
                                                              controllerHoraVisitaLLegada.text = "";
                                                              showDialog<void>(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return StatefulBuilder(
                                                                      builder: (BuildContext context, StateSetter setStateDialog2) {
                                                                        final PageController pageController = PageController();
                                                                        int currentIndex = 0;

                                                                        return AlertDialog(
                                                                            title: Text("Información para recibir la visita"),
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
                                                                                                controller: observacionesVisitasController,
                                                                                                decoration: InputDecoration(
                                                                                                  hintText: "Observaciones de visita",
                                                                                                  border: const OutlineInputBorder(),
                                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                                                                ),
                                                                                                minLines: 2,
                                                                                                maxLines: 3,
                                                                                                onChanged: (value)
                                                                                                {
                                                                                                  setStateDialog2(() {
                                                                                                    controllerObsevacionesRecibir.text = value;
                                                                                                  });
                                                                                                }
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                Wrap(
                                                                                                  spacing: 16,
                                                                                                  runSpacing: 16,
                                                                                                  alignment: WrapAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    _buildDateField(
                                                                                                      label: "Fecha de llegada",
                                                                                                      controller: controllerFechaVisitaLLegada,
                                                                                                      theme: theme,
                                                                                                      context: context,
                                                                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                                                                    ),
                                                                                                    _buildTimeField(
                                                                                                      label: "Hora de llegada",
                                                                                                      controller: controllerHoraVisitaLLegada,
                                                                                                      theme: theme,
                                                                                                      context: context,
                                                                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
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
                                                                                                ElevatedButton(
                                                                                                    onPressed:()
                                                                                                    {
                                                                                                      if (!_formKeyRecolecta.currentState!.validate()) {
                                                                                                        msgxToast("Complete todos los campos requeridos.");
                                                                                                        return;
                                                                                                      }
                                                                                                      controllerFechaVisitaLLegada.text = DateFormat('yyyyMMdd').format(fechaHoraRecolecta);
                                                                                                      debugPrint("Fecha");
                                                                                                      debugPrint(event["pv_codigo"].toString());
                                                                                                      debugPrint(controllerFechaVisitaLLegada.text);
                                                                                                      debugPrint(observacionesVisitasController.text);
                                                                                                      debugPrint(controllerHoraVisitaLLegada.text);

                                                                                                      VisitasRecibir(event["pn_visita"].toString(),controllerFechaVisitaLLegada.text,controllerHoraVisitaLLegada.text,observacionesVisitasController.text).VisitasM8();

                                                                                                      Future.delayed(const Duration(milliseconds: 250), ()
                                                                                                      {
                                                                                                        setState(() {
                                                                                                          if(codigoController.text == "")
                                                                                                          {
                                                                                                            _futureVisitasList = visitasListaB("-1","-1",periodoElegido,"-1",tipoOpcion).visitas5();
                                                                                                            //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                                                          }
                                                                                                          else
                                                                                                          {
                                                                                                            _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();

                                                                                                            _futureVisitasList = visitasListaB(propiedadCuentaID,propiedadElegido,periodoElegido,codigoController.text,tipoOpcion).visitas5();
                                                                                                            //_futureVisitaM6 = visitasLista(propiedadCuentaID,periodoCuentaID,tipoOpcion,codigoController.text).listadoVisitasM6();
                                                                                                          }
                                                                                                        });
                                                                                                        reloadPage();
                                                                                                        controllerFechaVisitaLLegada.text = "";
                                                                                                        controllerObsevacionesRecibir.text = "";
                                                                                                        Navigator
                                                                                                            .of(
                                                                                                            context)
                                                                                                            .pop();
                                                                                                        msgxToast(
                                                                                                            "Visita marcada de recibida");
                                                                                                      }
                                                                                                      );
                                                                                                    },
                                                                                                    child: Text("Recibir Visita",style: theme.textTheme.bodyMedium?.copyWith(
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
                                                                    );
                                                                  }
                                                              );
                                                            },
                                                            child:  Text("Recibir",style: theme.textTheme.bodyMedium?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: MediaQuery.of(context).size.width*0.05,
                                                              color: Colors.white,
                                                            ),),
                                                          ),
                                                        ),

                                                      ],
                                                    ):Center(),
                                                  ],
                                                ):Center(),
                                            ],
                                          ),
                                        ],
                                      ),
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

void showImageDialogB(BuildContext context, String iamgenSelectB) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Show the image
            Image.memory(base64Decode(iamgenSelectB)),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                try {
                  // Decode Base64
                  Uint8List bytes = base64Decode(iamgenSelectB);

                  final result = await ImageGallerySaverPlus.saveImage(bytes.buffer.asUint8List());
                  //debugPrint("Desgargado en galeria");
                  msgxToast("Desgargado en galeria");
                  debugPrint(result.toString());
                }
                catch (e) {

                  debugPrint(" Error saving image: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al guardar la imagen")),
                  );
                }
              },
              child: const Text(
                "Descargar",
                style: TextStyle(
                  color: Color.fromRGBO(6, 78, 116, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
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
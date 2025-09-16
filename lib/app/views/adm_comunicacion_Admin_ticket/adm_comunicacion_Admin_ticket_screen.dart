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

  String periodoElegido = "-1";
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: menuController.themeController.isDarkMode
                      ? admDarkPrimary
                      : admLightGrey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              logoLogin,
                              height: MediaQuery.of(context).size.height*0.20,
                              width: MediaQuery.of(context).size.width*0.20,
                            ),
                            const SizedBox(width: 10),
                            /*
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width*0.09,
                                  backgroundColor: Color.fromRGBO(220,227,234,1),
                              ),
                              const SizedBox(width: 10),
                               */
                            Text(
                              userName, // Change to dynamic user name if available
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: menuController.themeController.isDarkMode
                                    ? admWhiteColor
                                    : admTextColor,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: menuController.helpAndSupport.length,
                      itemBuilder: (context, index) {
                        final isLast = index == menuController.helpAndSupport.length - 1;

                        IconData iconData;
                        switch (index) {
                          case 0: iconData = Icons.house; break;
                          case 1: iconData = FontAwesomeIcons.clipboardList; break;
                          case 2: iconData = FontAwesomeIcons.newspaper; break;
                          case 3: iconData = FontAwesomeIcons.doorOpen; break;
                          case 4: iconData = FontAwesomeIcons.boxesStacked; break;
                          case 5: iconData = FontAwesomeIcons.calendarCheck; break;
                          case 6: iconData = FontAwesomeIcons.phoneFlip; break;
                          case 7: iconData = Icons.lock_reset; break;
                          default: iconData = Icons.logout;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if(isLast)
                                {
                                  _showLogOutBottomSheet(context);
                                }
                                Get.to(menuController.screens[index]);
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  iconData,
                                  size: 22,
                                  color: isLast ? Colors.red :
                                  (menuController.themeController.isDarkMode
                                      ? admWhiteColor
                                      : admDarkPrimary),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    menuController.helpAndSupport[index],
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isLast ? Colors.red :
                                      (menuController.themeController.isDarkMode
                                          ? admWhiteColor
                                          : admDarkPrimary),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: isLast ? Colors.red :
                                  (menuController.themeController.isDarkMode
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
                )
              ],
            ),
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
                                                    value: periodeDeCuentaID[0].toString(),
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
                                                                          isExpanded: true,
                                                                          value: gestionIDs[0].toString(),
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
                                                                          items: List.generate(gestionDescripcion.length, (index) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: gestionIDs[index].toString(),
                                                                              child: Text(
                                                                                gestionDescripcion[index],
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
                                                                              gestionIDs.indexOf(int.parse(value!));
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
                                                                          isExpanded: true,
                                                                          value: clientesIdsSet[0].toString(),
                                                                          hint: const Text("Seleccione una Propiedad"),
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
                                                                          items: List.generate(clientesIdsSet.length, (index) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: clientesIdsSet[index],
                                                                              child: Text(
                                                                                "${propiedadesInternaNombresSet[index]} ${propiedadesDireccionNombresSet[index]}",
                                                                                style: const TextStyle(
                                                                                  fontSize: 20,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              int index = propiedadesInternasIdsSet.indexOf(value!);
                                                                              propiedadElegidoB = value;
                                                                              PropiedadElegidaDEscripcion = propiedadesDireccionNombresSet[index].toString();
                                                                              debugPrint(PropiedadElegidaDEscripcion);
                                                                              debugPrint(propiedadElegidoB);
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
                                                                            final prefs = await SharedPreferences.getInstance();
                                                                            String? cliente = "";
                                                                            cliente = prefs.getString("cliente");
                                                                            debugPrint("Seting tickets");
                                                                            debugPrint(propiedadElegidoB);
                                                                            debugPrint(TipoElegidoB);
                                                                            debugPrint(descripcionController.text);
                                                                            debugPrint(prefs.getString("cliente"));
                                                                            debugPrint(base64Images.toString());
                                                                            debugPrint(cliente);
                                                                            debugPrint("Total imágenes convertidas: ${base64Images.length}");
                                                                            ServicioTickets(propiedadElegidoB,PropiedadElegidaDEscripcion,TipoElegidoB,descripcionController.text,prefs.getString("cliente")!,base64Images);
                                                                            await ServicioTickets(propiedadElegidoB,PropiedadElegidaDEscripcion,TipoElegidoB,descripcionController.text,prefs.getString("cliente")!,base64Images).listadoCreacionTickets();

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
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Title(color: Color.fromRGBO(6,78,116,1),
                                            child: Text("No hay tickets pendientes",style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width*0.035,
                                              color: Color.fromRGBO(6,78,116,1),
                                            ),
                                            ),
                                          ));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return  Center(
                                          child: Title(color: Color.fromRGBO(6,78,116,1),
                                            child: Text("No hay tickets pendientes",style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width*0.035,
                                              color: Color.fromRGBO(6,78,116,1),
                                            ),
                                            ),
                                          )
                                      );
                                    }
                                    final documentos = snapshot.data!; // API list
                                    return LayoutBuilder(
                                        builder: (context, constraints) {
                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics: const ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: documentos.length,
                                            itemBuilder: (context, index) {
                                              final event = documentos[index];

                                              return Container(
                                                width: MediaQuery.of(context).size.width*0.75,
                                                height: constraints.maxWidth < 400? constraints.maxWidth*1.1: constraints.maxWidth*1.1,
                                                child: Center(
                                                  child: Card(
                                                    color: Color.fromRGBO(237, 237, 237,1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width*0.75,
                                                        child: Column(
                                                          children: [

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(event.pvEstadoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Colors.grey[500],
                                                                  fontSize:constraints.maxWidth*0.04,)),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                SizedBox(
                                                                 width: constraints.maxWidth*0.40,
                                                                  height: constraints.maxWidth*0.30,
                                                                  child: event.plFotografias.isNotEmpty &&
                                                                      event.plFotografias.first.pvFotografiaB64 != null ? ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image.memory(base64Decode(event.plFotografias[0].pvFotografiaB64!),
                                                                      fit: BoxFit.fill,
                                                                      width: double.infinity,),
                                                                  ):Icon(Icons.image_not_supported,size: 80,),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: constraints.maxWidth*0.35,
                                                                      child: Text("Ticket ${ event.pnGestion}",style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Color.fromRGBO(167,167,132,1),
                                                                        fontSize: constraints.maxWidth*0.045,),maxLines: 3,textAlign: TextAlign.center,),
                                                                    ),
                                                                    SizedBox(
                                                                      width: constraints.maxWidth*0.35,
                                                                      child: Text(event.pvDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Color.fromRGBO(167,167,132,1),
                                                                        fontSize: constraints.maxWidth*0.045,),maxLines: 3,textAlign: TextAlign.center,),
                                                                    ),
                                                                    SizedBox(
                                                                      width: constraints.maxWidth*0.35,
                                                                      child: Text(event.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Color.fromRGBO(167,167,132,1),
                                                                        fontSize: constraints.maxWidth*0.045,),maxLines: 3,textAlign: TextAlign.center,),
                                                                    ),
                                                                    SizedBox(
                                                                      width: constraints.maxWidth*0.35,
                                                                      child: Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Color.fromRGBO(167,167,132,1),
                                                                        fontSize: constraints.maxWidth*0.045,),maxLines: 3,textAlign: TextAlign.center,),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.03,
                                                              width: MediaQuery.of(context).size.width*0.03,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text("CREACIÓN",style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                      fontSize:constraints.maxWidth*0.04,)),
                                                                    Text(
                                                                          () {
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
                                                                        color:Colors.grey[500],
                                                                        fontSize: constraints.maxWidth * 0.04,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text("ATENCIÓN",style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                      fontSize:constraints.maxWidth*0.04,)),

                                                                    Text(
                                                                          () {
                                                                        final raw = event.pvTiempoAtencion;
                                                                        if (raw == null || raw.isEmpty) return 'Sin atender';
                                                                        Duration duration = Duration(seconds: int.parse(raw));
                                                                        int days = duration.inDays;
                                                                        int hours = duration.inHours % 24;
                                                                        int minutes = duration.inMinutes % 60;
                                                                        return "${days}d ${hours}h ${minutes}m";
                                                                      }(),
                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Colors.grey[500],
                                                                        fontSize: constraints.maxWidth * 0.04,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),

                                                                /*
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text("CLASIFICACIÓN",style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize: constraints.maxWidth*0.04,)),
                                                            Text(event.pvGestionTipoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Colors.grey[500],
                                                              fontSize: constraints.maxWidth*0.04,))
                                                          ],
                                                        )
                                                         */
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height*0.03,
                                                              width: MediaQuery.of(context).size.width*0.03,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                /*Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text("ESTADO",style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize:constraints.maxWidth*0.04,)),

                                                          ],
                                                        ),*/
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text("GESTIÓN",style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                      fontSize: constraints.maxWidth*0.04,)),
                                                                    Text(event.pvGestionTipoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Colors.grey[500],
                                                                      fontSize: constraints.maxWidth*0.04,))
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text("CALIFICACIÓN",style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                      fontSize: MediaQuery.of(context).size.width*0.04,)),
                                                                    Center(child: RatingBar.builder(
                                                                      initialRating: event.pnCalificacion!.toDouble(), // Initial rating value
                                                                      minRating: 1,
                                                                      direction: Axis.horizontal,
                                                                      allowHalfRating: true,
                                                                      itemCount: 5,
                                                                      itemSize: constraints.maxWidth < 400 ? 15: 30,
                                                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                      itemBuilder: (context, _) => Icon(
                                                                        Icons.star,
                                                                        color: Colors.amber,
                                                                      ),
                                                                      onRatingUpdate: (rating) {
                                                                        debugPrint(rating.toString()); // Handle rating changes
                                                                      },
                                                                    ),)
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            20.height,
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width*0.35,
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                                  // set the background color
                                                                ),
                                                                onPressed: ()
                                                                {
                                                                  if( event.plSeguimiento != null)
                                                                    {
                                                                      showDialog<void>(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return StatefulBuilder(
                                                                            builder: (BuildContext context, StateSetter setStateDialog) {
                                                                              return AlertDialog(
                                                                                title:  Text("Ticket ${event.pnGestion} ${event.pvDescripcion.toString()} ${event.pvEstadoDescripcion.toString()}",maxLines: 3,),
                                                                                content: SingleChildScrollView(
                                                                                  physics: const ScrollPhysics(),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      20.height,
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        height: MediaQuery.of(context).size.height * 0.7,
                                                                                        child: ListView.builder(
                                                                                          padding: EdgeInsets.zero,
                                                                                          shrinkWrap: true,
                                                                                          physics: const ScrollPhysics(),
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
                                                                                                  fontSize: constraints.maxWidth * 0.045,
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
                                                                                                        fontSize: constraints.maxWidth * 0.04,
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
                                                                                                    fontSize: constraints.maxWidth * 0.045,
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
                                                                                                    fontSize: constraints.maxWidth * 0.045,
                                                                                                  ),
                                                                                                  maxLines: 2,
                                                                                                  textAlign: TextAlign.center,
                                                                                                ),
                                                                                                const SizedBox(height: 10),
                                                                                                SizedBox(
                                                                                                  width: constraints.maxWidth * 0.40,
                                                                                                  height: constraints.maxWidth * 0.30,
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
                                                                                      ),
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
                                                                    }
                                                                  else{
                                                                    msgxToast("no hay seguimiento disponible");
                                                                  }

                                                                },
                                                                child: Text("Seguimiento",style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize:
                                                                  MediaQuery.of(context).size.width * 0.05,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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


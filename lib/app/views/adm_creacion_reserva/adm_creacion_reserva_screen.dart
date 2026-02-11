import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api_Clases/class_ReservasF1.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_creacion_reserva_controller.dart';
import '../../controller/adm_home_controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../adm_home/adm_home_screen.dart';
import 'package:image/image.dart' as img;
import 'package:table_calendar/table_calendar.dart';


class AdmCreacionReservaScreen extends StatefulWidget {
  const AdmCreacionReservaScreen({super.key});

  @override
  State<AdmCreacionReservaScreen> createState() => _AdmCreacionResrvaScreenState();

}

class _AdmCreacionResrvaScreenState extends State<AdmCreacionReservaScreen> {

  late ThemeData theme;
  AdmCrearReservaController adm_reservaController = Get.put(
      AdmCrearReservaController());
  AdmMenuController menuController = Get.put(AdmMenuController());
  AdmHomeController homeController = Get.put(AdmHomeController());
  String userName = "";

  Future<List<DatosReservaF1>>? _futureReservas;

  int setAmenidad = 0;

  String tituloSet = "";
  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  TextEditingController eventoController = TextEditingController();
  TextEditingController eventoUbicacionController = TextEditingController();
  TextEditingController propiedadShowController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  //TextEditingController fechaFinalController = TextEditingController();
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFinalController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String propiedadAcobrar = "";
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String userNombre = "";
  String admincheck = "";
  String juntaDirect = "";
  bool tickets = true;
  Key _pageKey = UniqueKey();
  bool  isChecked = false;
String terminosCondiciones = "";

  String propiedadNombre = "";
  String propiedadDireccion = "";
  String inquilino = "";

  @override
  void initState() {
    super.initState();
    _futureReservas = adm_reservaController.amenidadesReservadasListaF1();

    getUserInfo();
    theme = adm_reservaController.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      theme = adm_reservaController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;
    });
  }

  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString("cliente", clientesIdsSet[0].toString());
      debugPrint("cliente!!");
      debugPrint(prefs.getString("cliente"));
       userName = prefs.getString("NombreUser")!;
      admincheck = prefs.getString("Admin")!;
      juntaDirect = prefs.getString("JuntaDirectiva")!;
      inquilino = prefs.getString("Inquilino") ?? "0";

      if(admincheck == "1")
      {
        tickets = true;
      }
      else
      {
        tickets = false;
      }

    });
  }

  void reloadPage()
  {
    setState(() {
      _pageKey = UniqueKey();
       _futureReservas = adm_reservaController.amenidadesReservadasListaF1();
    });
  }

  String formatMoneyWithoutSymbol(double amount) {
    final numberFormat = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return numberFormat.format(amount);
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
                setState(() {
                  controller.text = DateFormat('dd/MM/yyyy').format(fechaSelect);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _pageKey,
        backgroundColor: adm_reservaController.themeController.isDarkMode
            ? admDarkPrimary
            : admWhiteColor,
        appBar: AppBar(
          backgroundColor: adm_reservaController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) =>
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: adm_reservaController.themeController.isDarkMode
                          ? admWhiteColor
                          : admTextColor,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Title(color: Colors.black,
                              child: Text("Estado de cuenta"))
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
                color: adm_reservaController.themeController.isDarkMode
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
                              color: adm_reservaController.themeController
                                  .isDarkMode
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
                                    adm_reservaController.themeController
                                        .isDarkMode
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
                            ]
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
                          final iconData = _getIconForIndex(index, admincheck, juntaDirect, inquilino);

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

        body: GetBuilder<AdmCrearReservaController>(
            init: adm_reservaController,
            tag: 'adm_estadoCuenta',
            // theme: theme,
            builder: (admReservaController) =>
                SingleChildScrollView(
                    child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 3,
                                    color:Colors.white,
                                    child: Column(
                                      children: [
                                        Title(color: Color.fromRGBO(6,78,116,1), child: Text("Amenidades Disponibles")),

                  FutureBuilder<List<DatosReservaF1>>(
                    future: _futureReservas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "No hay reservas disponibles",
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
                            "No hay reservas disponibles",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.035,
                              color: const Color.fromRGBO(6, 78, 116, 1),
                            ),
                          ),
                        );
                      }
                      final documentos = snapshot.data!;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth = constraints.maxWidth * 0.9;

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1, // si quieres mostrar solo 1 Dropdown
                            itemBuilder: (context, index)
                            {
                              _controllers.putIfAbsent(index, () => CarouselSliderController());
                              _currentIndex[index] = _currentIndex[index] ?? 0;

                              final images = (documentos[setAmenidad].plFotografias as List<dynamic>?)
                                  ?.where((f) => f.pvFotografiaB64 != null && f.pvFotografiaB64.toString().isNotEmpty)
                                  .map((f) => f.pvFotografiaB64.toString())
                                  .toList()
                                  ?? [];
                              _controllers.putIfAbsent(index, () => CarouselSliderController());
                              _currentIndex[index] = _currentIndex[index] ?? 0;
                              DateTime _focusedDay = DateTime.now();
                              DateTime? _selectedDay;

                              terminosCondiciones = documentos[setAmenidad].pvTerminosCondiciones.toString();
                              List<Reserva> getEventsForDay(DateTime day) {
                                return documentos[setAmenidad].plReservas.where((reserva) {
                                  final reservaDate = DateTime.tryParse(reserva.pfFecha);
                                  if (reservaDate == null) return false;

                                  // normalize both dates (ignore hours/minutes)
                                  final normalizedReservaDate = DateTime(reservaDate.year, reservaDate.month, reservaDate.day);
                                  final normalizedDay = DateTime(day.year, day.month, day.day);

                                  return normalizedReservaDate == normalizedDay;
                                }).toList();
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: cardWidth,
                                      child: Card(
                                        elevation: 4,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Amenidades Disponibles",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                ),
                                              ),
                                              const SizedBox(height: 12),

                                              DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                value: documentos[setAmenidad].pvAmenidadDescripcion,
                                                hint: const Text("Seleccione una Amenidad"),
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
                                                items: documentos.map((doc) {
                                                  return DropdownMenuItem<String>(
                                                    value: doc.pvAmenidadDescripcion,
                                                    child: Text(
                                                      doc.pvAmenidadDescripcion ?? "Sin descripción",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    setAmenidad = documentos.indexWhere(
                                                            (doc) => doc.pvAmenidadDescripcion == value);
                                                    tituloSet = value ?? "";
                                                  });
                                                  debugPrint("Seleccionaste: $tituloSet");
                                                },
                                              ),

                                              const SizedBox(height: 12),

                                              /// Muestra la selección
                                              Row(
                                                children: [
                                                  Text(
                                                    tituloSet,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(6, 78, 116, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              StatefulBuilder(
                                                builder: (context, setLocalState) {
                                                  return SizedBox(
                                                    width: constraints.maxWidth * 0.85,
                                                    height: constraints.maxWidth * 0.50,
                                                    child: images.isNotEmpty
                                                        ? Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        CarouselSlider(
                                                          carouselController: _controllers[index],
                                                          options: CarouselOptions(
                                                            viewportFraction: 1.0,
                                                            enableInfiniteScroll: images.length > 1,
                                                            enlargeCenterPage: true,
                                                            height: constraints.maxWidth * 0.50, // ✅ match parent
                                                            onPageChanged: (page, reason) {
                                                              setLocalState(() {
                                                                _currentIndex[index] = page;
                                                              });
                                                            },
                                                          ),
                                                          items: images.map((base64Img) {
                                                            try {
                                                              final bytes = base64Decode(base64Img);
                                                              return ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: Image.memory(
                                                                  bytes,
                                                                  fit: BoxFit.fill,
                                                                  width: double.infinity,
                                                                ),
                                                              );
                                                            } catch (e) {
                                                              return const Center(child: Text("Imagen inválida"));
                                                            }
                                                          }).toList(),
                                                        ),

                                                        // ⬅️ Left arrow
                                                        if (images.length > 1)
                                                          Positioned(
                                                            left: 5,
                                                            child: IconButton(
                                                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                                                              onPressed: () {
                                                                _controllers[index]?.previousPage(
                                                                  duration: const Duration(milliseconds: 300),
                                                                  curve: Curves.easeInOut,
                                                                );
                                                              },
                                                            ),
                                                          ),

                                                        // ➡️ Right arrow
                                                        if (images.length > 1)
                                                          Positioned(
                                                            right: 5,
                                                            child: IconButton(
                                                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                                                              onPressed: () {
                                                                _controllers[index]?.nextPage(
                                                                  duration: const Duration(milliseconds: 300),
                                                                  curve: Curves.easeInOut,
                                                                );
                                                              },
                                                            ),
                                                          ),

                                                        // 🔘 Indicator dots
                                                        if (images.length > 1)
                                                          Positioned(
                                                            bottom: 5,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: images.asMap().entries.map((entry) {
                                                                final isActive = _currentIndex[index] == entry.key;
                                                                return Container(
                                                                  width: isActive ? 10 : 6,
                                                                  height: isActive ? 10 : 6,
                                                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: isActive ? Colors.white : Colors.grey,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                      ],
                                                    )
                                                        : const Center(child: Text("Sin fotos")),
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "${documentos[setAmenidad].pvMonedaSimbolo} ${ formatMoneyWithoutSymbol(documentos[setAmenidad].pmValor)}",
                                                style:  TextStyle(
                                                  fontSize: constraints.maxWidth * 0.075,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            Center(  // ensures measurable tap area
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                    // set the background color
                                                  ),
                                                  onPressed: () {
                                                    // Safely obtain the text from documentos
                                                    String texto = '';
                                                    if (documentos.isNotEmpty && setAmenidad < documentos.length) {
                                                      texto = documentos[setAmenidad].pvAmenidadReglamentoUso?.toString() ?? '';
                                                    }
                                                    showDialog(
                                                      context: context,
                                                      builder: (dialogContext) => AlertDialog(
                                                        title: const Text(
                                                          "Condiciones y Reglamento de Uso",
                                                          textAlign: TextAlign.center,
                                                        ),

                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                texto,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                ),
                                                                maxLines: 20,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(dialogContext).pop(),
                                                            child: const Text("Cerrar"),
                                                          ),
                                                        ],

                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Condiciones y Reglamento de Uso",
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Text("Cupo disponible ${documentos[setAmenidad].pnCupo}",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Color.fromRGBO(167,167,132,1))),

                                              documentos[setAmenidad].pnEnServicio == 1 ? Text("Cerrado por ${documentos[setAmenidad].pvNoEnServicioObservaciones.toString()}"):TextButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                    // set the background color
                                                  ),
                                                  onPressed: ()
                                                  {
                                                    debugPrint("Info para hacer recerva");

                                                    debugPrint("Bloqueo");
                                                    debugPrint(documentos[setAmenidad].pnBloqueada.toString());
                                                    debugPrint(documentos[setAmenidad].pvBloqueoDescripcion.toString());
                                                    debugPrint("Servicio");
                                                    debugPrint(documentos[setAmenidad].pnEnServicio.toString());
                                                    debugPrint(documentos[setAmenidad].pvNoEnServicioObservaciones.toString());


                                                    setState(() {
                                                      propiedadAcobrar = propiedadesInternasIdsSet1[0].toString();
                                                      observacionesController.text = " ";
                                                      propiedadNombre =  propiedadesInternaNombresSet1[0].toString();
                                                      propiedadDireccion = propiedadesDireccionNombresSet1[0].toString();
                                                      debugPrint(propiedadAcobrar);
                                                      debugPrint(propiedadNombre);
                                                      debugPrint(propiedadDireccion);
                                                    });
                                                    if(documentos[setAmenidad].pnBloqueada == 1)
                                                      {
                                                      showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return  StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                                            return AlertDialog(

                                                                content: SingleChildScrollView(
                                                                scrollDirection: Axis .vertical,
                                                                  child: Title(color:  Color.fromRGBO(6, 78, 116, 1),
                                                                      child: Text(documentos[setAmenidad].pvBloqueoDescripcion)),
                                                                )
                                                            );
                                                          }
                                                        );
                                                      }
                                                      );
                                                     }
                                                    else
                                                    {
                                                      showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return  StatefulBuilder(
                                                              builder: (BuildContext context, StateSetter setStateDialog) {
                                                                final fieldWidth = constraints.maxWidth * 0.4;
                                                                return AlertDialog(
                                                                  title: const Text("Agregar un nuevo evento"),
                                                                  content: SingleChildScrollView(
                                                                    scrollDirection: Axis .vertical,
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      child:  Column(
                                                                        children: <Widget>[
                                                                          Title(color:  Color.fromRGBO(6, 78, 116, 1), child: Text(" Evento/uso")),
                                                                          TextFormField(
                                                                            controller: eventoController,
                                                                            onChanged: (value)
                                                                            {
                                                                              setStateDialog(() {
                                                                                eventoController.text = value;
                                                                              });
                                                                            },
                                                                            validator: (String? value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Información requerida'; // Error message if empty
                                                                              }
                                                                              return null; // Return null if the input is valid
                                                                            },
                                                                          ),
                                                                          10.height,
                                                                          Title(color:  Color.fromRGBO(6, 78, 116, 1),
                                                                              child: Text("Propiedad a cargar el cobro (${documentos[setAmenidad].pvMonedaSimbolo} ${formatMoneyWithoutSymbol(documentos[setAmenidad].pmValor)})")),
                                                                          10.height,
                                                                          DropdownButtonFormField<String>(
                                                                            validator: (String? value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return 'Información requerida'; // Error message if empty
                                                                              }
                                                                              return null; // Return null if the input is valid
                                                                            },
                                                                            isExpanded: true,
                                                                            value: clientesIdsSet1[0].toString(),
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
                                                                            items: List.generate(clientesIdsSet1.length, (index) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: clientesIdsSet1[index],
                                                                                child: Text("${propiedadesInternaNombresSet1[index]} ${propiedadesDireccionNombresSet1[index]}",
                                                                                  style: const TextStyle(
                                                                                    fontSize:  20,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }),
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                int index = clientesIdsSet1.indexOf(value!);
                                                                                //propiedadAcobrar = value;
                                                                                debugPrint(index.toString());
                                                                                propiedadAcobrar = propiedadesInternasIdsSet1[index].toString();
                                                                                propiedadNombre =  propiedadesInternaNombresSet1[index].toString();
                                                                                propiedadDireccion = propiedadesDireccionNombresSet1[index].toString();
                                                                                clienteIDset = value;
                                                                                debugPrint(propiedadAcobrar);
                                                                                debugPrint(propiedadNombre);
                                                                                debugPrint(propiedadDireccion);

                                                                              });
                                                                            },
                                                                          ),
                                                                          Title(color:  Color.fromRGBO(6, 78, 116, 1), child: Text("Ubicación del Evento")),
                                                                          10.height,
                                                                          TextFormField(
                                                                            readOnly: true,
                                                                            controller: eventoUbicacionController,
                                                                            decoration:   InputDecoration(
                                                                              hintText: documentos[setAmenidad].pvAmenidadDescripcion,
                                                                            ),
                                                                            onChanged: (value)
                                                                            {
                                                                              setStateDialog(() {
                                                                                eventoUbicacionController.text = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                          10.height,
                                                                          Text("Tiempo Máximo de Cupo:${documentos[setAmenidad].pnPeriodoTiempo}hrs"),
                                                                          10.height,
                                                                          Title(color:  Color.fromRGBO(6, 78, 116, 1), child: Text("Horarios Hábiles de Utilización")),
                                                                          documentos[setAmenidad].plHorario.isNotEmpty ? Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[0].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[0].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[0].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[0].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[0].pvHorarioFinDescanso}"),
                                                                                        /*ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[0].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[0].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[0].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[0].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[0].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[1].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[1].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[1].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[1].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[1].pvHorarioFinDescanso}"),
                                                                                        /*ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[1].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[1].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[1].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[1].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[1].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[2].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[2].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[2].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[2].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[2].pvHorarioFinDescanso}"),
                                                                                        /*ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[2].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[2].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[2].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[2].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[2].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[3].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[3].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[3].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[3].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[3].pvHorarioFinDescanso}"),
                                                                                      /*  ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[3].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[3].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[3].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[3].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[3].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[4].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[4].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[4].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[4].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[4].pvHorarioFinDescanso}"),
                                                                                        /*ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[4].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[4].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[4].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[4].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[4].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[5].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[5].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[5].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[5].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[5].pvHorarioFinDescanso}"),
                                                                                       /* ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[5].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[5].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[5].pvHorarioFin}"),
                                                                                        ),
                                                                                        ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[5].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[5].pvHorarioFinDescanso}"),
                                                                                        ),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width:constraints.maxWidth*0.35,
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Text("-${documentos[setAmenidad].plHorario[6].pvDia}"),
                                                                                        Text("${documentos[setAmenidad].plHorario[6].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[6].pvHorarioFin}"),
                                                                                        Text("Descanso"),
                                                                                        Text("${documentos[setAmenidad].plHorario[6].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[6].pvHorarioFinDescanso}"),
                                                                                       /* ListTile(
                                                                                          title: Text("${documentos[setAmenidad].plHorario[6].pvDia}"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[6].pvHorarioInicio} - ${documentos[setAmenidad].plHorario[6].pvHorarioFin}"),
                                                                                        ),
                                                                                        documentos[setAmenidad].plHorario[6].pvHorarioInicioDescanso == "00:00" ? ListTile(
                                                                                          title: Text("Descanso"),
                                                                                          subtitle: Text("${documentos[setAmenidad].plHorario[6].pvHorarioInicioDescanso} - ${documentos[setAmenidad].plHorario[6].pvHorarioFinDescanso}"),
                                                                                        ):Center(),*/
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              10.height,
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  // === Row 1 ===
                                                                                  Wrap(
                                                                                    spacing: 16,
                                                                                    runSpacing: 16,
                                                                                    alignment: WrapAlignment.spaceBetween,
                                                                                    children: [
                                                                                      _buildDateField(
                                                                                        label: "Fecha de Inicio",
                                                                                        controller: fechaController,
                                                                                        theme: theme,
                                                                                        context: context,
                                                                                        width: fieldWidth,
                                                                                      ),
                                                                                      _buildTimeField(
                                                                                        label: "Hora de Inicio",
                                                                                        controller: horaInicioController,
                                                                                        theme: theme,
                                                                                        context: context,
                                                                                        width: fieldWidth,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(height: 20),
                                                                                  // === Row 2 ===
                                                                                  Wrap(
                                                                                    spacing: 16,
                                                                                    runSpacing: 16,
                                                                                    alignment: WrapAlignment.spaceBetween,
                                                                                    children: [
                                                                                      _buildDateField(
                                                                                        label: "Fecha de Finalización",
                                                                                        controller: fechaController,
                                                                                        theme: theme,
                                                                                        context: context,
                                                                                        width: fieldWidth,
                                                                                      ),
                                                                                      _buildTimeField(
                                                                                        label: "Hora de Finalización",
                                                                                        controller: horaFinalController,
                                                                                        theme: theme,
                                                                                        context: context,
                                                                                        width: fieldWidth,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              SizedBox(
                                                                                width:constraints.maxWidth*0.60,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Title(color:  Color.fromRGBO(6, 78, 116, 1), child: Text("Observaciones")),
                                                                                    TextFormField(
                                                                                      controller: observacionesController,
                                                                                      onChanged: (value)
                                                                                      {
                                                                                        setStateDialog(() {
                                                                                          observacionesController.text = value;
                                                                                        });
                                                                                      },

                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.15,
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
                                                                                      value: isChecked,
                                                                                      onChanged: (value) {
                                                                                        setStateDialog(() {
                                                                                          isChecked = value!;
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                      width: MediaQuery.of(context).size.width * 0.50,
                                                                                      child: TextButton(
                                                                                        onPressed: ()
                                                                                        {
                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (_) => AlertDialog(
                                                                                              content: Text(terminosCondiciones),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Text("Al crear la reservación acepta los términos y condiciones",style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Color.fromRGBO(6, 78, 116, 1),
                                                                                          fontSize: constraints.maxWidth*0.05,)),)
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Color.fromRGBO(6, 78, 116, 1), // set the background color
                                                                                  ),
                                                                                  onPressed:()
                                                                                  {
                                                                                    if (!_formKey.currentState!.validate()) {
                                                                                      msgxToast("Por favor complete todos los campos requeridos.");
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        const SnackBar(
                                                                                          content: Text("Por favor complete todos los campos requeridos."),
                                                                                        ),
                                                                                      );
                                                                                      return;
                                                                                    }

                                                                                    if (!isChecked) {
                                                                                      msgxToast("Debe aceptar los términos y condiciones");
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        const SnackBar(
                                                                                          content: Text("Debe aceptar los términos y condiciones."),
                                                                                        ),
                                                                                      );
                                                                                      return;
                                                                                    }
                                                                                    if(observacionesController.text == ""||observacionesController.text == " "||observacionesController.text == null)
                                                                                      {
                                                                                        setStateDialog(() {
                                                                                          observacionesController.text = "Observacion";
                                                                                        });
                                                                                      }

                                                                                    debugPrint("Info para reserva");
                                                                                    debugPrint(userName);
                                                                                    debugPrint(edificioID);
                                                                                    debugPrint(edificioDescripcion);
                                                                                    debugPrint(propiedadNombre);
                                                                                    debugPrint(propiedadDireccion);
                                                                                    debugPrint(documentos[setAmenidad].pvAmenidadDescripcion);
                                                                                    debugPrint(documentos[setAmenidad].pnAmenidad.toString());
                                                                                    DateTime fecha = DateFormat('dd/MM/yyyy').parse(fechaController.text);
                                                                                    String formattedDate = DateFormat('yyyyMMdd').format(fecha);
                                                                                    debugPrint(formattedDate);
                                                                                    debugPrint(horaInicioController.text);
                                                                                    debugPrint(horaFinalController.text);
                                                                                    debugPrint(documentos[setAmenidad].pvMonedaDescripcion);
                                                                                    debugPrint(documentos[setAmenidad].pmValor.toString());
                                                                                    reservaAmenidadCreacion(userName,propiedadAcobrar,propiedadNombre,propiedadDireccion,documentos[setAmenidad].pnAmenidad.toString(),formattedDate,horaInicioController.text, horaFinalController.text,documentos[setAmenidad].pvMonedaDescripcion, documentos[setAmenidad].pmValor.toString(),observacionesController.text).reservaAmenidadCreacionF6();

                                                                                    setState(() {
                                                                                      Future.delayed(const Duration(milliseconds: 250), ()
                                                                                      {
                                                                                      _futureReservas = adm_reservaController.amenidadesReservadasListaF1();
                                                                                      reloadPage();
                                                                                      Navigator.of(context).pop();
                                                                                      });
                                                                                      eventoController.clear();
                                                                                      fechaController.clear();
                                                                                      horaInicioController.clear();
                                                                                      horaFinalController.clear();
                                                                                    });

                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      const SnackBar(content: Text('Actualizando reservas...')),
                                                                                    );
                                                                                  },
                                                                                  child: Text("Realizar Reserva"))
                                                                            ],
                                                                          ):Center(child: Text("No hay horarios disponibles"),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      style: TextButton.styleFrom(
                                                                        textStyle: Theme.of(context).textTheme.labelLarge,
                                                                      ),
                                                                      child:  Text('Cerrar'),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Text("Hacer reserva",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: constraints.maxWidth * 0.075,
                                                  ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                        20.height,
                        FutureBuilder<List<DatosReservaF1>>(
                          future: _futureReservas,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(color: Colors.blue));
                            } else if (snapshot.hasError) {
                              return const Center(child: Text("Error cargando reservas"));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No hay documentos Pendientes"));
                            }

                            final documentos = snapshot.data!;

                      /// 🔑 Function to get reservas for a given day
                      List<Reserva> getEventsForDay(DateTime day) {
                        return documentos[setAmenidad].plReservas.where((reserva) {
                          final reservaDate = DateTime.tryParse(reserva.pfFecha);
                          if (reservaDate == null) return false;

                          // normalize both dates (ignore hours/minutes)
                          final normalizedReservaDate = DateTime(reservaDate.year, reservaDate.month, reservaDate.day);
                          final normalizedDay = DateTime(day.year, day.month, day.day);

                          return normalizedReservaDate == normalizedDay;
                        }).toList();
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            /// 📅 TableCalendar inside FutureBuilder
                            TableCalendar<Reserva>(
                              firstDay: DateTime.now(),
                              lastDay: DateTime.utc(2100, 12, 30),
                              focusedDay: _focusedDay,
                              calendarFormat: _format,

                              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  fechaController.text = DateFormat('dd/MM/yyyy').format(_selectedDay!);
                                  debugPrint(fechaController.text);
                                });
                              },

                              onFormatChanged: (format) {
                                setState(() => _format = format);
                              },

                              eventLoader: getEventsForDay,
                              calendarStyle: const CalendarStyle(
                                isTodayHighlighted: true,
                                markerDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// 📋 Reservas del día seleccionado
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: getEventsForDay(_selectedDay ?? _focusedDay)
                                  .map((reserva) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.event),
                                  title: tickets? Text(reserva.pvUsuarioNombre):Text(""),
                                  subtitle: Text(
                                    "Estado: ${reserva.pvEstadoDescripcion}\n"
                                        "Fecha: ${reserva.pfFecha} (${reserva.pfInicio} - ${reserva.pfFin})",
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ],
                                    ),
                                  )
                                ],
                              )
                          )
                        ]
                    )
                )
        )
    );
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
                  padding: MediaQuery
                      .of(context)
                      .viewInsets,
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
                        padding: EdgeInsets.only(
                            left: 8, right: 8, bottom: GetPlatform.isIOS
                            ? MediaQuery
                            .of(context)
                            .padding
                            .bottom
                            : 8, top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.offNamedUntil(
                                      MyRoute.loginScreen, (route) => route
                                      .isFirst);
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
                                  Get.offNamedUntil(
                                      MyRoute.loginScreen, (route) => route
                                      .isFirst);
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


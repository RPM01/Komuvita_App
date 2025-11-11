import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_Clases/class_Document5.dart';
import '../../../api_Clases/class_RentasVentas5.dart';
import '../../../api_Clases/class_Reservas5.dart';
import '../../../api_Clases/class_Tickets5.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_comunicacion_Admin_ticket_controller.dart';
import '../../controller/adm_home_controller.dart';
import '../../controller/adm_login_controller.dart';
import '../../controller/adm_menu_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
 import '../adm_creacion_reserva/adm_creacion_reserva_screen.dart';
 import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image/image.dart' as img;
 import 'package:path_provider/path_provider.dart';
 import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
 import 'package:open_filex/open_filex.dart';

String _EdificioPropiedadSelecionada = "";
String edificioID = empresasIdsSet[0].toString();
String edificioDescripcion = empresasNombresSet[0];
class AdmHomeScreen extends StatefulWidget {
  const AdmHomeScreen({super.key});

  @override
  State<AdmHomeScreen> createState() => _AdmHomeScreenState();
  //State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmHomeScreenState extends State<AdmHomeScreen> {
  late ThemeData theme;

  final homeController = Get.put(AdmHomeController());
  AdmMenuController controller = Get.put(AdmMenuController());
  LoginController loadingContrller = Get.put(LoginController());
  var timeFormat = DateFormat("HH:mm");

  double rating = 3.5;
  int starCount = 5;
  String instrucionesPago = "";
  String userName = "";
  String userCode = "";
  List<String> pago = [];

  String ? edificioID;
  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  late Future<List<DacumentosH5>> _futureDocumentos;
  late Future<List<ReservasF5>> _futureReservas;
  late Future<List<TickestG5>> _futureTickets;
  late Future<List<RentaVentaD5>> _futureRentas;
  late Future _futureInfo;
  late Future _futureNoticias;
  late Future _futurePerdidos;
  late Future _futurePaquetes;
  late Future _futureVisitas;
  late Future _futureListaPagos;

  File ? iamgenSelect;

  String base64Image = "";

  File ? iamgenSelectB;

  String base64ImageB = "";

  TextEditingController montoPagarController = TextEditingController();
  TextEditingController montoPagarControllerB = TextEditingController();
  TextEditingController formaPagoController = TextEditingController();
  TextEditingController fechaPagoController = TextEditingController();
  TextEditingController numeroAutorizacionController = TextEditingController();
  TextEditingController observacionesRechazoController = TextEditingController();

  DateTime fechaSelecionada  = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKeyB = GlobalKey<FormState>();

  final scrollController = ScrollController();
  final GlobalKey stopKey = GlobalKey(); // Add at class level

  Future<void> scrollToBottom() async {
    if (!scrollController.hasClients) return;

    const step = 50.0; // scroll step in pixels
    const delay = Duration(milliseconds: 16); // ~60fps for smoothness

    while (scrollController.offset < scrollController.position.maxScrollExtent) {
      // Check if target is visible
      final RenderObject? renderObject = stopKey.currentContext?.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;

        if (position.dy > 0 && position.dy < screenHeight * 0.8) {
          // 👇 stop scroll when the target widget becomes visible
          debugPrint("Target text visible — stopping scroll");
          break;
        }
      }

      // Continue smooth scroll
      double newOffset = (scrollController.offset + step).clamp(
        0.0,
        scrollController.position.maxScrollExtent,
      );
      scrollController.jumpTo(newOffset);

      await Future.delayed(delay);
    }}

  String formatMoneyWithoutSymbol(double amount) {
    final numberFormat = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return numberFormat.format(amount);
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

      print('✅ PDF saved at: ${file.path}');
    } catch (e) {
      print('❌ Error decoding PDF: $e');
    }
  }

  @override
  void initState() {
    super.initState();

     //homeController = Get.put(AdmHomeController());
     //controller = Get.put(AdmMenuController());
     //loadingContrller = Get.put(LoginController());
    getUserInfo();
    //futuros
    setState(() {
      GestionTickets2();
    });

      //loadingContrller.GestionTickets1();
    _futureDocumentos = homeController.documentosListados5B();
    _futureRentas = homeController.listadoRentas5B();
    _futureReservas = homeController.amenidadesReservadas5B();
    _futureTickets = homeController.GestionTickets5B();
    _futureInfo = homeController.importanInfo5();
    _futureNoticias = homeController.importanNoticias5();
    _futurePerdidos = homeController.objetosPerdidos5();
    _futurePaquetes = homeController.paqueteria5();
    _futureVisitas = homeController.visitas5();
    homeController.listaPagosH2();

    theme = homeController.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
    final args = Get.arguments;
    if (args != null && args['fromDrawer'] == true) {
      msgxToast("Cargando a paquetes");
      debugPrint("VOY A BAJAR!!!!");
      Future.delayed(const Duration(seconds: 5), ()
      {
        irPorPAquetes();
      }
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      theme = homeController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;

    });
  }
  void reloadHomePage()
  {

  _futureDocumentos = homeController.documentosListados5B();
  _futureRentas = homeController.listadoRentas5B();
  _futureReservas = homeController.amenidadesReservadas5B();
  _futureTickets = homeController.GestionTickets5B();
  _futureInfo = homeController.importanInfo5();
  _futureNoticias = homeController.importanNoticias5();
  _futurePerdidos = homeController.objetosPerdidos5();
  _futurePaquetes = homeController.paqueteria5();
  _futureVisitas = homeController.visitas5();
  homeController.listaPagosH2();

  GestionTickets2();
}
  void reloadreserva()
  {
    _futureReservas = homeController.amenidadesReservadas5B();
  }
  int currentIndex = 0;
  String admincheck = "";
  bool tickets = true;

  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    edificioID = empresasIdsSet[0].toString();
    setState(() {
       //prefs.setString("cliente", clientesIdsSet[0].toString());
       //debugPrint("cliente!!");
       debugPrint(prefs.getString("cliente"));
      userName = prefs.getString("NombreUser")!;
      instrucionesPago = prefs.getString("intruciones de pago")!;
      admincheck = prefs.getString("Admin")!;

      if(admincheck == "1")
        {
          tickets = true;
        }
      else
        {
          tickets = false;
        }
      debugPrint("Intruciones Intruciones 3");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
    });
    final args = Get.arguments;
    if (args != null && args['fromDrawer'] == true) {
      msgxToast("Cargando a paquetes");
      debugPrint("VOY A BAJAR!!!!");
      Future.delayed(const Duration(seconds: 3), ()
      {
        irPorPAquetes();
      }
      );
    }
  }

  Future<void> irPorPAquetes()
   async {
    Future.delayed(const Duration(seconds: 60));
    scrollToBottom();
    }

 /* void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.base64Images.length;
    });
  }

  void prevImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.base64Images.length) % widget.base64Images.length;
    });
  }*/


  Future _PickGalery() async
  {
    final regresarIamgenSelect = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    setState(() {
      if (regresarIamgenSelect == null) return;
      iamgenSelect = File(regresarIamgenSelect.path);
    });
    Navigator.of(context).pop();
  }

  Future _PickFoto() async
  {
    final regresarIamgenSelect = await ImagePicker().pickImage(
        source: ImageSource.camera);
    setState(() {
      if (regresarIamgenSelect == null) return;
      iamgenSelect = File(regresarIamgenSelect.path);
    });
    Navigator.of(context).pop();
  }


  final List<Color> cardColors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
  ];


  final List<Color> cardColorsB = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

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

  final CarouselController _controller = CarouselController();
  final GlobalKey<CarouselSliderState> _carouselKey = GlobalKey<CarouselSliderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:homeController.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
        appBar: AppBar(
          backgroundColor: homeController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: homeController.themeController.isDarkMode
                      ? admWhiteColor
                      : admTextColor,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      splashImg,
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
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
                color: homeController.themeController.isDarkMode
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
                      width: 75,
                      decoration: BoxDecoration(
                          //color: Colors.yellow,
                          border: Border.all(
                              color: homeController.themeController.isDarkMode
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
                                homeController.themeController.isDarkMode
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
              // 🚦 Wait until menu data is loaded
              if (!controller.isMenuReady.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // 🔥 Now build the real drawer because the data is ready
              final isAdmin = controller.isAdmin.value;
              final jundaDir = controller.jundaDir.value;
              final helpAndSupport = controller.helpAndSupport;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDrawerHeader(context, controller, userName),
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
                                Navigator.pop(context); // close the drawer

                                if (isLast) {
                                  Get.snackbar("Sesión", "Cerrando sesión...");
                                  _showLogOutBottomSheet(context);
                                  return;
                                }

                                if (tickets == false && menuTitle == "Paquetes pendientes") {
                                  irPorPAquetes();
                                  debugPrint("Valor del menu");
                                  debugPrint(menuTitle.toString());

                                  //controller.onScrollButtonPressed();
                                  return;
                                }

                                await Future.delayed(const Duration(milliseconds: 200));
                                Get.to(controller.screens[index]);},
                              child: Row(
                                children: [
                                  Icon(
                                    iconData,
                                    size: 22,
                                    color: isLast
                                        ? Colors.red
                                        : (controller.themeController.isDarkMode
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
                                            : (controller.themeController.isDarkMode
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
                                        : (controller.themeController.isDarkMode
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




        body: GetBuilder<AdmHomeController>(
            init: homeController,
            tag: 'adm_home',
            // theme: theme,
            builder: (homeController) => SingleChildScrollView(
                 controller : scrollController,
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
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*0.95,
                                //height: MediaQuery.of(context).size.height*0.20,
                                child: Card(
                                  elevation: 3,
                                    color: Colors.grey[200],
                                  child: Column(
                                    children: [
                                      Text("Seleccionar Edificio",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Color.fromRGBO(6,78,116,1),
                                        fontSize: MediaQuery.of(context).size.width*0.035,
                                      )),
                                    DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: edificioID,
                                      hint: const Text("Seleccione un Edificio"),
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
                                      items: List.generate(empresasIdsSet.length, (index) {
                                        return DropdownMenuItem<String>(
                                          value: empresasIdsSet[index].toString(),
                                          child: Text(
                                            " ${empresasNombresSet[index]} ",
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
                                          debugPrint(empresasNombresSet.toString());
                                          debugPrint(empresasIdsSet.toString());
                                          int index = empresasIdsSet.indexOf(int.parse(value!));
                                          debugPrint("Aqui esta el index");
                                          debugPrint(index.toString());
                                          edificioID = value;
                                          empresaID = value;
                                          loadingContrller.GestionTickets1B();
                                          edificioDescripcion = empresasNombresSet[index];
                                          empresaNombreID =empresasNombresSet[index];
                                          debugPrint(edificioID);
                                          debugPrint(empresaNombreID);
                                          debugPrint(edificioDescripcion);
                                          _EdificioPropiedadSelecionada = value;
                                           reloadHomePage();
                                          //debugPrint(edificioID);
                                        });
                                      },
                                    ),
                                    Text("Por favor, seleccione el edificio para obtener información detallada.",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: MediaQuery.of(context).size.width*0.025,
                                      )),
                                    ],
                                  )
                                ),
                              ),
                            ),
                            17.height,
                            Text("Documentos Pendientes",style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.035,
                        )) ,

                            17.height,
                              FutureBuilder<List<DacumentosH5>>(
                              future:_futureDocumentos,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return  Center(
                                   child: Title(color: Color.fromRGBO(6,78,116,1),
                                    child: Text("No hay documentos Pendientes",style: theme.textTheme.bodyMedium?.copyWith(
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
                                        child: Text("No hay documentos Pendientes",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      ));
                                }
                                final documentos = snapshot.data!;
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final cardWidth = constraints.maxWidth * 0.9;
                                    final cardHeight = constraints.maxHeight * 0.65;
                                    final titleFontSize = constraints.maxWidth * 0.035;
                                    final subtitleFontSize = constraints.maxWidth * 0.03;
                                    DateTime? fechaSelect;
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: documentos.length,
                                      itemBuilder: (context, index) {
                                        final event = documentos[index];
                                        return SizedBox(
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
                                                   Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              event.pvPropiedadDireccion ?? "",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: titleFontSize,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                              ),
                                                            ),
                                                            Text(
                                                              event.pvPropiedadDescripcion ?? "",
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: subtitleFontSize,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.all(6),
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromRGBO(237, 237, 237, 1),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              "Total ${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol(event.pmValor!)}",
                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: subtitleFontSize,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Container(
                                                            padding: const EdgeInsets.all(6),
                                                            decoration: BoxDecoration(
                                                              color: const Color.fromRGBO(237, 237, 237, 1),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              "Pendiente ${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol(event.pmValorPendiente!)}",
                                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: subtitleFontSize,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Card(
                                                    color: const Color.fromRGBO(237, 237, 237, 1),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(12),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:  [
                                                              Text("TIPO",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: titleFontSize
                                                              )),
                                                              Text("SERIE",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: titleFontSize
                                                              )),
                                                              Text(
                                                                  "NÚMERO",
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                      fontSize: titleFontSize)),
                                                              Text("UUID",style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: titleFontSize
                                                              )),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  event.pvDocumentoTipoDescripcion ?? "",
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey[500],
                                                                    fontSize: titleFontSize
                                                                )
                                                                ),
                                                                Text(
                                                                  event.pvSerie ?? "",
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,style: theme.textTheme.headlineSmall?.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey[500],
                                                                    fontSize: titleFontSize
                                                                ),
                                                                ),

                                                                Text(
                                                                    event.pvNumero ?? "",
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey[500],
                                                                        fontSize: titleFontSize)),
                                                                AutoSizeText(
                                                                  event.pvUuid ?? "",
                                                                  maxLines: 1,
                                                                  minFontSize: titleFontSize*0.5.floor(),style: theme.textTheme.headlineSmall?.copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey[500],
                                                                    fontSize: titleFontSize
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "NOMBRE",
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                            color:Color.fromRGBO(167,167,132,1),
                                                                        fontSize: titleFontSize)),
                                                                    Text(
                                                                      event.pvNombre ?? "",
                                                                        softWrap: true,
                                                                        overflow: TextOverflow.visible,
                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey[500],
                                                                        fontSize: titleFontSize)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "NIT",
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                          fontWeight: FontWeight.bold,
                                                                              color:Color.fromRGBO(167,167,132,1),
                                                                          fontSize: titleFontSize)
                                                                          ),
                                                                    Text(
                                                                      event.pvNit ?? "",
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,style: theme.textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.grey[500],
                                                                      fontSize: titleFontSize)
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                        )
                                                      )
                                                    ),
                                                  const SizedBox(height: 8),
                                                   Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          IconButton(onPressed: ()
                                                          {
                                                            debugPrint("Boton1");
                                                            showDialog<void>(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: const Text('Detalles de cobro'),
                                                                  content: SingleChildScrollView(
                                                                    scrollDirection: Axis .vertical,
                                                                    child: Column(
                                                                      children: [
                                                                        Title(color: Colors.black, child: Text(
                                                                          'Detalle de Cobro Doc ${event.pnDocumento}',
                                                                        ),),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                                "Tipo",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                            Text(
                                                                                event.pvDocumentoTipoDescripcion!,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                                "Propiedad",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),

                                                                            Text(
                                                                                event.pvPropiedadDescripcion!,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                                "Dirección",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                            SizedBox(
                                                                              width: constraints.maxWidth*0.35,
                                                                              child: Text(
                                                                                  event.pvPropiedadDireccion!,
                                                                                  maxLines: 4,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                                      fontSize: titleFontSize)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                                "Fecha",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                            Text(DateFormat('yyyyMMdd').format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color:Color.fromRGBO(167,167,132,1),
                                                                              fontSize: constraints.maxWidth * 0.03,
                                                                            ),maxLines: 2,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                                "Nombre",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                            SizedBox(
                                                                              width: constraints.maxWidth*0.35,
                                                                              child: Text(
                                                                                   event.pvNombre!,
                                                                                  maxLines: 3,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                                      fontSize: titleFontSize)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text("Detalle",
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: theme.textTheme.headlineSmall?.copyWith(
                                                                                fontWeight: FontWeight.bold,
                                                                                color:Color.fromRGBO(167,167,132,1),
                                                                                fontSize: titleFontSize)),
                                                                        Card(
                                                                          elevation: 3,
                                                                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                                            color:Color.fromRGBO(167,167,132,1),
                                                                          child: Padding(
                                                                          padding: const EdgeInsets.all(8),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Center(
                                                                                child: Text("Descripción",maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color:Colors.white,
                                                                                        fontSize: titleFontSize)),
                                                                              ),
                                                                              Center(
                                                                                child: Text("Cantidad",maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color:Colors.white,
                                                                                        fontSize: titleFontSize)),
                                                                              ),
                                                                              Center(),
                                                                            ],
                                                                            )
                                                                          )
                                                                        ),
                                                                        Column(
                                                                          children: event.plDetalle.map((detalle) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 4.0), // spacing between rows
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: constraints.maxWidth * 0.25,
                                                                                    child: Text(
                                                                                      detalle.pvDescripcion ?? "",
                                                                                      maxLines: 4,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.grey[600],
                                                                                        fontSize: titleFontSize,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text("Cantidad:",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text("Cobro:",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text("Descuento:",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text("Subtotal:",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Text(detalle.pmCantidad?.toString() ?? "",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text(detalle.pmPrecio?.toString() ?? "",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text(detalle.pmDescuento?.toString() ?? "",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                      SizedBox(
                                                                                        height: constraints.maxWidth * 0.01,
                                                                                      ),
                                                                                      Text(detalle.pmSubtotal?.toString() ?? "",
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: Colors.grey[600],
                                                                                            fontSize: titleFontSize,
                                                                                          )),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        )
                                                                      ],
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
                                                              },
                                                            );
                                                          },
                                                            icon: Icon(Icons.menu,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.05),),
                                                          Text("ver detalle",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                                fontSize: constraints.maxWidth * 0.03,
                                                              )),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(onPressed: () async{
                                                            debugPrint("Boton2");
                                                            debugPrint(event.pvVerCobro.toString());
                                                            if(event.pnPermiteVerCobro == 1)
                                                              {
                                                                final rawUrl =  event.pvVerCobro!;
                                                                final uri = Uri.tryParse(rawUrl);
                                                                final safeUri = uri ?? Uri.parse(Uri.encodeFull(rawUrl));
                                                                if (await canLaunchUrl(safeUri)) {
                                                                  await launchUrl(safeUri, mode: LaunchMode.externalApplication);
                                                                }
                                                                else
                                                                {
                                                                  debugPrint("Could not launch $safeUri");
                                                                }
                                                              }
                                                            else
                                                            {
                                                              msgxToast("No se puede ver cobro");
                                                            }
                                                          }, icon: Icon(Icons.print,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.05),),
                                                          Text("Imprimir",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                                fontSize: constraints.maxWidth * 0.03,
                                                              )),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(onPressed: (){
                                                            debugPrint("Boton3");
                                                            showDialog<void>(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: const Text('Detalle de pago'),
                                                                  content: Column(
                                                                    children: [
                                                                      Title(color: Colors.black, child: Text(
                                                                        'Detalle de Pagos Doc ${event.pnDocumento}',
                                                                      ),),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              "Tipo",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),
                                                                          Text(
                                                                              event.pvDocumentoTipoDescripcion!,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              "Propiedad",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),

                                                                          Text(
                                                                              event.pvPropiedadDescripcion!,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              "Dirección",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),
                                                                          SizedBox(
                                                                            width: constraints.maxWidth*0.35,
                                                                            child: Text(
                                                                                event.pvPropiedadDireccion!,
                                                                                maxLines: 4,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              "Nombre",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),
                                                                          SizedBox(
                                                                            width: constraints.maxWidth*0.35,
                                                                            child: Text(
                                                                                event.pvNombre!,
                                                                                maxLines: 3,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: theme.textTheme.headlineSmall?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color:Color.fromRGBO(167,167,132,1),
                                                                                    fontSize: titleFontSize)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text("Detalle",
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                              color:Color.fromRGBO(167,167,132,1),
                                                                              fontSize: titleFontSize)),
                                                                      Card(
                                                                          elevation: 3,
                                                                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.all(8),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Center(
                                                                                    child: Text("Descripción",maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color:Colors.white,
                                                                                            fontSize: titleFontSize)),
                                                                                  ),
                                                                                  Center(
                                                                                    child: Text("Cantidad",maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color:Colors.white,
                                                                                            fontSize: titleFontSize)),
                                                                                  ),
                                                                                  Center(),
                                                                                ],
                                                                              )
                                                                          )
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Center(),
                                                                          Center(),
                                                                          Center(),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                              "Total Pagado:",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: titleFontSize)),
                                                                          Text("${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol((event.pmValorPendiente! - event.pmValor!).abs())}",style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color:Color.fromRGBO(167,167,132,1),
                                                                            fontSize: constraints.maxWidth * 0.03,
                                                                          ),maxLines: 2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
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
                                                              },
                                                            );
                                                            }, icon: Icon(Icons.money_sharp,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.05),),
                                                          Text("Pagos",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                                fontSize: constraints.maxWidth * 0.03,
                                                              )),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                       event.pnPermiteAplicaPago == 1 ? IconButton(onPressed: (){
                                                            debugPrint("Boton4");

                                                            setState(() {
                                                              formaPagoController.text = formaPago[0].toString();
                                                              montoPagarController.text = "${event.pmValorPendiente!}";
                                                              fechaPagoController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
                                                            });
                                                            showDialog<void>(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return StatefulBuilder(
                                                                    builder: (BuildContext context, StateSetter setStateDialog) {
                                                                    return AlertDialog(
                                                                      title: const Text('Aplicar Pago'),
                                                                      content: SingleChildScrollView(
                                                                        scrollDirection: Axis .vertical,
                                                                        child: Form(
                                                                          key: _formKey1,
                                                                          child: Column(
                                                                            children: [
                                                                              Title(color: Colors.black, child: Text(
                                                                                'Detalle de pago Doc ${event.pnDocumento}',
                                                                              ),),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                      "Tipo",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),
                                                                                  Text(
                                                                                      event.pvDocumentoTipoDescripcion!,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                      "Propiedad",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),

                                                                                  Text(
                                                                                      event.pvPropiedadDescripcion!,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),
                                                                                  Text(
                                                                                      event.pnDocumento.toString()!,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                      "Dirección",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),
                                                                                  SizedBox(
                                                                                    width: constraints.maxWidth*0.35,
                                                                                    child: Text(
                                                                                        event.pvPropiedadDireccion!,
                                                                                        maxLines: 4,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color:Color.fromRGBO(167,167,132,1),
                                                                                            fontSize: titleFontSize)),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                      "Nombre",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color:Color.fromRGBO(167,167,132,1),
                                                                                          fontSize: titleFontSize)),
                                                                                  SizedBox(
                                                                                    width: constraints.maxWidth*0.35,
                                                                                    child: Text(
                                                                                        event.pvNombre!,
                                                                                        maxLines: 3,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: theme.textTheme.headlineSmall?.copyWith(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color:Color.fromRGBO(167,167,132,1),
                                                                                            fontSize: titleFontSize)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Text("Detalle",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                                      fontSize: titleFontSize)),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Text(
                                                                                    "Total ${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol(event.pmValor!)}",
                                                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: subtitleFontSize,
                                                                                      color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Pendiente ${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol(event.pmValorPendiente!)}",
                                                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: subtitleFontSize,
                                                                                      color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Card(
                                                                                  elevation: 3,
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                                                  color:Colors.white,
                                                                                  child: Padding(
                                                                                      padding: const EdgeInsets.all(8),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text("Monto a pagar (Q)",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                                                  fontSize: titleFontSize)),
                                                                                          10.height,
                                                                                          TextFormField(
                                                                                            validator: (String? value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Información requerida'; // Error message if empty
                                                                                              }
                                                                                              return null; // Return null if the input is valid
                                                                                            },
                                                                                            keyboardType: TextInputType.number,
                                                                                            textInputAction: TextInputAction.next,
                                                                                            controller: montoPagarController,
                                                                                            showCursor: false,
                                                                                            decoration: const InputDecoration(
                                                                                              border: OutlineInputBorder(),
                                                                                            ),
                                                                                            onChanged: (value)
                                                                                            {
                                                                                              setStateDialog(() {
                                                                                                montoPagarController.text = value;
                                                                                              });
                                                                                            },
                                                                                          ),
                                                                                          10.height,
                                                                                          Text("Forma de pago ",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                                                  fontSize: titleFontSize)),
                                                                                          10.height,
                                                                                          DropdownButtonFormField<String>(
                                                                                            validator: (String? value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Información requerida'; // Error message if empty
                                                                                              }
                                                                                              return null; // Return null if the input is valid
                                                                                            },
                                                                                            isExpanded: true,
                                                                                            value: formaPago[0].toString(),
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
                                                                                            items: List.generate(formaPago.length, (index) {
                                                                                              return DropdownMenuItem<String>(
                                                                                                value: formaPago[index].toString(),
                                                                                                child: Text(
                                                                                                  "${formapagoDescirpcion[index]}",
                                                                                                  style: const TextStyle(

                                                                                                    color: Colors.black,
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            }),
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                int indexB = formaPago.indexOf(value!);
                                                                                                debugPrint(indexB.toString());
                                                                                                debugPrint(formaPago[indexB].toString());
                                                                                                formaPagoController.text =formaPago[indexB].toString();
                                                                                                //formaPagoController.text = formapagoDescirpcion[index];
                                                                                              });
                                                                                            },
                                                                                          ),
                                                                                          10.height,
                                                                                          Text("Fecha de pago ",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                                                  fontSize: titleFontSize)),
                                                                                          10.height,
                                                                                          TextFormField(
                                                                                            validator: (String? value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Información requerida'; // Error message if empty
                                                                                              }
                                                                                              return null; // Return null if the input is valid
                                                                                            },
                                                                                            textInputAction: TextInputAction.next,
                                                                                            controller: fechaPagoController,
                                                                                            readOnly: true,
                                                                                            onTap: () async {
                                                                                                fechaSelect = await showDatePicker(
                                                                                                context: context,
                                                                                                initialDate: DateTime.now(),
                                                                                                firstDate: DateTime(2000),
                                                                                                lastDate: DateTime(3000),
                                                                                                builder: (BuildContext context, Widget? child) {
                                                                                                  return Theme(
                                                                                                    data: Theme.of(context).copyWith(
                                                                                                      colorScheme: ColorScheme.light(
                                                                                                        primary: const Color.fromRGBO(6, 78, 116, 1),
                                                                                                      ),
                                                                                                      textButtonTheme: TextButtonThemeData(
                                                                                                        style: TextButton.styleFrom(
                                                                                                          textStyle:theme.textTheme.bodyMedium?.copyWith(
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            fontSize: MediaQuery.of(context).size.width*0.035,
                                                                                                            color: Color.fromRGBO(6,78,116,1),
                                                                                                          ),
                                                                                                          minimumSize: Size(1.5 ,1.5),
                                                                                                          foregroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: child!,
                                                                                                  );
                                                                                                },
                                                                                              );

                                                                                              if (fechaSelect != null) {
                                                                                                setState(() {
                                                                                                  // Format as yyyy-MM-dd
                                                                                                  fechaPagoController.text =DateFormat('dd/MM/yyyy').format(fechaSelect!).toString();
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                            decoration: InputDecoration(
                                                                                              labelText: 'Fecha de pago',
                                                                                              border: OutlineInputBorder(),
                                                                                            ),
                                                                                          ),
                                                                                          10.height,
                                                                                          Text("No. de Autorización",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                                                  fontSize: titleFontSize)),
                                                                                          10.height,
                                                                                          TextFormField(
                                                                                            validator: (String? value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Información requerida'; // Error message if empty
                                                                                              }
                                                                                              return null; // Return null if the input is valid
                                                                                            },
                                                                                            keyboardType: TextInputType.number,
                                                                                            textInputAction: TextInputAction.next,
                                                                                            controller: numeroAutorizacionController,
                                                                                            showCursor: false,
                                                                                            decoration: const InputDecoration(
                                                                                              border: OutlineInputBorder(),

                                                                                            ),
                                                                                            onChanged: (value)
                                                                                            {
                                                                                              setStateDialog(() {
                                                                                                numeroAutorizacionController.text = value;
                                                                                              });
                                                                                            },
                                                                                          ),
                                                                                          10.height,
                                                                                          Text("Fotografia de Pago",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Color.fromRGBO(6, 78, 116, 1),
                                                                                                  fontSize: titleFontSize)),
                                                                                          10.height,
                                                                                          Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                                                                      // set the background color
                                                                                              ),
                                                                                              onPressed: () async{
                                                                                                msgxToast("Cargando imagen...");
                                                                                                final regresarIamgenSelect = await ImagePicker().pickImage(
                                                                                                    source: ImageSource.gallery);
                                                                                                setStateDialog(() {
                                                                                                  if (regresarIamgenSelect == null) return;
                                                                                                  iamgenSelect = File(regresarIamgenSelect.path);
                                                                                                });
                                                                                                //_PickGalery();
                                                                                                //Navigator.of(context).pop();
                                                                                              },
                                                                                              child: Text(
                                                                                                "Elegir Fotografía de Galería",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Colors.white,
                                                                                                  fontSize: constraints.maxWidth * 0.03,
                                                                                                ),
                                                                                              ),),
                                                                                          ),

                                                                                          iamgenSelect != null ? SizedBox(
                                                                                            height: constraints.maxWidth*0.4,
                                                                                            width: constraints.maxWidth*0.4,
                                                                                            child: Image.file(iamgenSelect!),
                                                                                          ) : const Text("Puede seleccionar una opcion"),
                                                                                          10.height,
                                                                                          Container(
                                                                                            padding: const EdgeInsets.all(10),
                                                                                            child: ElevatedButton(

                                                                                              style: ElevatedButton.styleFrom(
                                                                                                backgroundColor: Color.fromRGBO(6, 78, 116, 1), // set the background color
                                                                                              ),
                                                                                              onPressed: () async{

                                                                                                if (!_formKey1.currentState!.validate()) {
                                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                                    const SnackBar(
                                                                                                      content: Text("Por favor complete todos los campos requeridos."),
                                                                                                    ),
                                                                                                  );
                                                                                                  return;
                                                                                                }
                                                                                                if(iamgenSelect != null)
                                                                                             {
                                                                                              File imageFile = File(iamgenSelect!.path);
                                                                                              List<int> imageBytes = await imageFile.readAsBytes();
                                                                                              setStateDialog(() {
                                                                                                base64Image = base64Encode(imageBytes);
                                                                                              });
                                                                                            }

                                                                                            //msgxToast("Cargando imagen...");
                                                                                                debugPrint("Cargando imagen...");
                                                                                                debugPrint(montoPagarController.text);
                                                                                                DateTime fecha = DateFormat('dd/MM/yyyy').parse(fechaPagoController.text);
                                                                                                String formattedDate = DateFormat('yyyyMMdd').format(fecha);
                                                                                                debugPrint(fechaPagoController.text);
                                                                                                debugPrint(formattedDate);
                                                                                                debugPrint(numeroAutorizacionController.text);
                                                                                                debugPrint(formaPagoController.text);
                                                                                                debugPrint(base64Image.toString());
                                                                                                makeApiCall(event.pnDocumento.toString(),montoPagarController.text,formaPagoController.text,
                                                                                                    formattedDate,numeroAutorizacionController.text,base64Image.toString(),"-1");

                                                                                              },
                                                                                              child: Text(
                                                                                                "Realizar pago",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color:   Colors.white,
                                                                                                  fontSize: constraints.maxWidth * 0.03,
                                                                                                ),
                                                                                              ),),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                  )
                                                                              ),

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
                                                          }, icon: Icon(Icons.account_balance_wallet_rounded,
                                                              color: const Color.fromRGBO(6, 78, 116, 1),
                                                              size: constraints.maxWidth * 0.05),
                                                          ):Center(),
                                                          event.pnPermiteAplicaPago == 1 ?  Text("Aplicar Pagos",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: const Color.fromRGBO(6, 78, 116, 1),
                                                                fontSize: constraints.maxWidth * 0.03,
                                                              )):Center(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                            17.height,
                              Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              color: Colors.green,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.12,
                                child: Column(
                                  children: [
                                    Title(color: Colors.black, child: Text("Instrucciones de pago",style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.width * 0.040,

                                    ),),),
                                    Wrap(
                                      alignment: WrapAlignment.center, // centers the items horizontally
                                      spacing: 8, // space between items
                                      runSpacing: 4, // space between lines when wrapping
                                      children: pago.map((String text) {
                                        return Text(
                                          text,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context).size.width * 0.040,
                                            color: Colors.white,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ) ,
                            17.height,
                             Text("Información Importante",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )),
                            17.height,
                              FutureBuilder(future: _futureInfo,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return  Center(
                                      child: Title(color: Color.fromRGBO(6,78,116,1),
                                        child: Text("No hay contactos creados",style: theme.textTheme.bodyMedium?.copyWith(
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
                                        child: Text("No hay contactos creados",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      ));
                                }
                                final events = snapshot.data!;
                                //debugPrint(events.toString());
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.2,
                                  child: LayoutBuilder(
                                  builder: (context, constraints) {

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: events.length,
                                      itemBuilder: (context, index) {
                                        final event = events[index];
                                        return Container(
                                            width: constraints.maxWidth*0.8,
                                            height: constraints.maxHeight*0.4,
                                            child: Card(
                                                color: Color.fromRGBO(6,78,116,1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      event["pn_tipo_contacto"].toString() == "1"? Icon(
                                                        FontAwesomeIcons.phone,
                                                        size: constraints.maxWidth * 0.1,
                                                        color:  cardColorsB[index],
                                                      ):Icon(Icons.mail_outline,
                                                        size: constraints.maxWidth * 0.1,
                                                        color:  cardColorsB[index],
                                                      ),
                                                      10.width,
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(event["pv_descripcion"].toString(),style: TextStyle(
                                                            fontSize: constraints.maxWidth * 0.035,
                                                            color: Colors.white,
                                                          ),
                                                          ),

                                                          Text(event["pv_detalle"].toString(),style: TextStyle(
                                                            fontSize: constraints.maxWidth * 0.035,
                                                            color: Colors.white,
                                                          ),)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            )
                                        );
                                      },
                                    );
                                  }
                                  ),
                                );
                              },
                            ),
                            17.height,
                             Text("Noticias y Avisos",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )),

                            17.height,
                              FutureBuilder(
                              future: _futureNoticias,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError ||
                                    !snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
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

                                        // 🔹 Unique key for each carousel
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
                                                // 🖼 Carousel section
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
                                                          return ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.memory(
                                                              bytes,
                                                              fit: BoxFit.cover,
                                                              width: double.infinity,
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

                                                const SizedBox(height: 12),

                                                // 📰 Title
                                                Text(
                                                  event["pv_descripcion"].toString(),
                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromRGBO(167, 167, 132, 1),
                                                    fontSize: titleFontSize,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),

                                                if (event["pl_comentarios"] != null &&
                                                    event["pl_comentarios"].isNotEmpty)
                                                  Text(
                                                    event["pl_comentarios"][0]["pv_descripcion"].toString(),
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
                            ) ,
                            17.height,
                              Text("Objetos Perdidos",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )) ,
                            17.height,
                              FutureBuilder(
                              future: _futurePerdidos,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError ||
                                    !snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "No se han reportado objetos perdidos",
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.035,
                                        color: const Color.fromRGBO(6, 78, 116, 1),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }

                                final events = snapshot.data!;
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    double width = constraints.maxWidth;

                                    // 🧮 Always at least 2 columns
                                    int crossAxisCount;
                                    if (width > 1000) {
                                      crossAxisCount = 4;
                                    } else if (width > 700) {
                                      crossAxisCount = 3;
                                    } else {
                                      crossAxisCount = 2; // 👈 minimum 2
                                    }

                                    // 📐 Calcular relación de aspecto dinámica
                                    //   aspectRatio = width / height → menor valor = más alta
                                    //   Ajustamos para que el contenido no se vea estirado
                                    double cardWidth = width / crossAxisCount;
                                    double cardHeight;

                                    // 💡 Estimar altura según contenido típico
                                    if (cardWidth > 500) {
                                      cardHeight = cardWidth * 1.5;
                                    } else if (cardWidth > 300) {
                                      cardHeight = cardWidth * 1.7;
                                    } else {
                                      cardHeight = cardWidth * 2.2;
                                    }

                                    double aspectRatio = cardWidth / cardHeight;

                                    return GridView.builder(
                                      itemCount: events.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: aspectRatio, // ✅ correcto y dinámico
                                      ),
                                      itemBuilder: (context, index) {
                                        final event = events[index];

                                        return Card(
                                          elevation: 4,
                                          shape:
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: GestureDetector(
                                                    onTap: () => showImageDialog3(
                                                      context,
                                                      event["pl_fotografias"][0]["pv_fotografiab64"].toString(),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.memory(
                                                        base64Decode(
                                                          event["pl_fotografias"][0]["pv_fotografiab64"]
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      AutoSizeText(
                                                        event["pv_descripcion"].toString(),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 3,
                                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: const Color.fromRGBO(6, 78, 116, 1),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      AutoSizeText(
                                                        event["pn_permite_reclamar"] == "1"
                                                            ? "No Reclamada"
                                                            : "Reclamada",
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: event["pn_permite_reclamar"] == "1"
                                                              ? Colors.red[900]
                                                              : Colors.yellow[800],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      AutoSizeText(
                                                        "Reportado el ${DateFormat('dd MMM yyyy', "es_ES").format(
                                                          DateTime.parse(event["pf_fecha"].toString()),
                                                        )}",
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
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
                            ) ,
                          17.height,
                             Text("Rentas y Ventas",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )),
                            17.height,
                             FutureBuilder<List<RentaVentaD5>>(
                              future:_futureRentas,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return  Center(
                                      child: Title(color: Color.fromRGBO(6,78,116,1),
                                        child: Text("No existen rentas y ventas",style: theme.textTheme.bodyMedium?.copyWith(
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
                                        child: Text("No existen rentas y ventas",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.035,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      )
                                  );
                                }
                                final documentos = snapshot.data!;
                                return LayoutBuilder(
                                  builder: (context, constraints) {

                                    double w = constraints.maxWidth;
                                    double h = constraints.maxHeight;

                                    double scale(double value) => w * value;

                                    return ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: documentos.length,
                                      itemBuilder: (context, index) {

                                        final event = documentos[index];
                                        final images = event.plFotografias
                                            ?.where((f) => f.pvFotografiab64 != null && f.pvFotografiab64!.isNotEmpty)
                                            .map((f) => f.pvFotografiab64!)
                                            .toList() ?? [];

                                        _controllers.putIfAbsent(index, () => CarouselSliderController());
                                        _currentIndex[index] = _currentIndex[index] ?? 0;

                                        return Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            event.pvRentaTipoDescripcion ?? "",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                              fontSize: scale(0.045), // dinámico
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey[700],
                                                            ),
                                                          ),
                                                          Text(
                                                            "${event.pvMonedaSimbolo} ${formatMoneyWithoutSymbol(event.pmValor!)}",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                              fontSize: scale(0.045),
                                                              fontWeight: FontWeight.bold,
                                                              color: const Color.fromRGBO(167, 167, 132, 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                                    ],
                                                  ),

                                                  Card(
                                                    elevation: 3,
                                                    color: const Color.fromRGBO(6, 78, 116, 1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          // Columna Izquierda
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("FECHA DE PUBLICACIÓN",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                    fontSize: scale(0.03),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  )),
                                                              Text("DATOS DE CONTACTO",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                    fontSize: scale(0.03),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  )),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                DateFormat('dd MMMM yyyy', "es_ES")
                                                                    .format(DateTime.parse(event.pfFecha.toString())),
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                  fontSize: scale(0.025),
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                ),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Text(event.pvContacto ?? "",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                    fontSize: scale(0.025),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  ),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                    elevation: 3,
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          // Columna Izquierda
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("DETALLE",
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                    fontSize: scale(0.03),
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.grey[700],
                                                                  )),
                                                              Text(event.pvDetalleRenta ?? "",
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                  fontSize: scale(0.025),
                                                                  fontWeight: FontWeight.bold,
                                                                  color: const Color.fromRGBO(167, 167, 132, 1),
                                                                ),
                                                                maxLines: 3,

                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
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
                            ) ,
                            17.height,
                             Text("Amenidades Reservadas",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )) ,
                            17.height,
                             Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(onPressed:()
                                              async {
                                                setState(() {
                                                  reloadreserva();
                                                });
                                              },
                                                  icon: Icon(AntDesign.reload_outline,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.06,)),
                                              Text("Actualizar Reservas",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:MediaQuery.of(context).size.width*0.04,
                                                  color:Color.fromRGBO(167,167,132,1))),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(onPressed:()
                                              {
                                                Get.to(AdmCreacionReservaScreen());
                                              },
                                                  icon: Icon(BoxIcons.bx_calendar_check,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.07,)),

                                              Text("Crear Reserva",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                                  color:Color.fromRGBO(167,167,132,1))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ) ,
                            /*Card(
                              elevation: 3,
                              color:Color.fromRGBO(6,78,116,1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Propiedad ",style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white,
                                      fontSize: MediaQuery.of(context).size.width * 0.03,
                                    )
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text("Amenidad",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      )
                                      ),
                                    ),
                                    Text("costo ",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      )
                                      ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text("Fecha del evento",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ),maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text("Estado",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      )
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text("Acciones",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),*/

                             FutureBuilder<List<ReservasF5>>(
                              future: _futureReservas,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return   Center(

                                      child: Title(color: Color.fromRGBO(6,78,116,1),
                                        child: Text("No hay amenidades reservadas",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.05,
                                          color: Color.fromRGBO(6,78,116,1),
                                        ),
                                        ),
                                      )
                                  );
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return   Center(
                                      child: Title(color: Color.fromRGBO(6,78,116,1),
                                        child: Text("No hay amenidades reservadas",style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width*0.05,
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
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: documentos.length,
                                      itemBuilder: (context, index) {
                                        final event = documentos[index];
                                        DateTime? fechaSelectB;
                                        return Container(
                                          width: constraints.maxWidth,

                                          child: Card(
                                            elevation: 3,
                                            color:Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: constraints.maxWidth* 0.4,
                                                            child: ListTile(
                                                              title: Text("Propiedad",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                fontSize: constraints.maxWidth * 0.05,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize:constraints.maxWidth* 0.035,
                                                              )
                                                              ),
                                                            )
                                                          ),

                                                          SizedBox(
                                                            width:constraints.maxWidth*0.4,
                                                            child: ListTile(
                                                              title: Text("Amenidad",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                fontSize: constraints.maxWidth* 0.05,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvAmenidadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize: constraints.maxWidth * 0.035,
                                                              ),maxLines: 2,
                                                              ),
                                                            )
                                                          ),
                                                          SizedBox(
                                                              width:constraints.maxWidth* 0.4,
                                                              child: ListTile(
                                                                title: Text("Costo",style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth * 0.05,
                                                                )
                                                                ),
                                                                subtitle: Text(event.pvMonedaSimbolo! + event.pmValor!.toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(6,78,116,1),
                                                                  fontSize: constraints.maxWidth * 0.035,
                                                                )
                                                                ),
                                                              )
                                                          ),

                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          SizedBox(
                                                              width:constraints.maxWidth* 0.4,
                                                              child: ListTile(
                                                                title:Text("Fecha",style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth * 0.05,
                                                                )
                                                                ),
                                                                subtitle: Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(6,78,116,1),
                                                                  fontSize: constraints.maxWidth * 0.035,
                                                                ),maxLines: 2,
                                                                ),
                                                              )
                                                          ),
                                                          SizedBox(
                                                            width:constraints.maxWidth* 0.4,
                                                            child: ListTile(
                                                              title: Text("Estado",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,color:Color.fromRGBO(6,78,116,1),
                                                                fontSize: constraints.maxWidth * 0.05,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvEstadoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:event.pvEstadoDescripcion == "No Autorizada" ? Colors.pink[900]:Colors.amber[600],
                                                                fontSize: constraints.maxWidth * 0.035,
                                                              )
                                                              ),
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      event.pnPermiteAplicarPago == 1 ? IconButton(onPressed:()
                                                      {
                                                        DateTime? fechaSelect;
                                                        //pago de amenidad
                                                      setState(() {
                                                        montoPagarControllerB.text = "${event.pmValor!}";
                                                        fechaPagoController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                                                        formaPagoController.text =formaPago[0].toString();
                                                      });
                                                         showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext context, StateSetter setStateDialog) {
                                                                return AlertDialog(
                                                                  title: const Text('Aplicar Pago'),
                                                                  content: SingleChildScrollView(
                                                                    scrollDirection: Axis .vertical,
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      child: Column(
                                                                        children: [
                                                                          Title(color: Colors.black, child: Text(
                                                                            'Detalle de pago Doc ${event.pnDocumento}',
                                                                          ),),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                  "Tipo",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.045)),

                                                                            ],
                                                                          ),
                                                                          Text(
                                                                              "Propiedad",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                          Text(
                                                                              event.pvPropiedadDescripcion!,
                                                                              maxLines: 3,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                          Text(
                                                                              event.pnDocumento.toString()!,
                                                                              maxLines: 3,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                  "Amenidad",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: theme.textTheme.headlineSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color:Color.fromRGBO(167,167,132,1),
                                                                                      fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                              SizedBox(
                                                                                width: constraints.maxWidth*0.35,
                                                                                child: Text(
                                                                                    event.pvAmenidadDescripcion!,
                                                                                    maxLines: 4,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color:Color.fromRGBO(167,167,132,1),
                                                                                        fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Text("Detalle",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text(
                                                                                "Total ${event.pvMonedaSimbolo}${formatMoneyWithoutSymbol(event.pmValor!)}",
                                                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Card(
                                                                              elevation: 3,
                                                                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                                              color:Colors.white,
                                                                              child: Padding(
                                                                                  padding: const EdgeInsets.all(8),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Text("Monto a pagar (Q)",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(6, 78, 116, 1),
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                                      10.height,
                                                                                      TextFormField(
                                                                                        validator: (String? value) {
                                                                                          if (value == null || value.isEmpty) {
                                                                                            return 'Información requerida'; // Error message if empty
                                                                                          }
                                                                                          return null; // Return null if the input is valid
                                                                                        },
                                                                                        keyboardType: TextInputType.number,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        controller: montoPagarControllerB,
                                                                                        showCursor: false,
                                                                                        decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                        onChanged: (value)
                                                                                        {
                                                                                          setStateDialog(() {
                                                                                            montoPagarControllerB.text = value;
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      10.height,
                                                                                      Text("Forma de pago ",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(6, 78, 116, 1),
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                                      10.height,
                                                                                      DropdownButtonFormField<String>(
                                                                                        validator: (String? value) {
                                                                                          if (value == null || value.isEmpty) {
                                                                                            return 'Información requerida'; // Error message if empty
                                                                                          }
                                                                                          return null; // Return null if the input is valid
                                                                                        },
                                                                                        isExpanded: true,
                                                                                        value: formaPago[0].toString(),
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
                                                                                        items: List.generate(formaPago.length, (index) {
                                                                                          return DropdownMenuItem<String>(
                                                                                            value: formaPago[index].toString(),
                                                                                            child: Text(
                                                                                              "${formapagoDescirpcion[index]}",
                                                                                              style: const TextStyle(

                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }),
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            int indexB = formaPago.indexOf(value!);
                                                                                            debugPrint(indexB.toString());
                                                                                            debugPrint(formaPago[indexB].toString());
                                                                                            formaPagoController.text =formaPago[indexB].toString();
                                                                                            //formaPagoController.text = formapagoDescirpcion[index];
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      10.height,
                                                                                      Text("Fecha de pago ",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(6, 78, 116, 1),
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                                      10.height,
                                                                                      TextFormField(
                                                                                        validator: (String? value) {
                                                                                          if (value == null || value.isEmpty) {
                                                                                            return 'Información requerida'; // Error message if empty
                                                                                          }
                                                                                          return null; // Return null if the input is valid
                                                                                        },
                                                                                        textInputAction: TextInputAction.next,
                                                                                        controller: fechaPagoController,
                                                                                        readOnly: true,
                                                                                        onTap: () async {
                                                                                          fechaSelect = await showDatePicker(
                                                                                            context: context,
                                                                                            initialDate: DateTime.now(),
                                                                                            firstDate: DateTime(2000),
                                                                                            lastDate: DateTime(3000),
                                                                                            builder: (BuildContext context, Widget? child) {
                                                                                              return Theme(
                                                                                                data: Theme.of(context).copyWith(
                                                                                                  colorScheme: ColorScheme.light(
                                                                                                    primary: const Color.fromRGBO(6, 78, 116, 1),
                                                                                                  ),
                                                                                                  textButtonTheme: TextButtonThemeData(
                                                                                                    style: TextButton.styleFrom(
                                                                                                      textStyle:theme.textTheme.bodyMedium?.copyWith(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontSize: MediaQuery.of(context).size.width*0.035,
                                                                                                        color: Color.fromRGBO(6,78,116,1),
                                                                                                      ),
                                                                                                      minimumSize: Size(1.5 ,1.5),
                                                                                                      foregroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                child: child!,
                                                                                              );
                                                                                            },
                                                                                          );

                                                                                          if (fechaSelect != null) {
                                                                                            setState(() {
                                                                                              // Format as yyyy-MM-dd
                                                                                              fechaPagoController.text = DateFormat('dd/MM/yyyy').format(fechaSelect!).toString();
                                                                                            });
                                                                                          }
                                                                                        },
                                                                                        decoration: InputDecoration(
                                                                                          labelText: 'Fecha de pago',
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                      ),
                                                                                      10.height,
                                                                                      Text("No. de Autorización",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(6, 78, 116, 1),
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                                      10.height,
                                                                                      TextFormField(
                                                                                        validator: (String? value) {
                                                                                          if (value == null || value.isEmpty) {
                                                                                            return 'Información requerida'; // Error message if empty
                                                                                          }
                                                                                          return null; // Return null if the input is valid
                                                                                        },
                                                                                        keyboardType: TextInputType.number,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        controller: numeroAutorizacionController,
                                                                                        showCursor: false,
                                                                                        decoration: const InputDecoration(
                                                                                          border: OutlineInputBorder(),

                                                                                        ),
                                                                                        onChanged: (value)
                                                                                        {
                                                                                          setStateDialog(() {
                                                                                            numeroAutorizacionController.text = value;
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      10.height,
                                                                                      Text("Fotografia de Pago",
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color.fromRGBO(6, 78, 116, 1),
                                                                                              fontSize: MediaQuery.of(context).size.width * 0.045)),
                                                                                      10.height,
                                                                                      Container(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                                                            // set the background color
                                                                                          ),
                                                                                          onPressed: () async{
                                                                                            msgxToast("Cargando imagen...");
                                                                                            final regresarIamgenSelect = await ImagePicker().pickImage(
                                                                                                source: ImageSource.gallery);
                                                                                            setStateDialog(() {
                                                                                              if (regresarIamgenSelect == null) return;
                                                                                              iamgenSelect = File(regresarIamgenSelect.path);
                                                                                            });
                                                                                            //_PickGalery();
                                                                                            //Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            "Elegir Fotografía de Galería",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.white,
                                                                                              fontSize: constraints.maxWidth * 0.03,
                                                                                            ),
                                                                                          ),),
                                                                                      ),

                                                                                      iamgenSelect != null ? SizedBox(
                                                                                        height: constraints.maxWidth*0.4,
                                                                                        width: constraints.maxWidth*0.4,
                                                                                        child: Image.file(iamgenSelect!),
                                                                                      ) : const Text("Puede seleccionar una opcion"),
                                                                                      10.height,
                                                                                      Container(
                                                                                        padding: const EdgeInsets.all(10),
                                                                                        child: ElevatedButton(

                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: Color.fromRGBO(6, 78, 116, 1), // set the background color
                                                                                          ),
                                                                                          onPressed: () async{

                                                                                            if (!_formKey.currentState!.validate()) {
                                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                                const SnackBar(
                                                                                                  content: Text("Por favor complete todos los campos requeridos."),
                                                                                                ),
                                                                                              );
                                                                                              return;
                                                                                            }
                                                                                            if(iamgenSelect != null)
                                                                                            {
                                                                                              File imageFile = File(iamgenSelect!.path);
                                                                                              List<int> imageBytes = await imageFile.readAsBytes();
                                                                                              setStateDialog(() {
                                                                                                base64Image = base64Encode(imageBytes);
                                                                                              });
                                                                                            }

                                                                                            //msgxToast("Cargando imagen...");
                                                                                            debugPrint("Cargando imagen...");
                                                                                            debugPrint(event.pnDocumento.toString());
                                                                                            debugPrint(event.pnReserva.toString());
                                                                                            debugPrint(formaPagoController.text);
                                                                                            DateTime fecha = DateFormat('dd/MM/yyyy').parse(fechaPagoController.text);
                                                                                            String formattedDate = DateFormat('yyyyMMdd').format(fecha);
                                                                                            debugPrint(fechaPagoController.text);
                                                                                            debugPrint(formattedDate);
                                                                                            debugPrint(numeroAutorizacionController.text);
                                                                                            debugPrint(formaPagoController.text);
                                                                                            debugPrint(base64Image.toString());

                                                                                            makeApiCall(event.pnDocumento.toString(),montoPagarControllerB.text,
                                                                                                formaPagoController.text,formattedDate,numeroAutorizacionController.text,
                                                                                                base64Image.toString(),event.pnReserva.toString());
                                                                                            iamgenSelect = null;
                                                                                            base64Image ="" ;
                                                                                          },
                                                                                          child: Text(
                                                                                            "Realizar pago",
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color:   Colors.white,
                                                                                              fontSize: constraints.maxWidth * 0.03,
                                                                                            ),
                                                                                          ),),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                              )
                                                                          ),
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
                                                      },
                                                        icon: Icon(Icons.wallet,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.08),):Center(),
                                                      event.pnPermiteVerCobro == 1 ?  IconButton(onPressed: () async{
                                                        {
                                                          final rawUrl =  event.pvVerCobro!;
                                                          final uri = Uri.tryParse(rawUrl);
                                                          final safeUri = uri ?? Uri.parse(Uri.encodeFull(rawUrl));
                                                          if (await canLaunchUrl(safeUri)) {
                                                            await launchUrl(safeUri, mode: LaunchMode.externalApplication);
                                                          }
                                                          else
                                                          {
                                                            debugPrint("Could not launch $safeUri");
                                                          }
                                                        }
                                                      }, icon: Icon(Icons.print,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.08),):Center(),
                                                      event.pnPermiteVerPago == 1 ?  IconButton(onPressed: () async{
                                                        {
                                                          final rawUrl =  event.pvVerPago!;
                                                          final uri = Uri.tryParse(rawUrl);
                                                          final safeUri = uri ?? Uri.parse(Uri.encodeFull(rawUrl));
                                                          if (await canLaunchUrl(safeUri)) {
                                                            await launchUrl(safeUri, mode: LaunchMode.externalApplication);
                                                          }
                                                          else
                                                          {
                                                            debugPrint("Could not launch $safeUri");
                                                          }
                                                        }
                                                      }, icon: Icon(Icons.remove_red_eye,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.08),):Center(),
                                                     ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      event.pnPermiteAplicarPago == 1 ? Text("Aplicar pago",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )):Center(),

                                                      event.pnPermiteVerCobro == 1 ? Text("Ver cobro",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )):Center(),

                                                      event.pnPermiteVerPago == 1 ? Text("Ver Pago",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )):Center(),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                    event.pnPermiteAutorizar == 1 ?  IconButton(onPressed:()
                                                     async {
                                                       AutorizarClass(event.pnReserva.toString()).amenidadesReservadas7B();
                                                       setState(() async{
                                                         reloadreserva();
                                                         Navigator.of(context).pop();
                                                       });
                                                      },
                                                      icon: Icon(Icons.check_box_outlined,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.08),):Center(),

                                                      event.pnPermiteRechazar == 1 ?  IconButton(onPressed:()
                                                      async
                                                      {
                                                            showDialog<void>(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                            return StatefulBuilder(
                                                            builder: (
                                                            BuildContext context,
                                                            StateSetter setStateDialog) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Observaciones'),
                                                                content: SingleChildScrollView(
                                                                  scrollDirection: Axis .vertical,
                                                                  child: Form(
                                                                    key: _formKeyB,
                                                                    child: Column(
                                                                      children: [
                                                                        TextFormField(
                                                                          validator: (String? value) {
                                                                            if (value == null || value.isEmpty) {
                                                                              return 'Información requerida'; // Error message if empty
                                                                            }
                                                                            return null; // Return null if the input is valid
                                                                          },
                                                                          controller: observacionesRechazoController,
                                                                          onChanged: (value) {
                                                                            observacionesRechazoController.text = value;
                                                                          },
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      textStyle:theme.textTheme.bodyMedium?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: MediaQuery.of(context).size.width*0.065,
                                                                        backgroundColor: Color.fromRGBO(6,78,116,1),
                                                                      ),
                                                                    ),
                                                                    onPressed: () async{
                                                                      if (!_formKeyB.currentState!.validate()) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                          const SnackBar(
                                                                            content: Text("Por favor complete todos los campos requeridos."),
                                                                          ),
                                                                        );
                                                                        return;
                                                                      }
                                                                      debugPrint("Info de reserva2");
                                                                      debugPrint(event.pnDocumento.toString());
                                                                      debugPrint(event.pnReserva.toString());
                                                                      debugPrint(observacionesRechazoController.text);
                                                                      RechazarClass(event.pnReserva.toString(),observacionesRechazoController.text).amenidadesReservadas8B();
                                                                      setState(() {
                                                                        observacionesRechazoController.text = "";
                                                                        Navigator.of(context).pop();
                                                                      });
                                                                      setState(() {
                                                                        reloadreserva();
                                                                      });
                                                                      },
                                                                    child: Text(
                                                                        'Rechazar'),
                                                                  ),
                                                               ],
                                                                );
                                                              }
                                                            );
                                                          },
                                                        );
                                                      },
                                                        icon: Icon(Icons.dangerous_outlined,color: const Color.fromRGBO(6, 78, 116, 1), size: constraints.maxWidth * 0.08),):Center(),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      event.pnPermiteAutorizar == 1 ?  Text("Autorizar",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )):Center(),

                                                      event.pnPermiteRechazar == 1 ?  Text("Rechazar",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )):Center(),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                            ),
                                          ),

                                        );
                                      },
                                    );
                                  }
                                );
                              },
                            ) ,
                            17.height,
                            //commonRowText("Comunicación con Administrador", viewAll, theme, () {}),
                             Text("Comunicación con Administrador",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )) ,
                            17.height,
                            tickets? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(onPressed:()
                                          {

                                          },
                                             icon: Icon(BoxIcons.bx_list_check,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.04,)),
                                            Text("Ingresados",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:MediaQuery.of(context).size.width*0.04,
                                            color:Color.fromRGBO(167,167,132,1))),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(onPressed:()
                                          {

                                          },
                                              icon: Icon(BoxIcons.bxs_pencil,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.04,)),

                                          Text("Ingresados",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width*0.04,
                                              color:Color.fromRGBO(167,167,132,1))),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(onPressed:()
                                          {

                                          },
                                              icon: Icon(BoxIcons.bx_check_circle,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.04)),

                                          Text("Ingresados",style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width*0.04,
                                              color:Color.fromRGBO(167,167,132,1))),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ):Center(),
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
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: documentos.length,
                                    itemBuilder: (context, index) {
                                      final event = documentos[index];
                                      final screenWidth = MediaQuery.of(context).size.width;
                                      final screenHeight = MediaQuery.of(context).size.height;

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.008,
                                          horizontal: screenWidth * 0.04,
                                        ),
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
                                                      SizedBox(
                                                        height: MediaQuery.of(context).size.height*0.03,
                                                        width: MediaQuery.of(context).size.width*0.01,
                                                      ),
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
                                                            child: event.plFotografias[0].pvFotografiaB64 != null  ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Image.memory(base64Decode(event.plFotografias[0].pvFotografiaB64!),
                                                                fit: BoxFit.fill,
                                                                width: double.infinity,),
                                                            ):Center(),
                                                          ),
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                width: constraints.maxWidth*0.40,
                                                                child: Text("Ticket ${ event.pnGestion}",style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth*0.045,),maxLines: 2,textAlign: TextAlign.center,),
                                                              ),
                                                              SizedBox(
                                                                width: constraints.maxWidth*0.40,
                                                                child: Text(event.pvDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth*0.045),maxLines: 2,textAlign: TextAlign.center,),
                                                              ),
                                                              SizedBox(
                                                                width: constraints.maxWidth*0.40,
                                                                child: Text(event.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth*0.045,),maxLines: 2,textAlign: TextAlign.center,),
                                                              ),
                                                              SizedBox(
                                                                width: constraints.maxWidth*0.40,
                                                                child: Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(167,167,132,1),
                                                                  fontSize: constraints.maxWidth*0.045,),maxLines: 2,textAlign: TextAlign.center,),
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
                                                                      if (raw == null || raw == 0) return 'Sin atender';
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
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width*0.35,
                                                            child: Column(
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
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width*0.35,
                                                            child: Column(
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
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.35,
                                                        child: TextButton(onPressed: ()
                                                        {

                                                        }, child: Text("Seguimiento",style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize: constraints.maxWidth*0.04,)),),
                                                      ),
                                                    ],
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
                            tickets? Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(onPressed:()
                                              {

                                              },
                                                  icon: Icon(BoxIcons.bx_plus,color:Color.fromRGBO(167,167,132,1),size: MediaQuery.of(context).size.width*0.04,)),
                                              Text("Nueva Gestión",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:MediaQuery.of(context).size.width*0.04,
                                                  color:Color.fromRGBO(167,167,132,1))),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(onPressed:()
                                              {

                                              },
                                                  icon: Icon(BoxIcons.bx_loader_circle,color:Colors.grey[500],size: MediaQuery.of(context).size.width*0.04)),

                                              Text("Seguimientos",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                                  color:Colors.grey[500])),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ),
                            ):Center(),
                            17.height,
                            //commonRowText("Paquetes", viewAll, theme, () {}),
                            tickets == true? Center():Text("Paquetes",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )),
                            17.height,
                            tickets == true? Center(): FutureBuilder(
                              future: _futurePaquetes,
                              key: stopKey ,
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
                                          return  Card(

                                            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      event["pl_fotografias"] != null
                                                          ?GestureDetector(
                                                          onTap: () => showImageDialog5(context, event["pl_fotografias"][0]["pv_fotografiab64"].toString()),
                                                          child: SizedBox(
                                                            width: constraints.maxWidth*0.3,
                                                            height: constraints.maxWidth*0.7,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(20),
                                                              child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString()),
                                                                fit: BoxFit.contain,
                                                                width: double.infinity,
                                                              ),
                                                            ),)
                                                      ): const Center(child: Icon(Icons.image_not_supported, size: 60)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: constraints.maxWidth*0.45,
                                                        //height: MediaQuery.of(context).size.height*0.30,
                                                        child: ListTile(
                                                          title: Text(event["pv_descripcion"].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(6,78,116,1),
                                                            fontSize: constraints.maxWidth*0.04,), maxLines: 2,),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: constraints.maxWidth*0.45,
                                                        child: ListTile(
                                                          title: Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event["pf_fecha"].toString())),style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(167,167,132,1),
                                                            fontSize: constraints.maxWidth*0.04,), maxLines: 2,),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: constraints.maxWidth*0.45,
                                                        child: ListTile(
                                                          title: Text(event["pv_propiedad_nombre"].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(6,78,116,1),
                                                            fontSize: constraints.maxWidth*0.04,), maxLines: 2,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
                            tickets == true? Center(): Text("Visitas",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.035,
                            )),
                            17.height,
                            tickets == true? Center():  FutureBuilder(
                              future:_futureVisitas,
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
                                                          onTap: () => showImageDialog(context, event["pv_imagen_qrb64"].toString()),
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
                                                      width: constraints.maxWidth * 0.33,
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

                      ],
                    ),
                  )
                ]
              )
            )
        )
    );

  }

  Future<void> makeApiCall(String numeroDocumento,String montoPago,String formaPago,String fechaPago,String numeroAutorizacion,String imagen,String reserva)
  async {
    // Example API call
    debugPrint("crear pago");
    ServicioListadoCargoClienteCargar(numeroDocumento,montoPago,formaPago,fechaPago,numeroAutorizacion,imagen,reserva);
    await ServicioListadoCargoClienteCargar(numeroDocumento,montoPago,formaPago,fechaPago,numeroAutorizacion,imagen,reserva)
        .hacerPago();

    setState(() {
      Navigator.of(context).pop();
      _futureDocumentos = homeController.documentosListados5B();
      _futureDocumentos = homeController.documentosListados5B();
      reloadreserva();
      _futureReservas = homeController.amenidadesReservadas5B();
      montoPagarControllerB.clear();
      fechaPagoController.clear();
      numeroAutorizacionController.clear();
      formaPagoController.clear();
    });
    //Navigator.of(context).pop();
    //msgxToast("Pago realizado correctamente");
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



  Widget _buildAction(IconData icon, String label, double fontSize, double iconID) {
    return Column(
      children: [
        IconButton(onPressed: ()
        {
          showTextDialog(context,"Texto");

        }, icon: Icon(icon, color: const Color.fromRGBO(6, 78, 116, 1), size: fontSize * 1.2),),
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(6, 78, 116, 1),
              fontSize: fontSize,
            )),
      ],
    );
  }

/*    Widget eventCard(String title, String description, String date, ThemeData theme) {

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Container(
            decoration: BoxDecoration(
                color: homeController.themeController.isDarkMode
                            ? Colors.black.withOpacity(0.1)
                            : theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                ),
                ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: homeController.themeController.isDarkMode
                            ? admWhiteColor
                            : admTextColor,
                    ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: homeController.themeController.isDarkMode
                            ? admWhiteColor.withOpacity(0.8)
                            : admTextColor.withOpacity(0.8),
                    ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                    date,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: homeController.themeController.isDarkMode
                            ? admLightRed
                            : admColorPrimary,
                    ),
                    ),
                ],
                ),
            ),
            ),
        );

 */
    }


void showImageDialog(BuildContext context, String iamgenSelectB) {
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


void showTextDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content:  Text(""),
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
void showImageDialog3(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
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
void showImageDialog5(BuildContext context, String imageUrl) {
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
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 20,
  );
}
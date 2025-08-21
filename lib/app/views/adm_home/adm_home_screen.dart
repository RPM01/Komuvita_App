import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:administra/app/views/adm_view_all/adm_view_all_screen.dart';
import 'package:administra/widgets/common_progress.dart';
import 'package:administra/route/my_route.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
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
import '../../modal/adms_home_modal.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../adm_menu/adm_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AdmHomeScreen extends StatefulWidget {
  const AdmHomeScreen({super.key});

  @override
  State<AdmHomeScreen> createState() => _AdmHomeScreenState();
  //State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmHomeScreenState extends State<AdmHomeScreen> {
  late ThemeData theme;
  AdmHomeController homeController = Get.put(AdmHomeController());
  AdmMenuController controller = Get.put(AdmMenuController());

  var timeFormat = DateFormat("HH:mm");

  double rating = 3.5;
  int starCount = 5;
  String instrucionesPago = "";
  String userName = "";
  String userCode = "";
  List<String> pago = [];

  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};
  late Future<List<RentaVentaD5>> _futureRentas;

  String formatMoneyWithoutSymbol(double amount) {
    final numberFormat = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return numberFormat.format(amount);
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _futureRentas = homeController.listadoRentas5B();
    theme = homeController.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;

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
  int currentIndex = 0;

  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("NombreUser")!;
      instrucionesPago = prefs.getString("intruciones de pago")!;
      debugPrint("Intruciones");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
    });
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


  final List<Color> cardColors = [
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
  ];

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
                      width: 50,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: controller.themeController.isDarkMode
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
                                  color: controller.themeController.isDarkMode
                                      ? admWhiteColor
                                      : admTextColor,
                                ),
                              ),
                              Text(
                                "Administrador",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: controller.themeController.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
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
                      itemCount: controller.helpAndSupport.length,
                      itemBuilder: (context, index) {
                        final isLast = index == controller.helpAndSupport.length - 1;

                        IconData iconData;
                        switch (index) {
                          case 0: iconData = FontAwesomeIcons.clipboardList; break;
                          case 1: iconData = FontAwesomeIcons.newspaper; break;
                          case 2: iconData = FontAwesomeIcons.cartShopping; break;
                          case 3: iconData = FontAwesomeIcons.question; break;
                          case 4: iconData = FontAwesomeIcons.houseSignal; break;
                          case 5: iconData = FontAwesomeIcons.usersRectangle; break;
                          case 6: iconData = FontAwesomeIcons.doorOpen; break;
                          case 7: iconData = FontAwesomeIcons.boxesStacked; break;
                          case 8: iconData = FontAwesomeIcons.bell; break;
                          case 9: iconData = FontAwesomeIcons.lockOpen; break;
                          case 10: iconData = Icons.logout; break;
                          default: iconData = Icons.menu;
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
                                Get.to(controller.screens[index]);
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  iconData,
                                  size: 22,
                                  color: isLast ? Colors.red :
                                  (controller.themeController.isDarkMode
                                      ? admWhiteColor
                                      : admDarkPrimary),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    controller.helpAndSupport[index],
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isLast ? Colors.red :
                                      (controller.themeController.isDarkMode
                                          ? admWhiteColor
                                          : admDarkPrimary),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: isLast ? Colors.red :
                                  (controller.themeController.isDarkMode
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

        body: GetBuilder<AdmHomeController>(
            init: homeController,
            tag: 'adm_home',
            // theme: theme,
            builder: (homeController) => SingleChildScrollView(
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
                                height: MediaQuery.of(context).size.height*0.20,
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
                                      value: empresasIdsSet[0].toString(),
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
                                      items: List.generate(empresasIdsSet.length, (index) {
                                        return DropdownMenuItem<String>(
                                          value: empresasIdsSet[index].toString(),
                                          child: Text(
                                            " ${empresasNombresSet[index]} (${empresasPropiedadSet[index]})",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }),
                                      onChanged: (value) {
                                        setState(() {
                                          empresasIdsSet = int.parse(value!) as List<int>;
                                        });
                                      },
                                    ),
                                    Text( "Por favor, seleccione el edificio para obtener información detallada.",style: theme.textTheme.headlineSmall?.copyWith(
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
                        )),
                            17.height,
                            FutureBuilder<List<DacumentosH5>>(
                              future: homeController.documentosListados5B(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No data found'));
                                }

                                final documentos = snapshot.data!;

                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final cardWidth = constraints.maxWidth * 0.9;
                                    final cardHeight = constraints.maxHeight * 0.65;
                                    final titleFontSize = constraints.maxWidth * 0.035;
                                    final subtitleFontSize = constraints.maxWidth * 0.03;

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

                                                      // Date + Price
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
                                                      _buildAction(Icons.menu, "Ver detalle", subtitleFontSize),
                                                      _buildAction(Icons.print, "Imprimir", subtitleFontSize),
                                                      _buildAction(Icons.account_balance_wallet_rounded, "Pagos", subtitleFontSize),
                                                      _buildAction(Icons.money_sharp, "Aplicar Pagos", subtitleFontSize),
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Title(color: Colors.black,
                                    child: Text("Información Importante",style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: homeController.themeController.isDarkMode
                                          ? admWhiteColor
                                          : admTextColor,
                                    ),
                                    )
                                ),
                              ),
                            ),
                            17.height,
                            17.height,
                            FutureBuilder(future: homeController.importanInfo5(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error: Sin información"));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text("No events found"));
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
                            commonRowText("Noticias y Avisos", viewAll, theme, () {}),
                            17.height,
                            FutureBuilder(future: homeController.importanNoticias5(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center();
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center();
                                }
                                final events = snapshot.data!;
                                //debugPrint(events.toString());
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.65,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final cardWidth = constraints.maxWidth * 0.9;
                                        final cardHeight = constraints.maxHeight * 0.65;
                                        final titleFontSize = constraints.maxWidth * 0.035;
                                        final subtitleFontSize = constraints.maxWidth * 0.03;
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                          final event = events[index];
                                          return Container(
                                            width: constraints.maxWidth*0.5,
                                            height: constraints.maxHeight,
                                            child: Card(
                                                elevation: 3,
                                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: constraints.maxWidth*0.8,
                                                      height: constraints.maxHeight*0.4,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString()),
                                                          fit: BoxFit.fill,
                                                          width: double.infinity,),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(12),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(event["pv_descripcion"].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(167,167,132,1),
                                                            fontSize: constraints.maxWidth * 0.05,
                                                          )),
                                                          /*Padding(
                                                            padding: const EdgeInsets.all(12),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Noticia | ",style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(6,78,116,1),
                                                                  fontSize: constraints.maxWidth * 0.050,)),
                                                                Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event["pf_fecha"].toString())),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                    color:Color.fromRGBO(167,167,132,1),//color: Colors.grey[600],
                                                                  fontSize: constraints.maxWidth * 0.050,)),
                                                              ],
                                                            ),
                                                          ),
                                                           */
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                width: constraints.maxWidth*0.8,
                                                                child: Text(event["pl_comentarios"][0]["pv_descripcion"],style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                    color:Color.fromRGBO(167,167,132,1),//color: Colors.grey[600],
                                                                  fontSize: constraints.maxWidth * 0.028,
                                                                ),maxLines: 5,),
                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  )
                                );
                              },
                            ),
                            commonRowText("Objetos Perdidos", viewAll, theme, () {}),
                            17.height,
                          FutureBuilder(
                            future: homeController.objetosPerdidos5(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text("No events found"));
                              }

                              final events = snapshot.data!;
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // decide number of columns depending on width
                                  int crossAxisCount = constraints.maxWidth > 900
                                      ? 4
                                      : constraints.maxWidth > 600
                                      ? 3
                                      : 2;

                                  return GridView.builder(
                                    itemCount: events.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: crossAxisCount*2.toDouble(),
                                      crossAxisSpacing: 8*2.toDouble(),

                                    ),
                                    itemBuilder: (context, index) {
                                      final event = events[index];
                                      double cardWidth = constraints.maxWidth / crossAxisCount;

                                      return Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width:constraints.maxWidth < 400
                                                    ? cardWidth * 0.2:cardWidth * 0.3,
                                                height:constraints.maxWidth < 400
                                                    ? cardWidth * 0.2:cardWidth * 0.3,
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

                                              AutoSizeText(
                                                event["pv_descripcion"].toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromRGBO(6, 78, 116, 1),
                                                  fontSize: constraints.maxWidth < 400 ?cardWidth * 0.07:cardWidth * 0.1,
                                                ),
                                                maxLines: 3,            // shrink if more than 2 lines
                                                minFontSize: cardWidth * 0.07.floor(),
                                              ),
                                              AutoSizeText(
                                                "Reportado el ${DateFormat('dd MMMM yyyy', "es_ES").format(
                                                  DateTime.parse(event["pf_fecha"].toString()),
                                                )}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize: constraints.maxWidth < 400 ?cardWidth * 0.04:cardWidth * 0.06,
                                                ),
                                                maxLines: 2,            // shrink if more than 2 lines
                                                minFontSize: cardWidth * 0.04.floor(),
                                              ),
                                              AutoSizeText(
                                                "Reclamado el ${DateFormat('dd MMMM yyyy', "es_ES").format(
                                                  DateTime.parse(event["pf_fecha_reclamada"].toString()),
                                                )}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize: constraints.maxWidth < 400 ?cardWidth * 0.04:cardWidth * 0.06,
                                                ),
                                                maxLines: 2,            // shrink if more than 2 lines
                                                minFontSize: cardWidth * 0.04.floor(),
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
                          17.height,
                            commonRowText("Rentas y ventas", viewAll, theme, () {}),
                            17.height,
                            FutureBuilder<List<RentaVentaD5>>(
                              future:_futureRentas,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No data found'));
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
                                                                  return ClipRRect(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10),
                                                                    child: Image.memory(
                                                                      bytes,
                                                                      fit: BoxFit.cover,
                                                                      width: double.infinity,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),

                                                                // ⬅️ Flecha izquierda
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

                                                          // Columna Derecha
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
                            ),
                            commonRowText("Amenidades Reservadas", viewAll, theme, () {}),
                            17.height,
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
                            17.height,
                            FutureBuilder<List<ReservasF5>>(
                              future: homeController.amenidadesReservadas5B(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No data found'));
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
                                                                fontSize: constraints.maxWidth * 0.035,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize:constraints.maxWidth* 0.03,
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
                                                                fontSize: constraints.maxWidth* 0.035,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvAmenidadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize: constraints.maxWidth * 0.03,
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
                                                                  fontSize: constraints.maxWidth * 0.035,
                                                                )
                                                                ),
                                                                subtitle: Text(event.pvMonedaSimbolo! + event.pmValor!.toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(6,78,116,1),
                                                                  fontSize: constraints.maxWidth * 0.03,
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
                                                                  fontSize: constraints.maxWidth * 0.035,
                                                                )
                                                                ),
                                                                subtitle: Text(DateFormat('yyyyMMdd').format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color:Color.fromRGBO(6,78,116,1),
                                                                  fontSize: constraints.maxWidth * 0.03,
                                                                ),maxLines: 2,
                                                                ),
                                                              )
                                                          ),
                                                          SizedBox(
                                                            width:constraints.maxWidth* 0.4,
                                                            child: ListTile(
                                                              title: Text("Estado",style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(167,167,132,1),
                                                                fontSize: constraints.maxWidth * 0.035,
                                                              )
                                                              ),
                                                              subtitle: Text(event.pvEstadoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color:Color.fromRGBO(6,78,116,1),
                                                                fontSize: constraints.maxWidth * 0.03,
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
                                                      _buildAction(Icons.money_sharp, "Aplicar Pagos", constraints.maxWidth * 0.03,),
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
                            ),
                            17.height,
                            commonRowText("Comunicación con Administrador", viewAll, theme, () {}),
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
                          ),
                            17.height,
                          FutureBuilder<List<TickestG5>>(
                            future: homeController.GestionTickets5B(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No data found'));
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

                                      return Container(
                                        width: MediaQuery.of(context).size.width*0.75,
                                        height: constraints.maxWidth < 400? constraints.maxWidth*0.9: constraints.maxWidth*0.95,
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
                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height*0.03,
                                                      width: MediaQuery.of(context).size.width*0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.memory(base64Decode(event.plFotografias[0].pvFotografiab64!),
                                                              fit: BoxFit.fill,
                                                              width: double.infinity,),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text("Ticket ${ event.pnGestion}",style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize: constraints.maxWidth*0.045,)),
                                                            Text(event.pvDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize: constraints.maxWidth*0.045,)),
                                                            Text(event.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize: constraints.maxWidth*0.045,)),
                                                            Text(DateFormat('dd MMMM yyyy', "es_ES").format(DateTime.parse(event.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color:Color.fromRGBO(167,167,132,1),
                                                              fontSize: constraints.maxWidth*0.045,)),
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
                            ),
                            17.height,
                            commonRowText("Paquetes", viewAll, theme, () {}),
                            17.height,
                            FutureBuilder(future: homeController.paqueteria5(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error: ${snapshot.error}"));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text("No events found"));
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
                                                    SizedBox(
                                                      width: constraints.maxWidth*0.40,
                                                      height: constraints.maxWidth*0.30,
                                                      child:ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString()),
                                                          fit: BoxFit.contain,
                                                          width: double.infinity,
                                                        ),
                                                      ),
                                                    )
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
                            Center(
                              child: Text("Visitas",style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:Color.fromRGBO(6,78,116,1),
                                  fontSize: MediaQuery.of(context).size.width * 0.05
                              ),
                              ),
                            ),
                            17.height,
                            FutureBuilder(
                              future: homeController.visitas5(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error: ${snapshot.error}"));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text("No events found"));
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
                                                        ?SizedBox(
                                                        width: constraints.maxWidth*0.3,
                                                        height: constraints.maxWidth*0.7,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: Image.memory(
                                                            base64Decode(event["pv_imagen_qrb64"].toString()),
                                                            fit: BoxFit.fill,
                                                            width: double.infinity,
                                                          ),
                                                        ))
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
                                                          DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"].toString()),) +" ${event["pf_hora_llegada"]}",
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
                                                        subtitle: Text(event["pv_visita_vehiculo_placa"].toString(),
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
                                                        subtitle: Text(event["pv_observaciones"].toString(),
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
                            /*
                            17.height,
                            commonRowText("Documentos Pendientes", viewAll, theme, () {}),
                            17.height,
                          FutureBuilder<List<DacumentosH5>>(
                            future: homeController.documentosListados5B(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No data found'));
                              }
                              final documentos = snapshot.data!; // API list
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                  headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  dataRowMaxHeight: MediaQuery.of(context).size.height*0.31,
                                  columns: [
                                    DataColumn(label: Title(color: Colors.black,
                                    child: Text("Datos",style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white,)))),
                                     DataColumn(label: Title(color: Colors.black,
                                           child: Text("Propiedad",style: theme.textTheme.headlineSmall?.copyWith(
                                             fontWeight: FontWeight.bold,
                                             color:Colors.white,)))),
                                     DataColumn(label: Title(color: Colors.black,
                                       child: Text("Detalle\nCobro",style: theme.textTheme.headlineSmall?.copyWith(
                                         fontWeight: FontWeight.bold,
                                         color:Colors.white,)))),
                                     /*DataColumn(label: Title(color: Colors.black,
                                           child: Text("Acciones",style: theme.textTheme.headlineSmall?.copyWith(
                                             fontWeight: FontWeight.bold,
                                             color:Colors.white,))))*/
                                  ],
                                  rows: [
                                    ...List.generate(documentos.length, (index) {
                                      final doc = documentos[index];
                                      final isEven = index % 2 == 0;
                                      return DataRow(
                                        color: MaterialStateProperty.all(
                                          isEven ? Colors.white : Colors.grey.shade200, // alternating colors
                                        ),
                                        cells: [
                                          DataCell(
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center, // Optional: for vertical alignment
                                                crossAxisAlignment: CrossAxisAlignment.start, // Optional: for horizontal alignment
                                                children: <Widget> [
                                                  Text("Nombre:",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                              color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                            )),
                                                  Text(doc.pvNombre!),
                                                  Text("NIT:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )) ,
                                                  Text(doc.pvNit!),
                                                  Text("Fecha:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(DateFormat('yyyyMMdd').format(DateTime.parse(doc.pfFecha!)),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column (
                                                        children: [
                                                          IconButton(
                                                            onPressed:() {}, icon: Icon(Icons.menu,color: Color.fromRGBO(61, 95, 70,1),),
                                                          ),
                                                          Text("Ver detalle"),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed:() {}, icon: Icon(Icons.print,color: Color.fromRGBO(61, 95, 70,1),),
                                                          ),
                                                          Text("Imprimir"),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ]
                                            ),
                                          ),
                                          DataCell(
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center, // Optional: for vertical alignment
                                                crossAxisAlignment: CrossAxisAlignment.start, // Optional: for horizontal alignment
                                                children: <Widget> [
                                                  Text("Propiedad:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(doc.pvPropiedadDescripcion!),
                                                  Text("Dirección:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )) ,
                                                  Text(doc.pvPropiedadDireccion!),
                                                  Text("Tipo:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(doc.pvDocumentoTipoDescripcion!),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Column(

                                                          children: <Widget> [
                                                            IconButton(
                                                              onPressed:() {}, icon: Icon(Icons.account_balance_wallet_rounded,color: Color.fromRGBO(61, 95, 70,1),),
                                                            ),
                                                            Text("Pagos"),
                                                          ]
                                                      ),
                                                      Column(

                                                        children: [
                                                          IconButton(
                                                            onPressed:() {},
                                                            icon: Icon(Icons.money_sharp,color: Color.fromRGBO(61, 95, 70,1),),
                                                          ),
                                                          Text("Aplicar Pagos"),

                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ]
                                            ),

                                          ),
                                          DataCell(
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center, // Optional: for vertical alignment
                                                crossAxisAlignment: CrossAxisAlignment.start, // Optional: for horizontal alignment
                                                children: <Widget> [
                                                  Text("Total:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(doc.pvMonedaSimbolo! + formatMoneyWithoutSymbol(doc.pmValor!).toString() ),
                                                  Text("Pendiente\nde Pago:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  ),maxLines: 2,),
                                                  Text(formatMoneyWithoutSymbol(doc.pmValorPendiente!).toString()),
                                                  Text("Serie:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(doc.pvSerie!),
                                                  Text("Número:",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Color.fromRGBO(146, 162, 87,1),
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  )),
                                                  Text(doc.pvNumero!),
                                                ]
                                            ),
                                          ),
                                        ],
                                      );
                                    }),

                                  ],
                                ),
                              );
                            },
                          ),
                          17.height,
                            Title(color: Colors.black, child: Text("💰 Instrucciones de Pago 💰",style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: homeController.themeController.isDarkMode
                              ? admWhiteColor
                              : admTextColor,
                              ),
                            )
                        ),
                            17.height,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                headingTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                  dataRowMaxHeight: MediaQuery.of(context).size.height*0.1,
                                    columns: [
                                      DataColumn(label: Title(color: Colors.black,
                                          child: Text("Banco",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white,
                                            fontSize: MediaQuery.of(context).size.width * 0.025,
                                          )))),
                                      DataColumn(label: Title(color: Colors.black,
                                          child: Text("Cuenta",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white,
                                            fontSize: MediaQuery.of(context).size.width * 0.025,
                                          )))),
                                      DataColumn(label: Title(color: Colors.black,
                                          child: Text("No.cuenta",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white,
                                            fontSize: MediaQuery.of(context).size.width * 0.025,
                                          )))),
                                      DataColumn(label: Title(color: Colors.black,
                                          child: Text("A nombre de",style: theme.textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white,
                                            fontSize: MediaQuery.of(context).size.width * 0.025,
                                          )))),
                                    ],
                                rows: [
                                  DataRow(
                                      cells: <DataCell>[
                                      DataCell(Text(pago[0].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataCell(Text("${pago[1]}\n${pago[2]}",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                        DataCell(Text(pago[3].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.black,
                                          fontSize: MediaQuery.of(context).size.width * 0.025,
                                        ))),
                                        DataCell(Text(pago[4].toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.black,
                                          fontSize: MediaQuery.of(context).size.width * 0.025,
                                        ))),
                                    ],
                                  )
                                ],
                                ),
                            ),
                          17.height,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 50,
                                  child:Title(color: Colors.black,
                                      child: Text("Información Importante",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: homeController.themeController.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                      ),
                                        maxLines: 2,
                                      )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 50,
                                  child: Title(color: Colors.black,
                                      child: Text("Objetos Perdidos",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: homeController.themeController.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                      ),
                                      )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 50,
                                  child: Title(color: Colors.black,
                                      child: Text("Noticias y Avisos",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: homeController.themeController.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                            17.height,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children:<Widget>[
                                Expanded(
                                  child: FutureBuilder(future: homeController.importanInfo5(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text("Error: Sin información"));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: Text("No events found"));
                                    }
                                    final events = snapshot.data!;
                                    //debugPrint(events.toString());
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: events.length,
                                      itemBuilder: (context, index) {
                                        final event = events[index];
                                        return Container(
                                          width: MediaQuery.of(context).size.width*0.30,
                                          height: MediaQuery.of(context).size.height*0.30,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(event["pv_descripcion"].toString()),
                                                  subtitle: Text(event["pv_detalle"].toString()),
                                                ),
                                              ],
                                            )
                                        );
                                      },
                                    );
                                  },
                                ),
                                ),
                                Expanded(child: FutureBuilder(future: homeController.objetosPerdidos5(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text("Error: ${snapshot.error}"));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: Text("No events found"));
                                    }
                                    final events = snapshot.data!;
                                    //debugPrint(events.toString());
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: events.length,
                                      itemBuilder: (context, index) {
                                        final event = events[index];
                                        return Container(
                                          width: MediaQuery.of(context).size.width*0.3,
                                          height: MediaQuery.of(context).size.height*0.4,
                                          child: Card(
                                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                              child: Column(
                                                children: [
                                                  Text(event["pv_descripcion"].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                                  ListTile(
                                                    title: Text("Reportado"),
                                                    subtitle: Text( DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"].toString()))),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width*0.2,
                                                    height: MediaQuery.of(context).size.width*0.2,
                                                    child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString())),
                                                  ),
                                                ],
                                              )
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ),
                                Expanded(
                                  child: FutureBuilder(future: homeController.importanNoticias5(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text("Error: ${snapshot.error}"));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: Text("No events found"));
                                    }
                                    final events = snapshot.data!;
                                    //debugPrint(events.toString());
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: events.length,
                                      itemBuilder: (context, index) {
                                        final event = events[index];
                                        return Container(
                                          width: MediaQuery.of(context).size.width*0.3,
                                          height: MediaQuery.of(context).size.width*0.5,
                                          child: Card(
                                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(event["pn_noticia"].toString()),
                                                    subtitle: Text(event["pv_descripcion"].toString()),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width*0.3,
                                                    height: MediaQuery.of(context).size.width*0.3,
                                                    child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString())),
                                                  ),
                                                ],
                                              )
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                )

                              ],
                            ),
                          ),
                            17.height,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget>[
                                  Title(color: Colors.black,
                                      child: Text("Rentas y Ventas",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: homeController.themeController.isDarkMode
                                            ? admWhiteColor
                                            : admTextColor,
                                      ),
                                      )
                                  ),
                                  17.height,
                                  FutureBuilder<List<RentaVentaD5>>(
                                    future: homeController.listadoRentas5B(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return const Center(child: Text('No data found'));
                                      }
                                      final documentos = snapshot.data!; // API list
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                          headingTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          dataRowMaxHeight: MediaQuery.of(context).size.height*0.3,
                                          columns: [
                                            DataColumn(label: Title(color: Colors.black,
                                                child: Text("#",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                )))),
                                            DataColumn(label: Title(color: Colors.black,
                                                child: Text("Detalle",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                )))),
                                            DataColumn(label: Title(color: Colors.black,
                                                child: Text("Precio",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                )))),
                                            DataColumn(label: Title(color: Colors.black,
                                                child: Text(" "))),
                                          ],
                                          rows: [
                                            ...List.generate(documentos.length, (index) {
                                              final doc = documentos[index];
                                              final isEven = index % 2 == 0;
                                              return DataRow(
                                                color: MaterialStateProperty.all(
                                                  isEven ? Colors.white : Colors.grey.shade200, // alternating colors
                                                ),
                                                cells: [
                                              DataCell(
                                              Card(
                                              color: cardColors[index % cardColors.length], // pick color based on row index
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    doc.pnRenta.toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: homeController.themeController.isDarkMode
                                                          ? admWhiteColor
                                                          : admTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ),
                                                  DataCell(
                                                    Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text("Fecha de publicación:",style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(146, 162, 87,1),
                                                            fontSize: MediaQuery.of(context).size.width * 0.03,
                                                          )),
                                                          subtitle:Text(DateFormat('yyyyMMdd').format(DateTime.parse(doc.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Colors.black,
                                                            fontSize: MediaQuery.of(context).size.width * 0.024,
                                                          )),
                                                        ),
                                                        ListTile(
                                                          title: Text("Detalle:",style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(146, 162, 87,1),
                                                            fontSize: MediaQuery.of(context).size.width * 0.03,
                                                          )),
                                                          subtitle:Text(doc.pvDetalleRenta!,style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Colors.black,
                                                            fontSize: MediaQuery.of(context).size.width * 0.024,
                                                          )),
                                                          ),
                                                        ListTile(
                                                          title: Text("Datos de Contacto:",style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Color.fromRGBO(146, 162, 87,1),
                                                            fontSize: MediaQuery.of(context).size.width * 0.03,
                                                          )),
                                                          subtitle:Text(doc.pvContacto!,style: theme.textTheme.headlineSmall?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color:Colors.black,
                                                            fontSize: MediaQuery.of(context).size.width * 0.024,
                                                          )),
                                                        ),
                                                      ]
                                                    )
                                                  ),
                                                  DataCell(
                                                    ListTile(
                                                      title: Text("Renta",style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Color.fromRGBO(146, 162, 87,1),
                                                        fontSize: MediaQuery.of(context).size.width * 0.035,
                                                      )),
                                                      subtitle:Text(doc.pvMonedaSimbolo! + formatMoneyWithoutSymbol(doc.pmValor!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.black,
                                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                                      )),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width*0.2,
                                                      height: MediaQuery.of(context).size.width*0.2,
                                                      child: Image.memory(base64Decode(doc.plFotografias[0].pvFotografiab64.toString()
                                                        /*event["pl_fotografias"][0]["pv_fotografiab64"].toString()*/)),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  /*FutureBuilder(future: homeController.listadoRentas5(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return const Center(child: Text("No events found"));
                                      }
                                      final events = snapshot.data!;
                                      //debugPrint(events.toString());
                                      return ListView.builder(
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                          final event = events[index];
                                          debugPrint("Imagen");
                                          return Card(
                                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                              child: Row(
                                                children: [
                                                    Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text("A Fecha de publicación:"),
                                                          subtitle: Text(DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"].toString()))),
                                                        ),
                                                        ListTile(
                                                          title: Text("Detalle"),
                                                          subtitle: Text(DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"].toString()))),
                                                        ),
                                                      ],
                                                    ),
                                                  Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text("Renta"),
                                                        subtitle: Text(event["pv_detalle_renta"].toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text("A Fecha de publicación:"),
                                                        subtitle: Text(DateFormat('yyyyMMdd').format(DateTime.parse(event["pf_fecha"].toString()))),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.2,
                                                        height: MediaQuery.of(context).size.width*0.2,
                                                        child: Image.memory(base64Decode(event["pl_fotografias"][0]["pv_fotografiab64"].toString())),
                                                      ),
                                                      ListTile(
                                                        title: Text("Datos de Contacto:"),
                                                        subtitle: Text(event["pv_contacto"].toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text("Precio"),
                                                        subtitle: Text(event["pm_valor"].toString()),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          );
                                        },
                                      );
                                    },
                                  ),*/
                                ],
                              ),
                            ),
                            17.height,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Title(color: Colors.black,
                                  child: Text("Amenidades Reservadasdos",style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: homeController.themeController.isDarkMode
                                        ? admWhiteColor
                                        : admTextColor,
                                  ),
                                  )
                              ),
                            ),
                          ),
                            17.height,
                            FutureBuilder<List<ReservasF5>>(
                              future: homeController.amenidadesReservadas5B(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No data found'));
                                }
                                final documentos = snapshot.data!; // API list
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    dataRowMaxHeight: MediaQuery.of(context).size.height*0.2,
                                    columns: [
                                      DataColumn(label: Text("Propiedad",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Amenidad",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Costo",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Fecha",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Estado",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Acciones",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      )))
                                    ],
                                    rows: [
                                      ...List.generate(documentos.length, (index) {
                                        final doc = documentos[index];
                                        final isEven = index % 2 == 0;
                                        return DataRow(
                                          color: MaterialStateProperty.all(
                                            isEven ? Colors.white : Colors.grey.shade200, // alternating colors
                                          ),
                                          cells: [
                                            DataCell(
                                              Text(doc.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                              ))
                                            ),
                                            DataCell(
                                              Text(doc.pvAmenidadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                              )),
                                            ),
                                            DataCell(
                                              Text(doc.pvMonedaSimbolo! + formatMoneyWithoutSymbol(doc.pmValor!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.024,
                                              ))
                                            ),
                                            DataCell(
                                              Text(DateFormat('yyyyMMdd').format(DateTime.parse(doc.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.024,
                                              )),
                                            ),
                                            DataCell(
                                              Text(doc.pvEstadoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.024,
                                              ))
                                            ),
                                            DataCell(Center()),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                            17.height,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Title(color: Colors.black,
                                    child: Text("Tickets Pendientes",style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: homeController.themeController.isDarkMode
                                          ? admWhiteColor
                                          : admTextColor,
                                    ),
                                    )
                                ),
                              ),
                            ),
                            17.height,
                            FutureBuilder<List<TickestG5>>(
                              future: homeController.GestionTickets5B(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No data found'));
                                }

                                final documentos = snapshot.data!; // API list

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    dataRowMaxHeight: MediaQuery.of(context).size.height*0.2,
                                    columns: [
                                      DataColumn(label:Text("#",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataColumn(label: Text("Gestion",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataColumn(label: Text("Tipo",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataColumn(label: Text("Tiempos",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataColumn(label: Text("Calificación",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                      ))),
                                      DataColumn(label: Text(" ",style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.025,
                                )))
                                    ],
                                    rows: [
                                      ...List.generate(documentos.length, (index) {
                                        final doc = documentos[index];
                                        final isEven = index % 2 == 0;
                                        return DataRow(
                                          color: MaterialStateProperty.all(
                                            isEven ? Colors.white : Colors.grey.shade200, // alternating colors
                                          ),
                                          cells: [
                                            DataCell(
                                              Card(
                                                color: cardColors[index % cardColors.length], // pick color based on row index
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    doc.pnGestion.toString(),
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: homeController.themeController.isDarkMode
                                                          ? admWhiteColor
                                                          : admTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.2,
                                                        height: MediaQuery.of(context).size.width*0.2,
                                                        child:Image.memory(base64Decode(doc.plFotografias[0].pvFotografiab64!),
                                                          fit: BoxFit.contain,
                                                          width: double.infinity,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Text(doc.pvDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color:Colors.black,
                                                        fontSize: MediaQuery.of(context).size.width * 0.02,
                                                      )),
                                                    Text(doc.pvPropiedadDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color:Colors.black,
                                                      fontSize: MediaQuery.of(context).size.width * 0.02,
                                                    )),
                                                    Text(DateFormat('yyyyMMdd').format(DateTime.parse(doc.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color:Colors.black,
                                                      fontSize: MediaQuery.of(context).size.width * 0.02,
                                                    )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Text(doc.pvGestionTipoDescripcion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.02,
                                              ))
                                            ),
                                            DataCell(
                                              Column(
                                                children: [
                                                  Text("Creación",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.black,
                                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                                  )),
                                                  Text(doc.pvTiempoCreacion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.black,
                                                    fontSize: MediaQuery.of(context).size.width * 0.02,
                                                  )),
                                                  Text("Atención",style: theme.textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.black,
                                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                                  )),
                                                  //Text(doc.pvTiempoAtencion!),
                                                ],
                                              )
                                            ),
                                            DataCell(
                                                Center(
                                                  child: StarRating(
                                                        size: 25.0,
                                                    rating: rating,
                                                    color: Colors.lime,
                                                    borderColor: Colors.grey,
                                                    allowHalfRating: true,
                                                    starCount: starCount,
                                                    onRatingChanged: (rating) => setState(() {
                                                    this.rating = rating;
                                                    }),
                                                    ),
                                                  )
                                                ),
                                            DataCell(
                                                Text(doc.pvGestionTipoDescripcion!)
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                );
                              },
                            ),
                           * */

                            /*17.height,
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: homeController.documentosListados5(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text("Error: ${snapshot.error}"));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Center(child: Text("No data found."));
                                  }

                                  final data = snapshot.data!;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                      border: TableBorder.all(),
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children: [
                                        // Header row
                                        TableRow(
                                          decoration: BoxDecoration(color: Colors.grey[300]),
                                          children: [
                                            for (final title in ["Datos", "Propiedad", "Detalle Cobro", "Acciones"])
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    title,
                                                    style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: homeController.themeController.isDarkMode
                                                          ? admWhiteColor
                                                          : admTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        // Data rows
                                        ...data.map((row) {
                                          return TableRow(
                                            children: [
                                              // Cell 1: Datos
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Nombre:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Text("${row["pv_nombre"] ?? 'N/A'}"),
                                                    const Text("NIT:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Text("${row["pv_nit"] ?? 'N/A'}"),
                                                    const SizedBox(height: 4),
                                                    const Text("Fecha:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                    Text("${row["pd_fecha"] ?? 'N/A'}"),
                                                  ],
                                                ),
                                              ),
                                              // Cell 2: Propiedad
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("Propiedad:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      //Text("${row["pd_fecha"] ?? 'N/A'}"),
                                                      const Text("Dirección:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                     // Text("${row["pd_fecha"] ?? 'N/A'}"),
                                                      const Text("Tipo:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                     // Text("${row["pd_fecha"] ?? 'N/A'}"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Cell 3: Detalle Cobro
                                              Padding(
                                                padding: const EdgeInsets.all(80),
                                                child: Container(
                                                  padding: const EdgeInsets.all(60),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text("totla:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text("${row["pm_valor"] ?? 'N/A'}"),
                                                      const SizedBox(height: 4),
                                                      const Text("Pendiente de Pago:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text("${row["pm_valor_pendiente"] ?? 'N/A'}"),
                                                      const Text("Serie:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text("${row["pv_serie"] ?? 'N/A'}"),
                                                      const Text("Número:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text("${row["pv_numero"] ?? 'N/A'}"),
                                                      const Text("UUID:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                      Text("${row["pv_uuid"] ?? 'N/A'}"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Cell 4: Acciones (could include buttons or icons)
                                              Padding(
                                                padding: const EdgeInsets.all(80),
                                                child: Container(
                                                  padding: const EdgeInsets.all(60),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.visibility),
                                                        onPressed: () {
                                                          // Your action here
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.download),
                                                        onPressed: () {
                                                          // Another action
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),*/
                            17.height,
                            /*
                           *  commonRowText("Facturas Recientes", viewAll, theme, () {}),
                            17.height,
                            FutureBuilder(
                                future: homeController.getCategoryAdmsDetail(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else {
                                    return
                                    Obx(() =>  GridView.builder(
                                        itemCount: homeController.listOCategoryAdms.length,
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            mainAxisExtent: 120),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {},
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 65,
                                                  width: 65,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          60),
                                                      border: Border.all(
                                                          color: homeController
                                                              .themeController
                                                              .isDarkMode
                                                              ? darkGreyColor
                                                              : greyColor,
                                                          width: 1.5)),
                                                  child: Center(
                                                    child: commonCacheAdmImageWidget(  homeController
                                                        .listOCategoryAdms[
                                                    index]
                                                        .image
                                                        .toString(),
                                                      32,width: 32,   ),

                                                  ),
                                                ),
                                                15.height,
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    homeController
                                                        .listOCategoryAdms[
                                                    index]
                                                        .name
                                                        .toString(),
                                                    style: theme
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: homeController
                                                            .themeController
                                                            .isDarkMode
                                                            ? admWhiteColor
                                                            : admTextColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }));
                                  }
                                }),
                            17.height,
                            commonRowText(admsNearYou, viewAll, theme, () {
                              Get.to(const AdmsViewAllScreen(
                                title: admsNearYou,
                              ));
                            }),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: homeController.getNearAdmsDetail(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return commonProgressBar();
                            } else {
                              return HorizontalList(
                                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
                                  itemCount:
                                      homeController.listOfNearAdms.length,
                                  itemBuilder: (context, index) {
                                    AdmsModal detail =
                                        homeController.listOfNearAdms[index];
                                    return
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(MyRoute.admDetail,
                                            arguments: detail);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: AdmDetailView(
                                          theme: theme,
                                          detail: detail,
                                          onPressed: () {
                                            homeController.toggleFavorite(detail);
                                            detail.isFavorite.value==false?
                                            customMsgBox(admRemovedFromFavourites,theme,context):
                                            customMsgBox(admAddedToFavourites,theme,context);
                                            // Get.showSnackbar(
                                            //     const GetSnackBar(
                                            //       backgroundColor: black,
                                            //       borderRadius:BorderSide.strokeAlignOutside,
                                            //       snackStyle: SnackStyle.FLOATING,
                                            //       message: admRemovedFromFavourites,
                                            //       snackPosition: SnackPosition.BOTTOM,
                                            //       duration: Duration(seconds: 2),
                                            //       margin:  EdgeInsets.all(30),
                                            //     )):
                                            // Get.showSnackbar(const GetSnackBar(
                                            //   backgroundColor: black,
                                            //   borderRadius:BorderSide.strokeAlignOutside,
                                            //   snackStyle: SnackStyle.FLOATING,
                                            //   message: admAddedToFavourites,
                                            //   snackPosition: SnackPosition.BOTTOM,
                                            //   duration: Duration(seconds: 2),
                                            //   margin:  EdgeInsets.all(30),
                                            // ));
                                          },
                                        ),
                                      ),
                                    );

                                  });
                            }
                          }),*/
                      ],
                    ),
                  )
                ]
              )
            )
        )
    );
  }

  void _showLogOutBottomSheet(
      BuildContext context,
      ) {
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
                                  Get.offNamed(MyRoute.loginScreen);
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

  Widget _buildAction(IconData icon, String label, double fontSize) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromRGBO(6, 78, 116, 1), size: fontSize * 1.2),
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

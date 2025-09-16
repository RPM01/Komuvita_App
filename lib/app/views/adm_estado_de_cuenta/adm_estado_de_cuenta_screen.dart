import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:url_launcher/url_launcher.dart';
import '../../../api_Clases/class_Cuentas7.dart';
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
import '../../controller/adm_estado_de_cuenta_controller.dart';
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
import 'package:image/image.dart' as img;
//import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import '../adm_home/adm_home_screen.dart';

class AdmEstadoDeCuentaScreen extends StatefulWidget {
  const AdmEstadoDeCuentaScreen({super.key});

  @override
  State<AdmEstadoDeCuentaScreen> createState() => _AdmEstadoDeCuentaScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmEstadoDeCuentaScreenState extends State<AdmEstadoDeCuentaScreen> {

  late ThemeData theme;

  //AdmHomeController admEstadoDeCuentaController = Get.put(AdmHomeController());
  AdmEstadoCuentaController admEstadoDeCuentaController = Get.put(AdmEstadoCuentaController());

  AdmMenuController menuController = Get.put(AdmMenuController());

  String userName = "";
  String edificioID = "";
  String edificioDescripcion = "";

  String periodoCuentaID = "";
  String periodoCuentaDescripcion = "";

  String propiedadCuentaID = "";
  String propiedadCuentaDescripcion = "";

  List<String> periodeDeCuenta = ["Mes En Curso","Mes Anterior","Año En Curso","Año Anterior"];
  List<int> periodeDeCuentaID = [1,2,3,4];

   Future<List<CuentasH7>> ? _futureCuentasH7;

  String? selectedValueA;
  String? selectedValueB;
  String? selectedValueC;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();

    setState(() {
      theme = admEstadoDeCuentaController.themeController.isDarkMode
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
    _futureCuentasH7 = ServicioListadoCuenta(clienteIDset,propiedadCuentaID,periodoCuentaID).estadoDeCuentaH7();
  }

  String formatMoneyWithoutSymbol(double amount) {
    final numberFormat = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return numberFormat.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor:admEstadoDeCuentaController.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
        appBar: AppBar(
          backgroundColor: admEstadoDeCuentaController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: admEstadoDeCuentaController.themeController.isDarkMode
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
                color: admEstadoDeCuentaController.themeController.isDarkMode
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
                              color: admEstadoDeCuentaController.themeController.isDarkMode
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
                                    admEstadoDeCuentaController.themeController.isDarkMode
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

        body: GetBuilder<AdmEstadoCuentaController>(
            init: admEstadoDeCuentaController,
            tag: 'adm_estadoCuenta',
            // theme: theme,
            builder: (admEstadoDeCuentaController) => SingleChildScrollView(
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
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: false,
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
                                              debugPrint(periodoCuentaID);
                                            });
                                          },
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
                                              int index = propiedadesInternaNombresSet.indexOf(value!);
                                              debugPrint("setcuenta");
                                              debugPrint(index.toString());
                                              propiedadCuentaID = "1";
                                              clienteIDset = value;
                                              debugPrint(propiedadCuentaID);
                                            });
                                          },
                                        ),
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
                                              _futureCuentasH7 = ServicioListadoCuenta(prefs.getString("cliente")!,"1",periodoCuentaID).estadoDeCuentaH7();
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
                                ],
                              )
                          ),
                             17.height,
                            FutureBuilder<List<CuentasH7>>(
                              future: _futureCuentasH7,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      "Error cargando estado de cuenta",
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
                                      "No hay estado de cuenta",
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
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documentos.length,
                                  itemBuilder: (context, index) {
                                    final event = documentos[index];

                                    return LayoutBuilder(
                                        builder: (context, constraints) {
                                          final cardWidth = constraints.maxWidth * 0.9;
                                          final cardHeight = constraints.maxHeight * 0.65;
                                          final titleFontSize = constraints.maxWidth * 0.035;
                                          final subtitleFontSize = constraints.maxWidth * 0.03;

                                          double noticiaSize = constraints.maxHeight;
                                        return Container(
                                            padding: const EdgeInsets.all(12),
                                            //width: MediaQuery.of(context).size.width,
                                            height: constraints.maxWidth > 400 ? MediaQuery.of(context).size.height * 0.40: MediaQuery.of(context).size.height * 0.30,
                                          child: Card(
                                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              height: cardHeight * 0.30, // FIXED HEIGHT
                                              child: Card(
                                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                elevation: 4,
                                                color: Colors.grey[200],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: constraints.maxWidth*0.03,
                                                    ),
                                                    event.pvTransaccion == "Cargo"? Text(event.pvTransaccion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color:Colors.blue,
                                                      fontSize: constraints.maxWidth * 0.04,
                                                    )
                                                    ):Text(event.pvTransaccion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color:Colors.amber,
                                                      fontSize:  constraints.maxWidth * 0.04,
                                                    )),
                                                    Center(
                                                      child: SizedBox(
                                                        width: constraints.maxWidth*0.80,
                                                        child: Text(event.pvDescripcionMovimiento!,style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize: constraints.maxWidth * 0.035,
                                                        )),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(
                                                          DateFormat('dd/MM/yyyy').format(DateTime.parse(event.pfFecha!)),
                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: constraints.maxWidth *0.03,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        if (event.pnPermiteVerComprobante == 1)
                                                          IconButton(
                                                            icon:  FaIcon(FontAwesomeIcons.fileInvoice,size: constraints.maxWidth *0.05,),
                                                            color: const Color.fromRGBO(6, 78, 116, 1),
                                                            onPressed: () async {
                                                              final rawUrl = event.pvVerComprobante!;
                                                              final uri = Uri.tryParse(rawUrl);
                                                              final safeUri = uri ?? Uri.parse(Uri.encodeFull(rawUrl));
                                                              if (await canLaunchUrl(safeUri)) {
                                                                await launchUrl(
                                                                  safeUri,
                                                                  mode: LaunchMode.externalApplication,
                                                                );
                                                              } else {
                                                                debugPrint("Could not launch $safeUri");
                                                              }
                                                            },
                                                          ),

                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Débito",style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:  Color.fromRGBO(6, 78, 116, 1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        )),
                                                        Text("Crédito",style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:  Color.fromRGBO(6, 78, 116, 1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        )),
                                                        Text("Saldo Actual",style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:  Color.fromRGBO(6, 78, 116, 1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        ))
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        event.pmDebito != 0 ? Text(event.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(event.pmDebito!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        )):Center(),
                                                        event.pmCredito != 0 ?  Text(event.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(event.pmCredito!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        )):Center(),
                                                        Text(event.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(event.pmSaldoActual!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color:Color.fromRGBO(167,167,132,1),
                                                          fontSize:  constraints.maxWidth * 0.03,
                                                        )),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  },
                                );
                              },
                            ),
                            17.height,
                            /*
                                  DataTable(
                                    headingRowColor: WidgetStateProperty.all(Color.fromRGBO(146, 162, 87,1)),
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    dataRowMaxHeight: MediaQuery.of(context).size.height*0.2,
                                    columns: [
                                      DataColumn(label: Text("Fecha",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Center()),
                                      DataColumn(label: Text("Transacción",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Descripción",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Débito",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Crédito",style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ))),
                                      DataColumn(label: Text("Saldo Actual",style: theme.textTheme.headlineSmall?.copyWith(
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
                                              Text(DateFormat('yyyyMMdd').format(DateTime.parse(doc.pfFecha!)),style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.024,
                                              )),
                                            ),
                                            DataCell(
                                                doc.pnPermiteVerComprobante == 1 ? IconButton(
                                                    icon: const Icon(FontAwesome.file_invoice_solid),
                                                color: Color.fromRGBO(6,78,116,1),
                                                onPressed: ()async
                                                {
                                                  final rawUrl =  doc.pvVerComprobante!;
                                                  final uri = Uri.tryParse(rawUrl);
                                                  final safeUri = uri ?? Uri.parse(Uri.encodeFull(rawUrl));
                                                  if (await canLaunchUrl(safeUri)) {
                                                await launchUrl(safeUri, mode: LaunchMode.externalApplication);
                                                }
                                                  else
                                                  {
                                                  debugPrint("Could not launch $safeUri");
                                                  }
                                                },
                                                 ):
                                                Center()
                                            ),
                                            DataCell(
                                              doc.pvTransaccion == "Cargo"? Text(doc.pvTransaccion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                   color:Colors.blue,
                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                )
                                              ):Text(doc.pvTransaccion!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.amber,
                                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                                )),
                                            ),
                                            DataCell(
                                              Text(doc.pvDescripcionMovimiento!,style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                              )),
                                            ),
                                            DataCell(
                                        doc.pmDebito != 0 ? Text(doc.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(doc.pmDebito!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black,
                                                  fontSize: MediaQuery.of(context).size.width * 0.024,
                                                )):Center()
                                            ),
                                            DataCell(
                                             doc.pmCredito != 0 ?  Text(doc.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(doc.pmCredito!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black,
                                                fontSize: MediaQuery.of(context).size.width * 0.024,
                                              )):Center(),
                                            ),
                                            DataCell(
                                                Text(doc.pvMonedaAbreviatura! + formatMoneyWithoutSymbol(doc.pmSaldoActual!).toString(),style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.black,
                                                  fontSize: MediaQuery.of(context).size.width * 0.024,
                                                ))
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                   */
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
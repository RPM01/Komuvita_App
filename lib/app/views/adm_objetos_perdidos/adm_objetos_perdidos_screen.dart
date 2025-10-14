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
import '../../controller/adm_objetos_perdidos_controller.dart';
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

class AdmObjetosPerdidsoScreen extends StatefulWidget {
  const AdmObjetosPerdidsoScreen({super.key});

  @override
  State<AdmObjetosPerdidsoScreen> createState() => _AdmNoticiasScreenState();

//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmNoticiasScreenState extends State<AdmObjetosPerdidsoScreen>
{
  late ThemeData theme;
  AdmObjetosPerdidosController admObjetosPerdidosController = Get.put(AdmObjetosPerdidosController());
  AdmMenuController menuController = Get.put(AdmMenuController());

  TextEditingController criterionBusquedaController  = TextEditingController();
  String userName = "";
  Future<List<Map<String, dynamic>>>? _futurePerdidos;

  TextEditingController encontradoPorController = TextEditingController();
  TextEditingController fechaReporteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String Admin = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();

    setState(() {
 
      theme = admObjetosPerdidosController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;
    });
  }
  getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("NombreUser")!;
      Admin = prefs.getString("Admin")!;
      /*
      instrucionesPago = prefs.getString("intruciones de pago")!;
      debugPrint("Intruciones");
      debugPrint(instrucionesPago);
      pago = instrucionesPago.split('|');
      debugPrint(pago.toString());
       */
      _futurePerdidos = objetosPerdidosSetE5(criterionBusquedaController.text).objetosPerdidos5();

    });

  }

  String formatMoneyWithoutSymbol(double amount) {
    final numberFormat = NumberFormat.decimalPattern('en_US')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return numberFormat.format(amount);
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        backgroundColor:admObjetosPerdidosController.themeController.isDarkMode?admDarkPrimary:admWhiteColor,
        appBar: AppBar(
          backgroundColor: admObjetosPerdidosController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: admObjetosPerdidosController.themeController.isDarkMode
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
                color: admObjetosPerdidosController.themeController.isDarkMode
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
                              color: admObjetosPerdidosController.themeController.isDarkMode
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
                                    admObjetosPerdidosController.themeController.isDarkMode
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

        body: GetBuilder<AdmObjetosPerdidosController>(
            init: admObjetosPerdidosController,
            tag: 'adm_estadoPerdido',
            // theme: theme,
            builder: (admObjetosPerdidosController) => SingleChildScrollView(
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
                                                Text("Criterio",style: theme.textTheme.headlineSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:Color.fromRGBO(6,78,116,1),
                                                  fontSize: MediaQuery.of(context).size.width*0.030,
                                                )),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.45,
                                                  child: TextFormField(
                                                    controller: criterionBusquedaController ,

                                                    onChanged: (value) {
                                                      criterionBusquedaController .text = value;
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      criterionBusquedaController .text = value;
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
                                                onPressed: () async{
                                                  setState(() {

                                                    if(criterionBusquedaController.text.isEmpty)
                                                    {
                                                      setState(() {
                                                        criterionBusquedaController.text = "";
                                                        _futurePerdidos = objetosPerdidosSetE5(criterionBusquedaController.text).objetosPerdidos5();
                                                      });
                                                    }
                                                    else
                                                    {
                                                      setState(() {
                                                        _futurePerdidos = objetosPerdidosSetE5(criterionBusquedaController.text).objetosPerdidos5();
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
                                          Admin == "1" ? Center(
                                            child:  SizedBox(
                                              height: constraints.maxWidth*0.05,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color.fromRGBO(6, 78, 116, 1),
                                                  // set the background color
                                                ),
                                                onPressed: () async{
                                                  showDialog<void>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                                            return AlertDialog(
                                                              title: const Text('Nueva Renta o Venta'),
                                                              content: SingleChildScrollView(
                                                                scrollDirection: Axis .vertical,
                                                                child: Form(
                                                                  key: _formKey,
                                                                  child:  Column(
                                                                    children: <Widget>[
                                                                      Text("Reclamado por:",maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color.fromRGBO(6, 78, 116, 1),
                                                                            fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                      ),
                                                                      TextFormField(
                                                                        controller: encontradoPorController,
                                                                        onChanged: (value)
                                                                        {
                                                                          setStateDialog(() {
                                                                            encontradoPorController.text = value;
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
                                                                      Text("Fecha de reporte encontrado ",maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color.fromRGBO(6, 78, 116, 1),
                                                                            fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                      ),

                                                                      10.height,
                                                                      TextFormField(
                                                                        textInputAction: TextInputAction.next,
                                                                        controller: fechaReporteController,
                                                                        readOnly: true,
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                        onTap: () async {
                                                                          DateTime? fechaSelect = await showDatePicker(
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
                                                                                      minimumSize: Size(2  ,2 ),
                                                                                      foregroundColor: const Color.fromRGBO(6, 78, 116, 1),
                                                                                      textStyle:   TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                child: child!,
                                                                              );
                                                                            },
                                                                          );

                                                                          if (fechaSelect != null) {
                                                                            setState(() {
                                                                              fechaReporteController.text = DateFormat('yyyyMMdd').format(fechaSelect);
                                                                            });
                                                                          }
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          labelText: 'Fecha de pago',
                                                                          border: OutlineInputBorder(),
                                                                        ),
                                                                      ),

                                                                      10.height,

                                                                      Container(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromRGBO(6, 78, 116, 1), // set the background color
                                                                          ),
                                                                          onPressed: () async{
                                                                            debugPrint(event["pn_cosa_perdida"].toString());
                                                                            debugPrint("Reporte");
                                                                            debugPrint(encontradoPorController.text);
                                                                            debugPrint(fechaReporteController.text);
                                                                            String fecha = fechaReporteController.text;
                                                                            debugPrint(fecha);
                                                                            objetosPerdidosSetReporteE6(event["pn_cosa_perdida"].toString(),fecha,encontradoPorController.text).objetosPerdidosReclamo6();
                                                                            encontradoPorController.text = "";
                                                                            fechaReporteController.text = "";
                                                                          },
                                                                          child: Text(
                                                                            "Crear reporte",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color:   Colors.white,
                                                                              fontSize: MediaQuery.of(context).size.width* 0.03,
                                                                            ),
                                                                          ),),
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
                                                child: Text(
                                                  "Reportadar",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: MediaQuery.of(context).size.width*0.035,
                                                  ),
                                                ),),
                                            ),
                                          ):Center(),
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
                ),
                17.height,
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

Future<void> makeApiCall3(String criterio)
async {
  // Example API call
  objetosPerdidosSetE5(criterio);
  await objetosPerdidosSetE5(criterio).objetosPerdidos5();
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
void showImageDialog2(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Image.memory(base64Decode(imageUrl),

      ),
    ),
  );
}
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
import '../../controller/adm_renta_ventas_controller.dart';
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
import 'dart:developer'as devLog;


class AdmRentasVnetasScreen extends StatefulWidget {
  const AdmRentasVnetasScreen({super.key});

  @override
  State<AdmRentasVnetasScreen> createState() => _AdmRentasVentasScreenState();
//State<AdmMenu> createState() => _AdmMenuState();
}

class _AdmRentasVentasScreenState extends State<AdmRentasVnetasScreen> {

  late ThemeData theme;
   Future<List<RentaVentaD5>> ? _futureRentas;
  //AdmHomeController _admRentaVentasController = Get.put(AdmHomeController());
  AdmRentasVnetasController _admRentaVentasController = Get.put(AdmRentasVnetasController());

  AdmMenuController menuController = Get.put(AdmMenuController());
  String userName = "";

  TextEditingController criterionBusquedaController  = TextEditingController();


  TextEditingController descripcionController  = TextEditingController();
  TextEditingController precioController  = TextEditingController();
  TextEditingController infoContactoController  = TextEditingController();

  final Map<int, CarouselSliderController> _controllers = {};
  final Map<int, int> _currentIndex = {};

  List<String>radioTipo =["1","2","-1"];

  late String tipoOpcion = radioTipo[2];
  final _formKey = GlobalKey<FormState>();

  File ? iamgenSelect;

  String base64Image = "";

  List<String> tipoRoV = ["Venta","Renta"];
  List<String> tipoRoV_ID = ["1","0"];
  String ? tipoSelect;
  String tipoSet = "";
  List<String> monedaRoV = ["Quetzal","Dolar"];
  List<String> monedaRoV_ID = ["1","2"];
  String ? monedaSelect;
  String monedaSet = "";


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserInfo();
   // listaDeMonedas().listaMonedas();
    setState(() {
      theme = _admRentaVentasController.themeController.isDarkMode
          ? AdmTheme.admDarkTheme
          : AdmTheme.admLightTheme;

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
        backgroundColor:_admRentaVentasController.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
        appBar: AppBar(
          backgroundColor: _admRentaVentasController.themeController.isDarkMode
              ? admDarkPrimary
              : admWhiteColor,
          centerTitle: true,
          leading: Builder(
            builder: (context) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: _admRentaVentasController.themeController.isDarkMode
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
                color: _admRentaVentasController.themeController.isDarkMode
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
                              color: _admRentaVentasController.themeController.isDarkMode
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
                                    _admRentaVentasController.themeController.isDarkMode
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
                            Text(
                              "Administrador",
                              style: TextStyle(
                                fontSize: 12,
                                color: menuController.themeController.isDarkMode
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
                      itemCount: menuController.helpAndSupport.length,
                      itemBuilder: (context, index) {
                        final isLast = index == menuController.helpAndSupport.length - 1;

                        IconData iconData;
                        switch (index) {
                          case 0: iconData = FontAwesomeIcons.clipboardList; break;
                          case 1: iconData = FontAwesomeIcons.newspaper; break;
                          case 2: iconData = FontAwesomeIcons.doorOpen; break;
                          case 3: iconData = FontAwesomeIcons.boxesStacked; break;
                          case 4: iconData = FontAwesomeIcons.lockOpen; break;
                          case 5: iconData = Icons.logout; break;
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

        body: GetBuilder<AdmRentasVnetasController>(
            init: _admRentaVentasController,
            tag: 'adm_estadoCuenta',
            // theme: theme,
            builder: (_admRentaVentasController) => SingleChildScrollView(
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
                                          Center(
                                            child: Column(
                                            children: [
                                              Text("Criterio",style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:Color.fromRGBO(6,78,116,1),
                                                fontSize: MediaQuery.of(context).size.width*0.060,
                                              )),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*0.45,
                                                child: TextFormField(
                                                  controller: criterionBusquedaController ,
                                                  autofocus: true,
                                                  onChanged: (value) {
                                                    criterionBusquedaController .text = value;
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    criterionBusquedaController .text = value;
                                                  },
                                                ),
                                              ),
                                                ListTile(
                                                  title: Text("Renta"),
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
                                                  title: Text("Ventas"),
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
                                                  _futureRentas = null;
                                                },
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
                                                  final prefs = await SharedPreferences.getInstance();
                                                  setState(() {
                                                      _futureRentas = RentaVentasSetE5(tipoOpcion, criterionBusquedaController.text).listadoRentas5B();;
                                                    //_futureCuentasH7 = ServicioListadoCuenta(prefs.getString("cliente")!,propiedadCuentaID,periodoCuentaID).estadoDeCuentaH7();
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
                                        Center(
                                          child:  SizedBox(
                                            height: 35,
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
                                                                  Text("Descripción del Inmueble",maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Color.fromRGBO(6, 78, 116, 1),
                                                                        fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                  ),
                                                                  TextFormField(
                                                                    controller: descripcionController,
                                                                    onChanged: (value)
                                                                    {
                                                                      setStateDialog(() {
                                                                        descripcionController.text = value;
                                                                      });
                                                                    },
                                                                    validator: (String? value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Información requerida'; // Error message if empty
                                                                      }
                                                                      return null; // Return null if the input is valid
                                                                    },
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text("Tipo",maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color.fromRGBO(6, 78, 116, 1),
                                                                            fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                      ),
                                                                      DropdownButtonFormField<String>(
                                                                        isExpanded: true,
                                                                        value: tipoSelect,
                                                                        hint: const Text("Seleccione renta o venta"),
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
                                                                        items: List.generate(tipoRoV.length, (index) {
                                                                          return DropdownMenuItem<String>(
                                                                            value: tipoRoV_ID[index].toString(),
                                                                            child: Text(
                                                                              "${tipoRoV[index]}",
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            tipoSet = value!;
                                                                            debugPrint(tipoSet);
                                                                            //formaPagoController.text = formapagoDescirpcion[index];
                                                                          });
                                                                        },
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                      ),
                                                                      Text("Moneda",maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color.fromRGBO(6, 78, 116, 1),
                                                                            fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                      ),
                                                                      DropdownButtonFormField<String>(
                                                                        isExpanded: true,
                                                                        value: monedaSelect,
                                                                        hint: const Text("Seleccione su moneda"),
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
                                                                        items: List.generate(monedaRoV.length, (index) {
                                                                          return DropdownMenuItem<String>(
                                                                            value: monedaRoV_ID[index].toString(),
                                                                            child: Text(
                                                                              "${monedaRoV[index]}",
                                                                              style: const TextStyle(

                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            monedaSet = value!;
                                                                            debugPrint(monedaSet);
                                                                            //formaPagoController.text = formapagoDescirpcion[index];
                                                                          });
                                                                        },
                                                                        validator: (String? value) {
                                                                          if (value == null || value.isEmpty) {
                                                                            return 'Información requerida'; // Error message if empty
                                                                          }
                                                                          return null; // Return null if the input is valid
                                                                        },
                                                                      ),
                                                                      Text("Precio",maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: theme.textTheme.headlineSmall?.copyWith(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color.fromRGBO(6, 78, 116, 1),
                                                                            fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                      ),
                                                                    ],
                                                                  ), 10.height,
                                                                  TextFormField(
                                                                    controller: precioController,
                                                                    keyboardType: TextInputType.number,
                                                                    onChanged: (value)
                                                                    {
                                                                      setStateDialog(() {
                                                                        precioController.text = value;
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
                                                                  Text("Informacion de contacto ",maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: theme.textTheme.headlineSmall?.copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Color.fromRGBO(6, 78, 116, 1),
                                                                        fontSize: MediaQuery.of(context).size.width*0.035,)
                                                                  ),
                                                                  10.height,
                                                                  TextFormField(
                                                                    controller: infoContactoController,
                                                                    onChanged: (value)
                                                                    {
                                                                      setStateDialog(() {
                                                                        infoContactoController.text = value;
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
                                                                          fontSize: MediaQuery.of(context).size.width * 0.03,
                                                                        ),
                                                                      ),),
                                                                  ),
                                                                  10.height,
                                                                  iamgenSelect != null ? SizedBox(
                                                                    height:MediaQuery.of(context).size.width*0.4,
                                                                    width: MediaQuery.of(context).size.width*0.4,
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

                                                                        if (_formKey.currentState!.validate()) {
                                                                          if (iamgenSelect == null) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(content: Text("Debe seleccionar una imagen")),
                                                                            );
                                                                            return; // No continúa si no hay imagen
                                                                          }

                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            const SnackBar(content: Text('Procesando datos...')),
                                                                          );

                                                                          File imageFile = File(iamgenSelect!.path);
                                                                          List<int> imageBytes = await imageFile.readAsBytes();
                                                                          setStateDialog(() {
                                                                            base64Image = base64Encode(imageBytes);
                                                                          });
                                                                          debugPrint(tipoSet);
                                                                          debugPrint(descripcionController.text);
                                                                          debugPrint(precioController.text);
                                                                          debugPrint(infoContactoController.text);
                                                                          debugPrint(monedaSet);
                                                                          devLog.log(base64Image);
                                                                             RentaVentasSetE7(tipoSet,descripcionController.text,precioController.text,infoContactoController.text,base64Image,monedaSet).listadoCreacionRentas6B();
                                                                           Get.back();
                                                                          descripcionController.text ="";
                                                                          precioController.text = "";
                                                                          infoContactoController.text = "";
                                                                          }
                                                                        },
                                                                      child: Text(
                                                                        "Crear Venta o renta",
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
                                                "Crear nueva Renta o Venta",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width*0.035,
                                                ),
                                              ),),
                                          ),
                                        ),
                                        17.height,
                                      ],
                                    )
                                ),
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
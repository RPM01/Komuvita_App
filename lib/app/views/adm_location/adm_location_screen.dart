import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constant/adm_colors.dart';
import '../../../constant/adm_images.dart';
import '../../../constant/adm_strings.dart';
import '../../../adm_theme/adm_theme.dart';
import '../../controller/adm_location_controller.dart';

class AdmLocationScreen extends StatefulWidget {
  const AdmLocationScreen({super.key});

  @override
  State<AdmLocationScreen> createState() => _AdmLocationScreenState();
}

class _AdmLocationScreenState extends State<AdmLocationScreen> {
  late ThemeData theme;

  final AdmLocationScreenScreenController controller=Get.put(AdmLocationScreenScreenController());
  @override
  void initState() {
    super.initState();
    theme =controller.themeController.isDarkMode
        ? AdmTheme.admDarkTheme
        : AdmTheme.admLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
      appBar:locationAppBar(),
      body:
      Stack(
        children: [
          _buildMapWidget(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: DropdownButtonFormField<String>(
              icon: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: controller.themeController.isDarkMode ? admWhiteColor : admTextColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                fillColor: controller.themeController.isDarkMode ? admDarkBorderColor : lightGreyColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                disabledBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SvgPicture.asset(
                    locationImage,
                    colorFilter: ColorFilter.mode(
                      controller.themeController.isDarkMode ? admWhiteColor : admTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              hint: Text(
                'Select Distance',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Get.isDarkMode ? admDarkColorGrey : darkGreyColor,
                ),
              ),
              value: controller.selectedDistance.value,
              items: <String>['5 km', '6 km', '7 km', '8 km'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: controller.themeController.isDarkMode ? admWhiteColor : admTextColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  controller.onDistanceChanged(value);
                });
              },
            ),
          )

          // Padding(
          //   padding: const EdgeInsets.all(18.0),
          //   child: Container(
          //     height: 100,
          //     decoration: BoxDecoration(
          //         color: controller.themeController.isDarkMode
          //             ? admDarkPrimary
          //             : admWhiteColor,
          //         //color: Colors.yellow,
          //         borderRadius: BorderRadius.circular(6)),
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 15, right: 15),
          //         child: DropdownButtonFormField<String>(
          //           icon: Icon(
          //             Icons.keyboard_arrow_down_sharp,
          //             color: controller.themeController.isDarkMode
          //                 ? admWhiteColor
          //                 : admTextColor,
          //           ),
          //           decoration: InputDecoration(
          //             isDense: true,
          //             filled: true,
          //             contentPadding: const EdgeInsets.symmetric(
          //                 horizontal: 10, vertical: 20),
          //             fillColor: controller.themeController.isDarkMode
          //                 ? admDarkBorderColor
          //                 : lightGreyColor,
          //             enabledBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(12),
          //                 borderSide:
          //                     const BorderSide(color: Colors.transparent)),
          //             prefixIcon: Padding(
          //               padding: const EdgeInsets.all(18.0),
          //               child: SvgPicture.asset(
          //                 locationImage,
          //                 colorFilter: ColorFilter.mode(
          //                   controller.themeController.isDarkMode
          //                       ? admWhiteColor
          //                       : admTextColor,
          //                   BlendMode.srcIn,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           hint: Text(
          //             radiusArea,
          //             style: theme.textTheme.bodyLarge?.copyWith(
          //                 fontWeight: FontWeight.w400,
          //                 color: Get.isDarkMode
          //                     ? admDarkColorGrey
          //                     : darkGreyColor),
          //           ),
          //           items: <String>['5 km', '6 km', '7 km', '8 km']
          //               .map((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(
          //                 value,
          //                 style: theme.textTheme.bodyLarge?.copyWith(
          //                     fontWeight: FontWeight.w600,
          //                     color: controller.themeController.isDarkMode
          //                         ? admWhiteColor
          //                         : admTextColor),
          //               ),
          //             );
          //           }).toList(),
          //           onChanged: (_) {},
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }

  _buildMapWidget() {
    return FutureBuilder(
      future: controller.getUserLocation(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Get.isDarkMode ? Colors.white : Colors.black),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return(controller.currentLocation!=null)? Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(controller.currentLocation!.latitude!,
                      controller.currentLocation!.longitude!),
                  zoom: 12,
                ),
                markers: controller.markers,
                zoomControlsEnabled: false,
                circles: controller.circles,
                onMapCreated: (GoogleMapController controller) {},


              ),

            ],
          ):Container();
        }
      },
    );
  }



  AppBar locationAppBar(){
    return AppBar(
      centerTitle: true,
      backgroundColor:controller.themeController.isDarkMode?admDarkPrimary:admWhiteColor ,
      leading: Padding(
        padding: const EdgeInsets.all(15),
        child: SvgPicture.asset(
          splashImg, colorFilter:
        const ColorFilter.mode(admColorPrimary, BlendMode.srcIn),
          height: 28,
          width: 29,
          //fit: BoxFit.cover,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(
          menu,
          style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: controller.themeController.isDarkMode ? admWhiteColor : admTextColor),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                searchIcon,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                    controller.themeController.isDarkMode ? admWhiteColor : admTextColor,
                    BlendMode.srcIn),
              )),
        )
      ],
    );

  }
}

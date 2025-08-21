import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:administra/adm_theme/theme_controller.dart';
//import '../../constant/adm_colors.dart'; // For loading JSON files

class AdmLocationScreenScreenController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());
  LocationData? currentLocation;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  RxString selectedDistance = '5 km'.obs;
  Location location = Location();
  List<Map<String, dynamic>> locationsData = [];

  @override
  void onInit() {
    super.onInit();
    loadLocationIcon();
    loadLocationData();
  }

  Future<void> getUserLocation() async {
    // Siempre retorna un valor predeterminado o no hace nada.
    currentLocation = null; // Simula que no se obtiene ninguna ubicación.
    updateCircle();
  }

  Future<void> loadLocationData() async {
    // Carga datos desde el JSON.
    String data = await rootBundle.loadString('assets/administra/data/location.json');
    Map<String, dynamic> jsonResult = json.decode(data);
    locationsData = List<Map<String, dynamic>>.from(jsonResult['locations']);
    updateMapMarkers(); // Actualiza los marcadores en el mapa.
  }

  Future<void> updateMapMarkers() async {
    markers.clear();
    String distanceFilter = selectedDistance.value;

    // Filtra las ubicaciones según la distancia seleccionada.
    List<Map<String, dynamic>> filteredLocations = locationsData
        .where((location) => location['distance'] == distanceFilter)
        .toList();

    for (var location in filteredLocations) {
      markers.add(
        Marker(
          markerId: MarkerId(location['id'].toString()),
          position: LatLng(location['latitude'], location['longitude']),
          icon: BitmapDescriptor.defaultMarker, // Cambiado para simplificar.
        ),
      );
    }

    update(); // Actualiza la UI.
  }

  void onDistanceChanged(String? newDistance) {
    if (newDistance != null) {
      selectedDistance.value = newDistance;
      updateMapMarkers();
    }
  }

  Uint8List? locationIcon;
  Future<void> loadLocationIcon() async {
    // Carga el ícono de ubicación.
    ByteData data = await rootBundle.load('assets/administra/images/location_icon.png');
    locationIcon = data.buffer.asUint8List();
  }

  void updateCircle() {
    // Siempre vacía los círculos, ya que no se obtiene ubicación.
    circles.clear();
    update();
  }
}

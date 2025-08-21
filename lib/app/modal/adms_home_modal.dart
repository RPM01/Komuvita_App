import 'package:get/get.dart';

class AdmsModal {
  int? id;
  String name = '';
  List<String> image = [];
  String distance = '';
  String category = '';
  RxBool isFavorite = false.obs;
  int? rooms;
  int? amenities;
  String size = '';
  String about = '';

  // Constructor
  AdmsModal({
    required this.id,
    required this.name,
    required this.image,
    required this.distance,
    required this.category,
    required bool isFavorite, // Accept bool for initialization
    required this.rooms,
    required this.amenities,
    required this.size,
    required this.about,
  }) : isFavorite = isFavorite.obs; // Initialize RxBool with the provided value

  AdmsModal.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['name'] != null) {
      name = json['name'];
    }

    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
    if (json['distance'] != null) {
      distance = json['distance'];
    }
    if (json['category'] != null) {
      category = json['category'];
    }
    if (json['rooms'] != null) {
      rooms = json['rooms'];
    }
    if (json['amenities'] != null) {
      amenities = json['amenities'];
    }
    if (json['size'] != null) {
      size = json['size'];
    }
    if (json['about'] != null) {
      about = json['about'];
    }

    isFavorite = false.obs;
  }
}

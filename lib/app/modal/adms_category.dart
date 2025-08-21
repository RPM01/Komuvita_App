

import 'package:administra/app/modal/adms_home_modal.dart';

class AdmsCategory {
  int? id;
  String? name;
  String? image;
  List<AdmsModal> admList = [];

  AdmsCategory({required this.id, required this.name, required this.image});

  AdmsCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['adm_list'] != null) {
      admList = List<dynamic>.from(json['adm_list'])
          .map((i) => AdmsModal.fromJson(i))
          .toList();
    }


  }


}

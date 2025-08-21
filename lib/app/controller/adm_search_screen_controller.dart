import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

class AdmSearchScreenController extends GetxController {
  final searchController = TextEditingController().obs;
  List admTypesDetail = [
    {"id": 1, "name": "Dogs", "image": "https://i.ibb.co/4JPbYwn/image.png"},
    {"id": 2, "name": "Cats", "image": "https://i.ibb.co/fxN3V2t/cats.png"},
    {"id": 3, "name": "Rabbits", "image": "https://i.ibb.co/NnY6txG/image.png"},
    {"id": 4, "name": "Birds", "image": "https://i.ibb.co/TMfr6bb/image.png"},
    {
      "id": 5,
      "name": "Reptiles",
      "image": "https://i.ibb.co/QPsVpqy/image.png"
    },
    {"id": 6, "name": "Fish", "image": "https://i.ibb.co/cxD55Dy/image.png"},
    {
      "id": 7,
      "name": "Primates",
      "image": "https://i.ibb.co/RY47Msd/image.png"
    },
    {"id": 8, "name": "Other", "image": "https://i.ibb.co/z6YhBzz/image.png"}
  ];
  List<dynamic> gender = [
    "Any",
    "Male",
    "Female",
  ];
  List<dynamic> size = [
    "Small",
    "Medium",
    "Large",
  ];
  List<dynamic> age = ["Baby", "Young", "Adult", "Senior"];
}

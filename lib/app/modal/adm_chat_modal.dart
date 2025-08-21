class AdmMessageData {
  int? id;
  String message = "";
  String image = "";
  bool isSender = false;
  List<String> images = [];
  AdmMessageData(
      {
        required this.id,
        required this.message,
      required this.image,
      required this.isSender,
      required this.images});
  AdmMessageData.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['message'] != null) {
      message = json['message'];
    }
    if (json['image'] != null) {
      image = json['image'];
    }
    if (json['isSender'] != null) {
      isSender = json['isSender'];
    }
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    }
  }
}

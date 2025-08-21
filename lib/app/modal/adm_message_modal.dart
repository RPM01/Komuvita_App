

class AdmMessageModal {
  int? id;
  String? image;
  String? title;
  String? des;
  String? time;
  String? count;
  String? prefixImage;
  String? suffixImage;
  bool? selected;



  AdmMessageModal({
    required this.id,
    required this.image,
    required this.title,
    required this.des,
    required this.time,
    required this.count,
    required this.prefixImage,
    required this.suffixImage,
    required this.selected

  });

  AdmMessageModal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        title = json['title'],
        des = json['des'],
        time = json['time'],
        count = json['count'],
        prefixImage = json['prefixImage'],
        suffixImage = json['suffixImage'],
        selected = json['selected'];



  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    data['des'] = des;
    data['time'] = time;
    data['count'] = count;
    data['prefixImage'] = prefixImage;
    data['suffixImage'] = suffixImage;
    data['selected'] = selected;
    return data;
  }
}

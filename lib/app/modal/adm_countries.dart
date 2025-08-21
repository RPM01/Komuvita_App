class AdmCountries {
  String name = "";
  String dialCode = "";
  String code = "";

  AdmCountries({required this.name,required this.dialCode,required this.code,});

  AdmCountries.fromJson(Map<String, dynamic> json) {
    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['dial_code'] != null) {
      dialCode = json['dial_code'];
    }
    if (json['code'] != null) {
      code = json['code'];
    }
  }
}

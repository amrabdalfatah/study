class DoctorModel {
  String? doctorId;
  String? fullName;
  String? code;
  String? email;
  String? password;
  String? phone;
  String? image;
  bool? isActive;

  DoctorModel({
    this.doctorId,
    this.email,
    this.password,
    this.phone,
    this.fullName,
    this.code,
    this.image,
    this.isActive = true,
  });

  DoctorModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    doctorId = map['doctorId'];
    fullName = map['fullName'];
    code = map['code'];
    email = map['email'];
    password = map['password'];
    phone = map['phone'];
    image = map['image'];
    isActive = map['isActive'];
  }

  toJson() {
    return {
      'doctorId': doctorId,
      'fullName': fullName,
      'code': code,
      'email': email,
      'password': password,
      'phone': phone,
      'image': image,
      'isActive': isActive,
    };
  }
}

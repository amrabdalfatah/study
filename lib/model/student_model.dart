class StudentModel {
  String? studentId;
  String? fullName;
  String? code;
  String? email;
  String? password;
  String? phone;
  String? image;
  bool? isActive;
  String? deviceId;

  StudentModel({
    this.studentId,
    this.email,
    this.phone,
    this.fullName,
    this.code,
    this.image,
    this.deviceId,
    this.password,
    this.isActive = true,
  });

  StudentModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    studentId = map['studentId'];
    fullName = map['fullName'];
    code = map['code'];
    email = map['email'];
    password = map['password'];
    phone = map['phone'];
    image = map['image'];
    isActive = map['isActive'];
    deviceId = map['deviceId'];
  }

  toJson() {
    return {
      'studentId': studentId,
      'fullName': fullName,
      'code': code,
      'email': email,
      'password': password,
      'phone': phone,
      'image': image,
      'isActive': isActive,
      'deviceId': deviceId,
    };
  }
}

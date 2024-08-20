class StudentModel {
  String? studentId;
  String? fullName;
  String? code;
  String? email;
  String? phone;
  String? image;
  bool? isActive;

  StudentModel({
    this.studentId,
    this.email,
    this.phone,
    this.fullName,
    this.code,
    this.image,
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
    phone = map['phone'];
    image = map['image'];
    isActive = map['isActive'];
  }

  toJson() {
    return {
      'studentId': studentId,
      'fullName': fullName,
      'code': code,
      'email': email,
      'phone': phone,
      'image': image,
      'isActive': isActive,
    };
  }
}

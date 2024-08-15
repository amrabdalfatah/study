class DoctorModel {
  String? doctorId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  bool? isActive;

  DoctorModel({
    this.doctorId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.isActive = true,
  });

  DoctorModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    doctorId = map['doctorId'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    phone = map['phone'];
    image = map['image'];
    isActive = map['isActive'];
  }

  toJson() {
    return {
      'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'isActive': isActive,
    };
  }
}

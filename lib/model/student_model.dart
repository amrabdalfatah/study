class StudentModel {
  String? studentId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  bool? isActive;
  List<String>? courses;

  StudentModel({
    this.studentId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.isActive = true,
    this.courses,
  });

  StudentModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    studentId = map['studentId'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    phone = map['phone'];
    image = map['image'];
    isActive = map['isActive'];
    courses = List.from(map['courses']);
  }

  toJson() {
    return {
      'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'isActive': isActive,
      'courses': courses,
    };
  }
}

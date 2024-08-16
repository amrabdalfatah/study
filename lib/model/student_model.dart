class StudentModel {
  String? studentId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  List? courses;

  StudentModel({
    this.studentId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
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
      'courses': courses,
    };
  }
}

class AdminModel {
  String? adminId;
  String? firstName;
  String? lastName;
  String? email;
  String? image;

  AdminModel({
    this.adminId,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
  });

  AdminModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    adminId = map['adminId'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    image = map['image'];
  }

  toJson() {
    return {
      'adminId': adminId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
    };
  }
}

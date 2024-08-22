class AdminModel {
  String? adminId;
  String? fullName;
  String? email;
  String? image;
  String? phone;

  AdminModel({
    this.adminId,
    this.fullName,
    this.email,
    this.image,
    this.phone,
  });

  AdminModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    adminId = map['adminId'];
    fullName = map['fullName'];
    email = map['email'];
    image = map['image'];
    phone = map['phone'];
  }

  toJson() {
    return {
      'adminId': adminId,
      'fullName': fullName,
      'email': email,
      'image': image,
      'phone': phone,
    };
  }
}

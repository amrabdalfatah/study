class MemberModel {
  String? memberId;
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? cameraId;
  String? faceId;

  MemberModel({
    this.memberId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.cameraId,
    this.faceId,
  });

  MemberModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    memberId = map['memberId'];
    userId = map['userId'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    image = map['image'];
    cameraId = map['cameraId'];
    faceId = map['faceId'];
  }

  toJson() {
    return {
      'memberId': memberId,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'cameraId': cameraId,
      'faceId': faceId,
    };
  }
}
class UserModel {
  String? userId;
  String? faceId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? cameraName;
  String? dateOfBirth;
  Map<String, dynamic>? address;
  String? cameraId;
  String? securityCompany;
  int? numberFamilyMembers;
  int? trainingHours;
  int? report;
  bool? isVerified;
  List<String>? membersId;

  UserModel({
    this.userId,
    this.faceId,
    this.email,
    this.report,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.cameraName,
    this.dateOfBirth,
    this.address,
    this.cameraId,
    this.securityCompany,
    this.numberFamilyMembers,
    this.trainingHours,
    this.isVerified,
    this.membersId,
  });

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    faceId = map['faceId'];
    firstName = map['firstName'];
    report = map['report'];
    lastName = map['lastName'];
    email = map['email'];
    phone = map['phone'];
    image = map['image'];
    cameraName = map['cameraName'];
    dateOfBirth = map['dateOfBirth'];
    address = map['address'];
    cameraId = map['cameraId'];
    securityCompany = map['securityCompany'];
    numberFamilyMembers = map['numberFamilyMembers'];
    trainingHours = map['trainingHours'];
    isVerified = map['isVerified'];
    membersId = List.from(map['membersId']);
  }

  toJson() {
    return {
      'userId': userId,
      'faceId': faceId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'cameraName': cameraName,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'cameraId': cameraId,
      'securityCompany': securityCompany,
      'numberFamilyMembers': numberFamilyMembers,
      'trainingHours': trainingHours,
      'isVerified': isVerified,
      'membersId': membersId,
      'report': report,
    };
  }
}
class AppConstants {
  static String? loginId;
  static String? userId;
  static String? cameraId;
  static TypePerson? typePerson;
}

enum TypePerson {
  owner,
  member,
  securityCompany,
}

enum Alerts {
  training,
  noAlert,
  securityBreach,
  sendSecurity,
}
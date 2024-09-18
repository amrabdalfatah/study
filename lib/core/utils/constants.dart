class AppConstants {
  static const String phoneNumber = '201120075820';
  static const String adminEmail = 'admin@study.academy';
  static String? userId;
  static String? userName;
  static String? userCode;
  static TypePerson? typePerson;
}

enum TypePerson {
  admin,
  student,
  doctor,
}

class Paths {
  static String recording = '/storage/emulated/0/Study Academy/recordings';
}

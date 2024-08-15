import 'package:flutter/material.dart';
import 'package:study_academy/features/admin/add_doctor_screen.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/auth/signin_view.dart';
import 'package:study_academy/features/splash/deatil_app_view.dart';

import 'features/splash/splash_view.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String detailAppRoute = '/detail-app';
  static const String loginRoute = '/login';
  static const String adminHomeRoute = '/admin-home';
  static const String addDoctorRoute = '/admin-home/add-doctor';
  static const String addStudentRoute = '/admin-home/add-student';

  static Route<dynamic>? generateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case addDoctorRoute:
        return MaterialPageRoute(builder: (_) => AddDoctorScreen());
      case adminHomeRoute:
        return MaterialPageRoute(builder: (_) => const AdminHomeView());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => SigninView());
      case detailAppRoute:
        return MaterialPageRoute(builder: (_) => const DeatilAppView());
      case splashRoute:
      default:
        return MaterialPageRoute(builder: (_) => const SplashView());
    }
  }
}

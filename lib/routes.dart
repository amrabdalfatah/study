import 'package:flutter/material.dart';
import 'package:study_academy/features/auth/signin_view.dart';
import 'package:study_academy/features/splash/deatil_app_view.dart';

import 'features/splash/splash_view.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String detailAppRoute = '/detail-app';

  static Route<dynamic>? generateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => SigninView(),
        );
      case detailAppRoute:
        return MaterialPageRoute(
          builder: (_) => const DeatilAppView(),
        );
      case splashRoute:
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
        );
    }
  }
}

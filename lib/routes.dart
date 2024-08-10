import 'package:flutter/material.dart';

import 'features/splash/splash_view.dart';

class AppRoutes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static Route<dynamic>? generateRoutes(RouteSettings setting) {
    switch (setting.name) {
      case splashRoute:
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashView(),
        );
    }
  }
}

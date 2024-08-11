import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/routes.dart';

import 'core/utils/colors.dart';
import 'helper/binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: AppColors.secondaryColor,
      ),
      initialRoute: AppRoutes.splashRoute,
      onGenerateRoute: AppRoutes.generateRoutes,
    );
  }
} 
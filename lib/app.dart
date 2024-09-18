import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/doctor/doctor_homeview.dart';
import 'package:study_academy/features/splash/splash_view.dart';
import 'package:study_academy/features/web/home_web_view.dart';

import 'core/utils/colors.dart';
import 'features/student/student_homeview.dart';
import 'core/helper/binding.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    controller.setUserId();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      // theme: controller.theme,
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundPageColor,
        useMaterial3: false,
      ),
      home: controller.mainScreen,
    );
  }
}

class Controller extends GetxController {
  final box = GetStorage();
  bool get isDark => box.read('darkmode') ?? false;
  String get language => box.read('language') ?? 'English';
  String? get userId => box.read('userid');
  int? get userType => box.read('usertype');
  void setUserId() {
    AppConstants.userId = userId;
  }

  Widget get mainScreen => kIsWeb || Platform.isWindows || Platform.isMacOS
      ? userId == null
          ? const HomeWebView()
          : userType == TypePerson.admin.index
              ? const AdminHomeView()
              : userType == TypePerson.doctor.index
                  ? const DoctorHomeView()
                  : const StudentHomeView()
      : const SplashView();
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();
  void changeTheme(bool val) => box.write('darkmode', val);
  void changeLang(String val) => box.write('language', val);
}

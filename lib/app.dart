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
import 'helper/binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
  String? get userId => box.read('userid');
  int? get userType => box.read('usertype');
  void setUserId() {
    AppConstants.userId = userId;
  }

  Widget get mainScreen => kIsWeb
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
}

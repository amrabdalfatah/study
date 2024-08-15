import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/splash/splash_view.dart';

import 'core/utils/colors.dart';
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
  void setUserId() {
    AppConstants.userId = userId;
  }

  Widget get mainScreen =>
      userId == null ? const SplashView() : const AdminHomeView();
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();
  void changeTheme(bool val) => box.write('darkmode', val);
}

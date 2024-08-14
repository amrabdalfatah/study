import 'package:get/get.dart';
import 'package:study_academy/core/view_model/auth_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    // Get.lazyPut(() => HomeViewModel());
    // Get.lazyPut(() => LocalStorageData());
  }
}

import 'package:get/get.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/view_model/auth_viewmodel.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => AdminViewModel());
    Get.lazyPut(() => StudentViewModel());
    Get.lazyPut(() => DoctorViewModel());
  }
}

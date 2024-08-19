// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:study_academy/core/services/firestore/firestore_admin.dart';
import 'package:study_academy/core/services/firestore/firestore_doctor.dart';
import 'package:study_academy/core/services/firestore/firestore_student.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/doctor/doctor_homeview.dart';
import 'package:study_academy/features/student/student_homeview.dart';
import 'package:study_academy/model/admin_model.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/model/student_model.dart';

class AuthViewModel extends GetxController {
  late final FirebaseAuth _auth;
  late RxBool shownPassword;
  late RxBool action;
  String email = '', password = '';

  @override
  void onInit() {
    super.onInit();
    _auth = FirebaseAuth.instance;
    shownPassword = true.obs;
    action = false.obs;
  }

  // This method to change Password from visible to un_visible
  void changeShownPassword() {
    shownPassword.value = !shownPassword.value;
  }

  // // Method to sign with email and password
  void signInWithEmailAndPassword() async {
    action.value = true;
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final box = GetStorage();
        box.write('userid', value.user!.uid);
        if (email == AppConstants.adminEmail) {
          AppConstants.typePerson = TypePerson.admin;
          box.write('usertype', TypePerson.admin.index);
          AppConstants.userId = value.user!.uid;
          AdminModel? adminData;
          await FireStoreAdmin().getCurrentUser(value.user!.uid).then((value) {
            adminData =
                AdminModel.fromJson(value.data() as Map<dynamic, dynamic>?);
          }).whenComplete(() async {
            if (adminData!.firstName != null) {
              action.value = false;
              Get.offAll(() => const AdminHomeView());
            } else {
              await FireStoreAdmin().addUserToFirestore(
                AdminModel(
                  adminId: AppConstants.userId,
                  firstName: 'Study',
                  lastName: 'Academy',
                  email: AppConstants.adminEmail,
                  phone: AppConstants.phoneNumber,
                  image: '',
                ),
              );
              action.value = false;
              Get.off(() => const AdminHomeView());
            }
          });
        } else if (await FireStoreDoctor().checkDoctor(value.user!.uid)) {
          AppConstants.typePerson = TypePerson.doctor;
          box.write('usertype', TypePerson.doctor.index);
          AppConstants.userId = value.user!.uid;
          DoctorModel? doctorData;
          await FireStoreDoctor()
              .getCurrentDoctor(value.user!.uid)
              .then((value) {
            doctorData =
                DoctorModel.fromJson(value.data() as Map<dynamic, dynamic>?);
          }).whenComplete(() async {
            if (doctorData!.isActive!) {
              action.value = false;
              Get.offAll(() => const DoctorHomeView());
            } else {
              action.value = false;
              Get.snackbar(
                'Error Login',
                'You are not active \nplease contact us to activate your account',
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.red,
              );
            }
          });
        } else {
          AppConstants.typePerson = TypePerson.student;
          box.write('usertype', TypePerson.student.index);
          AppConstants.userId = value.user!.uid;
          StudentModel? studentData;
          await FireStoreStudent()
              .getCurrentStudent(value.user!.uid)
              .then((value) {
            studentData =
                StudentModel.fromJson(value.data() as Map<dynamic, dynamic>?);
          }).whenComplete(() async {
            if (studentData!.isActive!) {
              action.value = false;
              Get.offAll(() => const StudentHomeView());
            } else {
              action.value = false;
              Get.snackbar(
                'Error Login',
                'You are not active \nplease contact us to activate your account',
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.red,
              );
            }
          });
        }
      });
    } catch (e) {
      action.value = false;
      Get.snackbar(
        'Error Login',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }
}

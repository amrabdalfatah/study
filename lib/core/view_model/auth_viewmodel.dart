// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/services/firestore_admin.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/model/admin_model.dart';

class AuthViewModel extends GetxController {
  late final FirebaseAuth _auth;
  // // final LocalStorageData localStorageData = Get.find();
  late RxBool shownPassword;
  late RxBool action;
  String email = '', password = '';
  String userId = '';

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
        AppConstants.loginId = value.user!.uid;
        if (email == AppConstants.adminEmail) {
          AppConstants.typePerson = TypePerson.admin;
          AppConstants.userId = value.user!.uid;
          AdminModel? adminData;
          await FireStoreAdmin().getCurrentUser(value.user!.uid).then((value) {
            adminData =
                AdminModel.fromJson(value.data() as Map<dynamic, dynamic>?);
          }).whenComplete(() async {
            if (adminData!.firstName != null) {
              action.value = false;
              Get.off(() => const AdminHomeView());
            } else {
              await FireStoreAdmin().addUserToFirestore(
                AdminModel(
                  adminId: AppConstants.userId,
                  firstName: 'Study',
                  lastName: 'Academy',
                  email: AppConstants.adminEmail,
                ),
              );
              action.value = false;
              Get.off(() => const AdminHomeView());
            }
          });
        }
        // else if (await FireStoreMember().checkMember(value.user!.uid)) {
        //   AppConstants.typePerson = TypePerson.member;
        //   action.value = false;
        //   Get.offAll(() => const HomeView());
        // } else {
        //   AppConstants.typePerson = TypePerson.securityCompany;
        //   action.value = false;
        //   Get.offAll(() => const SecurityPage());
        // }
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

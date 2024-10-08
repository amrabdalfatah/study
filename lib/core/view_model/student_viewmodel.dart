import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:study_academy/app.dart';
import 'package:study_academy/core/services/firestore/firestore_student.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/student/chat_screen.dart';
import 'package:study_academy/features/student/course_screen.dart';
import 'package:study_academy/features/student/home_screen.dart';
import 'package:study_academy/features/student/profile_screen.dart';
import 'package:study_academy/model/student_model.dart';

class StudentViewModel extends GetxController {
  StudentModel? studentData;

  List<Widget> screens = const [
    HomeScreen(),
    CourseScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];
  List<String> appBars = [
    'Home',
    'Courses',
    'Chat Room',
    'Profile',
  ];
  RxBool action = false.obs;
  ValueNotifier<bool> dataLoaded = ValueNotifier(true);
  ValueNotifier<int> screenIndex = ValueNotifier(0);
  RxInt catIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (!AppConstants.isGuest!) {
      getStudent();
    }
  }

  Future<void> getStudent() async {
    dataLoaded.value = false;
    await FireStoreStudent()
        .getCurrentStudent(AppConstants.userId!)
        .then((value) {
      studentData =
          StudentModel.fromJson(value.data() as Map<dynamic, dynamic>?);
    }).whenComplete(
      () {},
    );
    dataLoaded.value = true;
    update();
  }

  void changeScreen(int selected) {
    screenIndex.value = selected;
    update();
  }

  void changeCat(int index) {
    catIndex.value = index;
    update();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    final box = GetStorage();
    box.remove('userid');
    box.remove('usertype');
    Get.offAll(() => Controller().mainScreen);
  }
}

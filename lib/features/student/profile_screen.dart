import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';
import 'package:study_academy/core/widgets/profile_view.dart';

class ProfileScreen extends GetWidget<StudentViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: ProfileView(
          fullName: controller.studentData!.fullName!,
          image: controller.studentData!.image!,
          email: controller.studentData!.email!,
          phone: controller.studentData!.phone!,
          signOut: () {
            controller.signOut();
          },
        ),
      ),
    );
  }
}

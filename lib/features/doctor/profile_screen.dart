import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';
import 'package:study_academy/core/widgets/profile_view.dart';

class ProfileScreen extends GetWidget<DoctorViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: ProfileView(
          fullName: '${controller.doctorData!.fullName}',
          image: controller.doctorData!.image!,
          email: controller.doctorData!.email!,
          phone: controller.doctorData!.phone!,
          signOut: () {
            controller.signOut();
          },
        ),
      ),
    );
  }
}

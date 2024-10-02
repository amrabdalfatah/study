import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/login_button.dart';
import 'package:study_academy/core/widgets/profile_view.dart';

class ProfileScreen extends GetWidget<StudentViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppConstants.isGuest!
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BigText(
                  text: 'You must Login to load your data',
                  color: Colors.black,
                  size: Dimensions.font16,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Dimensions.height15,
                    right: Dimensions.height15,
                    top: Dimensions.height15,
                  ),
                  child: const LoginButton(),
                ),
              ],
            )
          : Padding(
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

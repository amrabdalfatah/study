import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';
import 'package:study_academy/core/widgets/profile_view.dart';
import 'package:study_academy/model/student_model.dart';

class ProfileScreen extends GetWidget<StudentViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Students')
              .doc(AppConstants.userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            StudentModel? studentModel;
            if (snapshot.hasData) {
              studentModel = StudentModel.fromJson(snapshot.data!.data());
            }
            return ProfileView(
              fullName: studentModel!.fullName!,
              image: studentModel.image!,
              email: studentModel.email!,
              phone: studentModel.phone!,
              signOut: () {
                controller.signOut();
              },
            );
          },
        ),
      ),
    );
  }
}

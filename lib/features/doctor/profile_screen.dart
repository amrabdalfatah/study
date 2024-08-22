import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';
import 'package:study_academy/core/widgets/profile_view.dart';
import 'package:study_academy/model/doctor_model.dart';

class ProfileScreen extends GetWidget<DoctorViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Doctors')
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
            DoctorModel? doctorModel;
            if (snapshot.hasData) {
              doctorModel = DoctorModel.fromJson(snapshot.data!.data());
            }
            return ProfileView(
              fullName: '${doctorModel!.fullName}',
              image: doctorModel.image!,
              email: doctorModel.email!,
              phone: doctorModel.phone!,
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

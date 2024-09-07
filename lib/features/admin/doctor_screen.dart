import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/admin/add_doctor_screen.dart';
import 'package:study_academy/features/admin/widgets/show_doctor.dart';
import 'package:study_academy/model/doctor_model.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Doctors').snapshots(),
          builder: (context, snapshot) {
            List<DoctorModel> doctors = [];
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              doctors = snapshot.data!.docs.map((e) {
                return DoctorModel.fromJson(e.data());
              }).toList();
            }
            return SizedBox(
              child: doctors.isEmpty
                  ? Center(
                      child: SmallText(
                        text: 'You don\'t added Doctors',
                        color: Colors.black,
                        size: Dimensions.font20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Dimensions.height10,
                        crossAxisSpacing: Dimensions.height10,
                        childAspectRatio: kIsWeb ? 1 : 0.7,
                      ),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return ShowDoctor(member: doctors[index]);
                      },
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddDoctorScreen());
        },
        mini: true,
        backgroundColor: AppColors.mainColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

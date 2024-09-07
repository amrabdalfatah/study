import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/student_model.dart';

import 'add_student_screen.dart';
import 'widgets/show_student.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Students').snapshots(),
          builder: (context, snapshot) {
            List<StudentModel> students = [];
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              students = snapshot.data!.docs.map((e) {
                return StudentModel.fromJson(e.data());
              }).toList();
            }
            return SizedBox(
              child: students.isEmpty
                  ? Center(
                      child: SmallText(
                        text: 'You don\'t added Students',
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
                        childAspectRatio: kIsWeb ? 1.0 : 0.6,
                      ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        return ShowStudent(member: students[index]);
                      },
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudentScreen());
        },
        mini: true,
        backgroundColor: AppColors.mainColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

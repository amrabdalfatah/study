import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/features/student/widgets/course_details.dart';
import 'package:study_academy/model/course_model.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Registers')
            .where('studentId', isEqualTo: AppConstants.userId)
            .snapshots(),
        builder: (ctx, snapshot) {
          List<String> coursesId = [];
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasData) {
            coursesId.clear();
            snapshot.data!.docs.forEach((e) {
              coursesId.add(e.data()['courseId']);
            });
          }
          return ListView.separated(
            itemBuilder: (ctx, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Courses')
                    .doc(coursesId[index])
                    .get(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  CourseModel? course;
                  if (snapshot.hasData) {
                    course = CourseModel.fromJson(snapshot.data!.data());
                  }
                  return ListTile(
                    tileColor: Colors.green,
                    title: BigText(
                      text: course!.title!,
                      color: Colors.black,
                      size: Dimensions.font20,
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () {
                      Get.to(
                        () => CourseDetails(
                          course: course!,
                        ),
                      );
                    },
                  );
                },
              );
            },
            separatorBuilder: (ctx, index) => const Divider(),
            itemCount: coursesId.length,
          );
        },
      ),
    );
  }
}

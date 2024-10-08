import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/login_button.dart';
import 'package:study_academy/features/student/widgets/course_details.dart';
import 'package:study_academy/model/course_model.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

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
          : StreamBuilder(
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          minTileHeight: Dimensions.height100,
                          title: BigText(
                            text: course!.title!,
                            color: Colors.black,
                            size: Dimensions.font20,
                            textAlign: TextAlign.start,
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

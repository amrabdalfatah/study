import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/admin/widgets/show_length.dart';
import 'package:study_academy/model/category_model.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/doctor_model.dart';

class HomeScreen extends GetWidget<AdminViewModel> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: ShowLength(title: 'Students'),
                ),
                Expanded(
                  child: ShowLength(title: 'Doctors'),
                ),
              ],
            ),
            const Row(
              children: [
                Expanded(
                  child: ShowLength(title: 'Categories'),
                ),
                Expanded(
                  child: ShowLength(title: 'Courses'),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Courses')
                      .where(
                        'active',
                        isEqualTo: false,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<CourseModel> courses = [];
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      courses = snapshot.data!.docs.map((e) {
                        return CourseModel.fromJson(e.data());
                      }).toList();
                    }
                    return courses.isEmpty
                        ? Center(
                            child: SmallText(
                              text: 'There are not pending courses',
                              color: Colors.black,
                              size: Dimensions.font20,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Doctors')
                                    .doc(courses[index].doctorId)
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
                                  DoctorModel? doctor;
                                  if (snapshot.hasData) {
                                    doctor = DoctorModel.fromJson(
                                        snapshot.data!.data());
                                  }
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('Categories')
                                        .doc(courses[index].categoryId)
                                        .get(),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      }
                                      CategoryModel? category;
                                      if (snapshot.hasData) {
                                        category = CategoryModel.fromJson(
                                            snapshot.data!.data());
                                      }
                                      return Card(
                                        color: AppColors.mainColor,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            Dimensions.height10,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    BigText(
                                                      text:
                                                          'Title: ${courses[index].title!}',
                                                      color: Colors.white,
                                                      size: Dimensions.font20,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[100],
                                                    ),
                                                    SmallText(
                                                      text: 'Status: Pending',
                                                      color: Colors.grey[300],
                                                      size: Dimensions.font16,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SmallText(
                                                      text:
                                                          'By: ${doctor!.firstName} ${doctor.lastName}',
                                                      color: Colors.grey[300],
                                                      size: Dimensions.font16,
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SmallText(
                                                      text:
                                                          'Category: ${category!.title}',
                                                      color: Colors.grey[300],
                                                      size: Dimensions.font16,
                                                      textAlign:
                                                          TextAlign.start,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              controller.action.value
                                                  ? const Center(
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        // TODO: Change active
                                                        controller.acceptCourse(
                                                          courses[index]
                                                              .courseId!,
                                                          doctor!.doctorId!,
                                                        );
                                                        // TODO: Add chat room
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: Dimensions.height10),
                            itemCount: courses.length,
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

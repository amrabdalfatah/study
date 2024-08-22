import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/category_model.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/doctor_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: Dimensions.height15,
          right: Dimensions.height15,
          top: Dimensions.height15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.height100 * 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.mainColor,
                      Colors.blue,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BigText(
                      text: 'Get a unique experience',
                      color: Colors.white,
                      size: Dimensions.font20,
                    ),
                    SmallText(
                      text: 'Great Benefits and Surprices Throughout the year',
                      size: Dimensions.font12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.height10),
            BigText(
              text: 'Categories',
              color: Colors.black,
              size: Dimensions.font20,
            ),
            SizedBox(height: Dimensions.height10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<CategoryModel> categories = [];
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    categories = snapshot.data!.docs.map((e) {
                      return CategoryModel.fromJson(e.data());
                    }).toList();
                  }
                  return SizedBox(
                    child: categories.isEmpty
                        ? Center(
                            child: SmallText(
                              text: 'There is no Categories Added yet',
                              color: Colors.black,
                              size: Dimensions.font20,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Dimensions.height100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    return GetX<StudentViewModel>(
                                      builder: (categoryIndex) {
                                        return GestureDetector(
                                          onTap: () {
                                            categoryIndex.changeCat(index);
                                          },
                                          child: Card(
                                            color:
                                                categoryIndex.catIndex.value ==
                                                        index
                                                    ? AppColors.mainColor
                                                    : Colors.grey[100],
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  Dimensions.height10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        categories[index]
                                                            .image!,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    categories[index].title!,
                                                    style: TextStyle(
                                                      color: categoryIndex
                                                                  .catIndex
                                                                  .value ==
                                                              index
                                                          ? Colors.white
                                                          : null,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: Dimensions.height10),
                              const Divider(),
                              SizedBox(height: Dimensions.height10),
                              BigText(
                                text: 'Courses',
                                color: Colors.black,
                                size: Dimensions.font20,
                              ),
                              SizedBox(height: Dimensions.height10),
                              Expanded(
                                child: GetX<StudentViewModel>(
                                  builder: (catContr) {
                                    return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Courses')
                                            .where(
                                              'active',
                                              isEqualTo: true,
                                            )
                                            .where(
                                              'categoryId',
                                              isEqualTo: categories[
                                                      catContr.catIndex.value]
                                                  .categoryId,
                                            )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          List<CourseModel> courses = [];
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Something went wrong');
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            courses =
                                                snapshot.data!.docs.map((e) {
                                              return CourseModel.fromJson(
                                                  e.data());
                                            }).toList();
                                          }
                                          return courses.isEmpty
                                              ? Center(
                                                  child: SmallText(
                                                    text:
                                                        'There are no courses',
                                                    color: Colors.black,
                                                    size: Dimensions.font20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              : ListView.separated(
                                                  itemBuilder:
                                                      (context, index) {
                                                    return FutureBuilder(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection('Doctors')
                                                          .doc(courses[index]
                                                              .doctorId)
                                                          .get(),
                                                      builder: (ctx, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Text(
                                                              'Something went wrong');
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CupertinoActivityIndicator(),
                                                          );
                                                        }
                                                        DoctorModel? doctor;
                                                        if (snapshot.hasData) {
                                                          doctor = DoctorModel
                                                              .fromJson(snapshot
                                                                  .data!
                                                                  .data());
                                                        }
                                                        return Card(
                                                          color: AppColors
                                                              .mainColor,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                              Dimensions
                                                                  .height10,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                BigText(
                                                                  text:
                                                                      'Title: ${courses[index].title!}',
                                                                  color: Colors
                                                                      .white,
                                                                  size: Dimensions
                                                                      .font20,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                ),
                                                                SmallText(
                                                                  text:
                                                                      'Status: ${courses[index].active! ? 'Active' : 'Pending'}',
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  size: Dimensions
                                                                      .font16,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                SmallText(
                                                                  text:
                                                                      'By: ${doctor!.fullName}',
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  size: Dimensions
                                                                      .font16,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                SmallText(
                                                                  text:
                                                                      'Price: ${courses[index]!.price} \$',
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  size: Dimensions
                                                                      .font16,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          SizedBox(
                                                              height: Dimensions
                                                                  .height10),
                                                  itemCount: courses.length,
                                                );
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';

import 'widgets/course_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.height100 * 2,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'All Courses',
                            color: Colors.black,
                            size: Dimensions.font16,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Courses')
                                .where(
                                  'doctorId',
                                  isEqualTo: AppConstants.userId,
                                )
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int length = 0;
                              if (snapshot.hasData) {
                                length = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$length',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'Pending Courses',
                            color: Colors.black,
                            size: Dimensions.font16,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Courses')
                                .where(
                                  'doctorId',
                                  isEqualTo: AppConstants.userId,
                                )
                                .where(
                                  'active',
                                  isEqualTo: false,
                                )
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int length = 0;
                              if (snapshot.hasData) {
                                length = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$length',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Courses')
                    .where(
                      'doctorId',
                      isEqualTo: AppConstants.userId,
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
                            text: 'You don\'t added Courses',
                            color: Colors.black,
                            size: Dimensions.font20,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: courses[index].active!
                                  ? Colors.green
                                  : Colors.orange,
                              title: BigText(
                                text: courses[index].title!,
                                color: Colors.black,
                                size: Dimensions.font20,
                                textAlign: TextAlign.start,
                              ),
                              subtitle: SmallText(
                                text: courses[index].active!
                                    ? 'Active'
                                    : 'Pending',
                                color: Colors.white,
                                size: Dimensions.font16,
                                textAlign: TextAlign.start,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              onTap: () {
                                Get.to(
                                  () => CourseDetails(
                                    course: courses[index],
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: Dimensions.height10),
                          itemCount: courses.length,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:uuid/uuid.dart';

class AddStudentCourseView extends StatefulWidget {
  final String studentId;
  final String studentName;
  const AddStudentCourseView({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<AddStudentCourseView> createState() => _AddStudentCourseViewState();
}

class _AddStudentCourseViewState extends State<AddStudentCourseView> {
  String courseId = '';
  String courseName = '';
  registerCourseToStudent(
      String courseId, String studentId, bool isRegistered) async {
    const uuid = Uuid();
    final regId = uuid.v4();
    if (!isRegistered) {
      try {
        await FirebaseFirestore.instance
            .collection('Registers')
            .doc(regId)
            .set({
          'courseId': courseId,
          'studentId': studentId,
        });
        await FirebaseFirestore.instance
            .collection('Rooms')
            .doc(courseId)
            .collection('People')
            .add({
          'id': studentId,
        });
        Get.snackbar(
          'Success',
          'Added New Chat for this Course',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );
        Navigator.of(context).pop();
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
        );
      }
    }
  }

  void showRegisterCourse() {
    Get.defaultDialog(
      title: widget.studentName,
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.height10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: 'Select Course',
              size: Dimensions.font16,
              color: Colors.black,
            ),
            SizedBox(height: Dimensions.height15),
            SizedBox(
              height: Dimensions.height64,
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('Courses').get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error when getting data');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  List<CourseModel> courses = [];
                  if (snapshot.hasData) {
                    snapshot.data!.docs.forEach(
                      (element) {
                        courses.add(
                          CourseModel.fromJson(
                            element.data(),
                          ),
                        );
                      },
                    );
                  }

                  courseId = courses[0].courseId!;
                  courseName = courses[0].title!;

                  return DropdownButton<String>(
                    value: courseId,
                    isExpanded: true,
                    padding: EdgeInsets.all(Dimensions.height10),
                    items: List.generate(
                      courses.length,
                      (index) {
                        return DropdownMenuItem(
                          value: courses[index].courseId!,
                          child: Text(courses[index].title!),
                        );
                      },
                    ),
                    onChanged: (value) {
                      courseId = value!;
                    },
                  );
                },
              ),
            ),
            SizedBox(height: Dimensions.height15),
            MainButton(
              text: 'Register Student',
              onTap: () {
                registerCourseToStudent(
                  courseId,
                  widget.studentId,
                  false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Courses for ${widget.studentName}'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Registers')
            .where('studentId', isEqualTo: widget.studentId)
            .snapshots(),
        builder: (ctx, snapshot) {
          List<Map> coursesRegistered = [];
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasData) {
            coursesRegistered = snapshot.data!.docs.map((e) {
              return e.data();
            }).toList();
          }
          return coursesRegistered.isEmpty
              ? Center(
                  child: SmallText(
                    text: 'There are not courses registered',
                    color: Colors.black,
                    size: Dimensions.font20,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Courses')
                          .doc(coursesRegistered[index]['courseId'])
                          .get(),
                      builder: (context, snapshot) {
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
                          onTap: () {},
                          title: Row(
                            children: [
                              kIsWeb
                                  ? SizedBox(
                                      width: Dimensions.width100,
                                      height: Dimensions.height100,
                                      child: null,
                                      // child: WebImage(
                                      //   imageUrl: course!.image!,
                                      // ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      foregroundImage: NetworkImage(
                                        course!.image!,
                                      ),
                                    ),
                              SizedBox(width: Dimensions.width20),
                              BigText(
                                text: course!.title!,
                                color: Colors.black,
                                size: Dimensions.font20,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: coursesRegistered.length,
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showRegisterCourse,
        mini: true,
        backgroundColor: AppColors.mainColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

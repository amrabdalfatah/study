import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/doctor/lessons_details.dart';
import 'package:study_academy/model/course_model.dart';

class CourseDetails extends StatelessWidget {
  final CourseModel course;
  const CourseDetails({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(course.title!),
      ),
      body: Column(
        children: [
          Container(
            height: Dimensions.height100 * 3,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.height20),
                bottomRight: Radius.circular(Dimensions.height20),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.height20),
                bottomRight: Radius.circular(Dimensions.height20),
              ),
              child: Image.network(
                course.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                Dimensions.height10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SmallText(
                        text: 'Status: ',
                        color: Colors.black,
                        size: Dimensions.font20,
                      ),
                      SmallText(
                        text: course.active! ? 'Active' : 'Pending',
                        color: course.active! ? Colors.green : Colors.orange,
                        size: Dimensions.font20,
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Divider(),
                  SizedBox(height: Dimensions.height10),
                  SmallText(
                    text: 'Lessons',
                    color: Colors.black,
                    size: Dimensions.font20,
                  ),
                  SizedBox(height: Dimensions.height10),
                  ListTile(
                    tileColor: AppColors.mainColor,
                    title: BigText(
                      text: 'MidTerm',
                      color: Colors.white,
                      size: Dimensions.font20,
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.to(
                        () => LessonsDetails(
                          course: course,
                          title: 'Midterm',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.height10),
                  ListTile(
                    tileColor: AppColors.mainColor,
                    title: BigText(
                      text: 'Assignments',
                      color: Colors.white,
                      size: Dimensions.font20,
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.to(
                        () => LessonsDetails(
                          course: course,
                          title: 'Assignments',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.height10),
                  ListTile(
                    tileColor: AppColors.mainColor,
                    title: BigText(
                      text: 'Final',
                      color: Colors.white,
                      size: Dimensions.font20,
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Get.to(
                        () => LessonsDetails(
                          course: course,
                          title: 'Final',
                        ),
                      );
                    },
                  ),
                  // Expanded(
                  //   child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('Courses')
                  //         .doc(course.courseId)
                  //         .collection('Lessons')
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       List<LessonModel> lessons = [];
                  //       if (snapshot.hasError) {
                  //         return const Text('Something went wrong');
                  //       }
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //           child: CupertinoActivityIndicator(),
                  //         );
                  //       }
                  //       if (snapshot.hasData) {
                  //         lessons = snapshot.data!.docs.map((e) {
                  //           return LessonModel.fromJson(e.data());
                  //         }).toList();
                  //       }
                  //       return lessons.isEmpty
                  //           ? Center(
                  //               child: SmallText(
                  //                 text: 'You don\'t added Lessons',
                  //                 color: Colors.black,
                  //                 size: Dimensions.font20,
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //             )
                  //           : ListView.separated(
                  //               itemBuilder: (context, index) {
                  //                 return Text('Lesson');
                  //               },
                  //               separatorBuilder: (context, index) =>
                  //                   SizedBox(height: Dimensions.height10),
                  //               itemCount: lessons.length,
                  //             );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.defaultDialog(
      //       title: 'Add Lesson',
      //       content: Container(
      //         width: double.infinity,
      //         padding: EdgeInsets.all(Dimensions.height10),
      //         child: Form(
      //           key: _formKey,
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   SmallText(
      //                     text: 'Title',
      //                     color: Colors.black,
      //                     size: Dimensions.font16,
      //                   ),
      //                   SizedBox(
      //                     height: Dimensions.height10,
      //                   ),
      //                   TextFormField(
      //                     keyboardType: TextInputType.text,
      //                     decoration: InputDecoration(
      //                       contentPadding: EdgeInsets.all(Dimensions.width4),
      //                       border: const OutlineInputBorder(
      //                         borderSide: BorderSide.none,
      //                       ),
      //                       filled: true,
      //                       fillColor: Colors.white,
      //                     ),
      //                     onSaved: (value) {
      //                       controller.lessonTitle = value!;
      //                     },
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please, Enter Title';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: Dimensions.height15,
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   SmallText(
      //                     text: 'Description',
      //                     color: Colors.black,
      //                     size: Dimensions.font16,
      //                   ),
      //                   SizedBox(
      //                     height: Dimensions.height10,
      //                   ),
      //                   TextFormField(
      //                     keyboardType: TextInputType.text,
      //                     decoration: InputDecoration(
      //                       contentPadding: EdgeInsets.all(Dimensions.width4),
      //                       border: const OutlineInputBorder(
      //                         borderSide: BorderSide.none,
      //                       ),
      //                       filled: true,
      //                       fillColor: Colors.white,
      //                     ),
      //                     onSaved: (value) {
      //                       controller.lessonDescription = value!;
      //                     },
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please, Enter Description';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: Dimensions.height15,
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   SmallText(
      //                     text: 'Video Url',
      //                     color: Colors.black,
      //                     size: Dimensions.font16,
      //                   ),
      //                   SizedBox(
      //                     height: Dimensions.height10,
      //                   ),
      //                   TextFormField(
      //                     keyboardType: TextInputType.text,
      //                     decoration: InputDecoration(
      //                       contentPadding: EdgeInsets.all(Dimensions.width4),
      //                       border: const OutlineInputBorder(
      //                         borderSide: BorderSide.none,
      //                       ),
      //                       filled: true,
      //                       fillColor: Colors.white,
      //                     ),
      //                     onSaved: (value) {
      //                       controller.lessonVideoUrl = value!;
      //                     },
      //                     validator: (value) {
      //                       if (value!.isEmpty) {
      //                         return 'Please, Enter Video Url';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ],
      //               ),
      //               GetX<DoctorViewModel>(
      //                 builder: (process) {
      //                   return process.action.value
      //                       ? const Center(
      //                           child: CupertinoActivityIndicator(
      //                             color: AppColors.mainColor,
      //                           ),
      //                         )
      //                       : MainButton(
      //                           text: 'Add Lesson',
      //                           onTap: () {
      //                             _formKey.currentState!.save();
      //                             if (_formKey.currentState!.validate()) {
      //                               controller.addLesson(
      //                                 context,
      //                                 course.courseId!,
      //                               );
      //                             }
      //                           },
      //                         );
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      //   mini: true,
      //   backgroundColor: AppColors.mainColor,
      //   child: const Icon(CupertinoIcons.add),
      // ),
    );
  }
}

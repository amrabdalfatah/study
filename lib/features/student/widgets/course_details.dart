import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';

import '../lessons_details.dart';

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
              child: kIsWeb
                  ? null
                  // ? WebImage(imageUrl: course.image!)
                  : Image.network(
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
                  const Divider(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

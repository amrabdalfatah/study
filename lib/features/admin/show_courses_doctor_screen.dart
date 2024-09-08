import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';

class ShowCoursesDoctorScreen extends StatelessWidget {
  final String doctorId;
  const ShowCoursesDoctorScreen({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text('Courses'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Courses')
              .where('doctorId', isEqualTo: doctorId)
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
            return SizedBox(
              child: courses.isEmpty
                  ? Center(
                      child: SmallText(
                        text: 'This Doctor has not added any course',
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
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child: Card(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.height10),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: constraints.maxHeight / 2,
                                        width: double.infinity,
                                        child: kIsWeb
                                            ? null
                                            // ? WebImage(
                                            //     imageUrl: courses[index].image!,
                                            //   )
                                            : Image.network(
                                                courses[index].image!,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      SizedBox(height: Dimensions.height10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BigText(
                                              text: '${courses[index].title}',
                                              color: Colors.black,
                                              size: Dimensions.font16,
                                            ),
                                            SizedBox(
                                                height: Dimensions.height10),
                                            SmallText(
                                              text:
                                                  'Price: ${courses[index].price}',
                                              color: Colors.black,
                                              size: Dimensions.font12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

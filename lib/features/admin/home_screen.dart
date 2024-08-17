import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/admin/widgets/show_length.dart';
import 'package:study_academy/model/course_model.dart';

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
              height: Dimensions.heightImage,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Dimensions.height10,
                  crossAxisSpacing: Dimensions.height10,
                ),
                children: const [
                  ShowLength(title: 'Students'),
                  ShowLength(title: 'Doctors'),
                  ShowLength(title: 'Categories'),
                  ShowLength(title: 'Courses'),
                ],
              ),
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
                                  // Get.to(
                                  //   () => CourseDetails(
                                  //     course: courses[index],
                                  //   ),
                                  // );
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

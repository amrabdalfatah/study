import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TypeView extends StatefulWidget {
  final String title;
  final CourseModel course;
  final String type;
  const TypeView({
    super.key,
    required this.title,
    required this.course,
    required this.type,
  });

  @override
  State<TypeView> createState() => _TypeViewState();
}

class _TypeViewState extends State<TypeView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.course.courseId)
          .collection(widget.title)
          .doc(widget.type == 'Files' ? '1' : '2')
          .collection(widget.type)
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(Dimensions.height10),
            child: const Center(
              child: Text('No Lesson Found'),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        final loadedData = snapshot.data!.docs;
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(Dimensions.height10),
                separatorBuilder: (ctx, index) => const Divider(),
                itemBuilder: (ctx, index) {
                  final video = loadedData[index].data();
                  return ListTile(
                    onTap: () async {
                      final Uri _url = Uri.parse(video['url']);
                      try {
                        await launchUrl(_url);
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'There is an error with this File ${e.toString()}',
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.red,
                        );
                      }
                      // widget.type == 'Files'
                      //     ? Get.to(
                      //         () => ShowPdfScreen(
                      //           title: video['title'],
                      //           url: video['url'],
                      //         ),
                      //       )
                      //     : Get.to(
                      //         () => ShowVideoScreen(
                      //           title: video['title'],
                      //           url: video['url'],
                      //         ),
                      //       );
                    },
                    leading: SmallText(
                      text: '${index + 1}',
                      color: Colors.grey,
                      size: Dimensions.font20,
                    ),
                    title: BigText(
                      text: video['title'],
                      color: Colors.black,
                      size: Dimensions.font16,
                      textAlign: TextAlign.start,
                    ),
                  );
                },
                itemCount: loadedData.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

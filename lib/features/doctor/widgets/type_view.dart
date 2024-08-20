import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/course_model.dart';

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
  final _title = TextEditingController();
  final _url = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _url.dispose();
  }

  _upload() async {
    final enteredTitle = _title.text;
    final enteredUrl = _url.text;

    if (enteredTitle.trim().isEmpty || enteredUrl.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _title.clear();
    _url.clear();

    await FirebaseFirestore.instance
        .collection('Courses')
        .doc(widget.course.courseId)
        .collection(widget.title)
        .doc(widget.type == 'Files' ? '1' : '2')
        .collection(widget.type)
        .add({
      'title': enteredTitle,
      'createdAt': Timestamp.now(),
      'url': enteredUrl,
    });
    Get.back();
    setState(() {});
  }

  void showDialog() {
    Get.defaultDialog(
      title: 'Add Lesson',
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.height10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(Dimensions.width4),
                labelText: 'Lesson Title',
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            TextField(
              controller: _url,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(Dimensions.width4),
                labelText: 'Lesson URL',
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: Dimensions.height15),
            MainButton(
              text: 'Add Lesson',
              onTap: _upload,
            ),
          ],
        ),
      ),
    );
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No Lesson Found'),
                SizedBox(height: Dimensions.height10),
                MainButton(
                  text: 'Add Lesson',
                  onTap: () {
                    showDialog();
                  },
                ),
              ],
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
            SizedBox(height: Dimensions.height10),
            MainButton(
              text: 'Add Lesson',
              onTap: () {
                showDialog();
              },
            ),
          ],
        );
      },
    );
  }
}

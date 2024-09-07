import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/utils/colors.dart';
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
  String videoLesson = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Uint8List? uploadedVideo;
  Future<void> selectedVideo() async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: ['mp4', 'avi', 'mpeg'],
        );
        if (result != null) {
          videoLesson = result.xFiles.first.path;
          uploadedVideo = result.files.single.bytes;
        }
      } else {
        final XFile? pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
        videoLesson = pickedFile!.path;
      }
      setState(() {});
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  bool _isLoading = false;

  _upload() async {
    _isLoading = true;
    final enteredTitle = _title.text;

    if (enteredTitle.trim().isEmpty || videoLesson.isEmpty) {
      return;
    }
    await FirebaseStorage.instance
        .ref()
        .child(
            'courses/${widget.course.title}/${widget.title}/${widget.type}/$enteredTitle')
        .putData(
          uploadedVideo!,
        )
        .then((value) {
      setState(() {
        _isLoading = true;
      });
    });
    final String videoUrl = await FirebaseStorage.instance
        .ref()
        .child(
            'courses/${widget.course.title}/${widget.title}/${widget.type}/$enteredTitle')
        .getDownloadURL();

    await FirebaseFirestore.instance
        .collection('Courses')
        .doc(widget.course.courseId)
        .collection(widget.title)
        .doc(widget.type == 'Files' ? '1' : '2')
        .collection(widget.type)
        .add({
      'title': enteredTitle,
      'createdAt': Timestamp.now(),
      'url': videoUrl,
    });
    setState(() {
      _isLoading = false;
    });
    Get.back();
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
            SizedBox(
              height: Dimensions.height100,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  videoLesson.isEmpty
                      ? Container(
                          height: Dimensions.height100,
                          width: double.infinity,
                          color: Colors.grey[400],
                          child: Center(
                            child: BigText(
                              text: 'Lesson File',
                              color: Colors.white,
                              size: Dimensions.height20,
                            ),
                          ),
                        )
                      : Container(
                          height: Dimensions.height100 + Dimensions.height100,
                          width: double.infinity,
                          color: Colors.grey[400],
                          child: kIsWeb
                              ? Image.network(
                                  videoLesson,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(
                                    videoLesson,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                  GestureDetector(
                    onTap: () {
                      selectedVideo();
                    },
                    child: CircleAvatar(
                      radius: Dimensions.height15,
                      backgroundColor: AppColors.mainColor,
                      child: Icon(
                        CupertinoIcons.video_camera,
                        color: Colors.white,
                        size: Dimensions.height20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height15),
            _isLoading
                ? CupertinoActivityIndicator()
                : MainButton(
                    text: 'Add Lesson',
                    onTap: () {
                      _upload();
                    },
                    // onTap: _upload,
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

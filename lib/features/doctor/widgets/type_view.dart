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

  void selectPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        upload(file.path!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Uint8List? uploadedVideo;
  Future<void> selectedVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      videoLesson = pickedFile!.path;
      upload(videoLesson);
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
  bool isSelected = false;

  upload(String filePath) async {
    final enteredTitle = _title.text;
    setState(() {
      _isLoading = true;
    });
    if (enteredTitle.trim().isEmpty || filePath.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    Navigator.of(context).pop();
    try {
      await FirebaseStorage.instance
          .ref()
          .child(
              'courses/${widget.course.title}/${widget.title}/${widget.type}/$enteredTitle')
          .putFile(
            File(filePath),
          );
      final String fileUrl = await FirebaseStorage.instance
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
        'url': fileUrl,
      });
      Get.snackbar(
        'Success',
        'Uploaded Successfully',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.green,
      );
      _title.clear();
      filePath = '';
      videoLesson = '';
      isSelected = false;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
      _title.clear();
      filePath = '';
      videoLesson = '';
      isSelected = false;
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void showDialog() {
  //   showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         width: double.infinity,
  //         padding: EdgeInsets.all(Dimensions.height10),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: _title,
  //               keyboardType: TextInputType.text,
  //               decoration: InputDecoration(
  //                 contentPadding: EdgeInsets.all(Dimensions.width4),
  //                 labelText: 'Lesson Title',
  //                 border: const OutlineInputBorder(
  //                   borderSide: BorderSide.none,
  //                 ),
  //                 filled: true,
  //                 fillColor: Colors.white,
  //               ),
  //             ),
  //             SizedBox(height: Dimensions.height15),
  //             SizedBox(
  //               height: Dimensions.height100,
  //               width: double.infinity,
  //               child: Builder(
  //                 builder: (context) {
  //                   return Stack(
  //                     alignment: Alignment.bottomRight,
  //                     children: [
  //                       !isSelected
  //                           ? Container(
  //                               height: Dimensions.height100,
  //                               width: double.infinity,
  //                               color: Colors.grey[400],
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: Dimensions.height15,
  //                               ),
  //                               child: Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: BigText(
  //                                       text: 'Select Video',
  //                                       size: Dimensions.font16,
  //                                       color: Colors.black,
  //                                     ),
  //                                   ),
  //                                   GestureDetector(
  //                                     onTap: () async {
  //                                       await selectedVideo();
  //                                       setState(() {});
  //                                     },
  //                                     child: CircleAvatar(
  //                                       radius: Dimensions.height15,
  //                                       backgroundColor: AppColors.mainColor,
  //                                       child: Icon(
  //                                         CupertinoIcons.video_camera,
  //                                         color: Colors.white,
  //                                         size: Dimensions.height20,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                           : Container(
  //                               height:
  //                                   Dimensions.height100 + Dimensions.height100,
  //                               width: double.infinity,
  //                               color: Colors.grey[400],
  //                               child: Center(
  //                                 child: BigText(
  //                                   text: 'Choosed Video Success',
  //                                   color: Colors.black,
  //                                   size: Dimensions.font16,
  //                                 ),
  //                               ),
  //                             ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ),
  //             SizedBox(height: Dimensions.height15),
  //             _isLoading
  //                 ? LinearProgressIndicator()
  //                 : MainButton(
  //                     text: 'Add Lesson',
  //                     onTap: () {
  //                       widget.type == 'Files' ? selectPdf() : selectedVideo();
  //                     },
  //                     // onTap: _upload,
  //                   ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: LinearProgressIndicator(),
          )
        : StreamBuilder(
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
                          showBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(Dimensions.height10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _title,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.all(Dimensions.width4),
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
                                      child: StatefulBuilder(
                                        builder: (context, update) {
                                          return Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              !isSelected
                                                  ? Container(
                                                      height:
                                                          Dimensions.height100,
                                                      width: double.infinity,
                                                      color: Colors.grey[400],
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            Dimensions.height15,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: BigText(
                                                              text:
                                                                  'Select File',
                                                              size: Dimensions
                                                                  .font16,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              widget.type ==
                                                                      'Files'
                                                                  ? selectPdf()
                                                                  : await selectedVideo();

                                                              print('selected');
                                                              update(() {
                                                                isSelected =
                                                                    true;
                                                              });
                                                            },
                                                            child: CircleAvatar(
                                                              radius: Dimensions
                                                                  .height15,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .mainColor,
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .folder_fill,
                                                                color: Colors
                                                                    .white,
                                                                size: Dimensions
                                                                    .height20,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: Dimensions
                                                              .height100 +
                                                          Dimensions.height100,
                                                      width: double.infinity,
                                                      color: Colors.grey[400],
                                                      child: Center(
                                                        child: BigText(
                                                          text:
                                                              'Choosed Success',
                                                          color: Colors.black,
                                                          size:
                                                              Dimensions.font16,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height15),
                                    _isLoading
                                        ? LinearProgressIndicator()
                                        : MainButton(
                                            text: 'Add Lesson',
                                            onTap: () {
                                              widget.type == 'Files'
                                                  ? selectPdf()
                                                  : selectedVideo();
                                            },
                                            // onTap: _upload,
                                          ),
                                  ],
                                ),
                              );
                            },
                          );
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
                      showBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(Dimensions.height10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _title,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.all(Dimensions.width4),
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
                                  child: StatefulBuilder(
                                    builder: (context, update) {
                                      return Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          !isSelected
                                              ? Container(
                                                  height: Dimensions.height100,
                                                  width: double.infinity,
                                                  color: Colors.grey[400],
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimensions.height15,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: BigText(
                                                          text: 'Select Video',
                                                          size:
                                                              Dimensions.font16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          widget.type == 'Files'
                                                              ? selectPdf()
                                                              : await selectedVideo();

                                                          print('selected');
                                                          update(() {
                                                            isSelected = true;
                                                          });
                                                        },
                                                        child: CircleAvatar(
                                                          radius: Dimensions
                                                              .height15,
                                                          backgroundColor:
                                                              AppColors
                                                                  .mainColor,
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .folder_fill,
                                                            color: Colors.white,
                                                            size: Dimensions
                                                                .height20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  height: Dimensions.height100 +
                                                      Dimensions.height100,
                                                  width: double.infinity,
                                                  color: Colors.grey[400],
                                                  child: Center(
                                                    child: BigText(
                                                      text: 'Choosed Success',
                                                      color: Colors.black,
                                                      size: Dimensions.font16,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: Dimensions.height15),
                                _isLoading
                                    ? LinearProgressIndicator()
                                    : MainButton(
                                        text: 'Add Lesson',
                                        onTap: () {
                                          widget.type == 'Files'
                                              ? selectPdf()
                                              : selectedVideo();
                                        },
                                        // onTap: _upload,
                                      ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
  }
}

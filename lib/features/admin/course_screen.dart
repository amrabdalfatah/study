import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/core/widgets/web_image.dart';
import 'package:study_academy/model/category_model.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/doctor_model.dart';

class CourseScreen extends GetWidget<AdminViewModel> {
  CourseScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Categories').snapshots(),
          builder: (context, snapshot) {
            List<CategoryModel> categories = [];
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              categories = snapshot.data!.docs.map((e) {
                return CategoryModel.fromJson(e.data());
              }).toList();
            }
            return SizedBox(
              child: categories.isEmpty
                  ? Center(
                      child: SmallText(
                        text: 'There is no Categories Added yet',
                        color: Colors.black,
                        size: Dimensions.font20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dimensions.height100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return GetX<AdminViewModel>(
                                builder: (categoryIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      categoryIndex.changeCat(index);
                                    },
                                    child: Card(
                                      color:
                                          categoryIndex.catIndex.value == index
                                              ? AppColors.mainColor
                                              : Colors.grey[100],
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(Dimensions.height10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: kIsWeb
                                                  ? SizedBox(
                                                      width:
                                                          Dimensions.width100,
                                                      height:
                                                          Dimensions.height100,
                                                      child: WebImage(
                                                        imageUrl:
                                                            categories[index]
                                                                .image!,
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        categories[index]
                                                            .image!,
                                                      ),
                                                    ),
                                            ),
                                            Text(
                                              categories[index].title!,
                                              style: TextStyle(
                                                color:
                                                    controller.catIndex.value ==
                                                            index
                                                        ? Colors.white
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        const Divider(),
                        SizedBox(height: Dimensions.height10),
                        BigText(
                          text: 'Courses',
                          color: Colors.black,
                          size: Dimensions.font20,
                        ),
                        SizedBox(height: Dimensions.height10),
                        Expanded(
                          child: GetX<AdminViewModel>(
                            builder: (catContr) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Courses')
                                      .where(
                                        'active',
                                        isEqualTo: true,
                                      )
                                      .where(
                                        'categoryId',
                                        isEqualTo:
                                            categories[catContr.catIndex.value]
                                                .categoryId,
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    List<CourseModel> courses = [];
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
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
                                              text: 'There are no courses',
                                              color: Colors.black,
                                              size: Dimensions.font20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : ListView.separated(
                                            itemBuilder: (context, index) {
                                              return FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('Doctors')
                                                    .doc(
                                                        courses[index].doctorId)
                                                    .get(),
                                                builder: (ctx, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        'Something went wrong');
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CupertinoActivityIndicator(),
                                                    );
                                                  }
                                                  DoctorModel? doctor;
                                                  if (snapshot.hasData) {
                                                    doctor =
                                                        DoctorModel.fromJson(
                                                            snapshot.data!
                                                                .data());
                                                  }
                                                  return Card(
                                                    color: AppColors.mainColor,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        Dimensions.height10,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          BigText(
                                                            text:
                                                                'Title: ${courses[index].title!}',
                                                            color: Colors.white,
                                                            size: Dimensions
                                                                .font20,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[100],
                                                          ),
                                                          SmallText(
                                                            text:
                                                                'Status: ${courses[index].active! ? 'Active' : 'Pending'}',
                                                            color: Colors
                                                                .grey[300],
                                                            size: Dimensions
                                                                .font16,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SmallText(
                                                            text:
                                                                'By: ${doctor!.fullName}',
                                                            color: Colors
                                                                .grey[300],
                                                            size: Dimensions
                                                                .font16,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          SmallText(
                                                            text:
                                                                'Category: ${categories[index].title}',
                                                            color: Colors
                                                                .grey[300],
                                                            size: Dimensions
                                                                .font16,
                                                            textAlign:
                                                                TextAlign.start,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                                    height:
                                                        Dimensions.height10),
                                            itemCount: courses.length,
                                          );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setImageCat();
          showBottomSheet(
            context: context,
            backgroundColor: Colors.grey[200],
            builder: (context) {
              return Container(
                // height: Dimensions.height100 * 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.height30),
                    topRight: Radius.circular(Dimensions.height30),
                  ),
                ),
                padding: EdgeInsets.all(Dimensions.height10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BigText(
                        text: 'Add Category',
                        color: AppColors.mainColor,
                        size: Dimensions.font20,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      SizedBox(
                        height: Dimensions.height100,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GetX<AdminViewModel>(
                              builder: (imageCtrl) {
                                return imageCtrl.imageCat!.value.isEmpty
                                    ? CircleAvatar(
                                        radius: Dimensions.height50,
                                        backgroundColor: Colors.grey[400],
                                      )
                                    : CircleAvatar(
                                        radius: Dimensions.height50,
                                        backgroundImage: FileImage(
                                          File(imageCtrl.imageCat!.value),
                                        ),
                                      );
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.onImageCatButtonPressed(
                                  ImageSource.gallery,
                                  context: context,
                                );
                              },
                              child: CircleAvatar(
                                radius: Dimensions.height15,
                                backgroundColor: AppColors.mainColor,
                                child: Icon(
                                  CupertinoIcons.photo_camera,
                                  color: Colors.white,
                                  size: Dimensions.height20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            text: 'Title',
                            color: Colors.black,
                            size: Dimensions.font16,
                          ),
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onSaved: (value) {
                              controller.catTitle = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please, Enter Title';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height15,
                      ),
                      GetX<AdminViewModel>(
                        builder: (process) {
                          return process.action.value
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                    color: AppColors.mainColor,
                                  ),
                                )
                              : MainButton(
                                  text: 'Add Category',
                                  onTap: () {
                                    _formKey.currentState!.save();
                                    if (controller.imageCat!.value.isNotEmpty) {
                                      if (_formKey.currentState!.validate()) {
                                        controller.addCategory(context);
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Image Required',
                                        snackPosition: SnackPosition.TOP,
                                        colorText: Colors.red,
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        mini: true,
        backgroundColor: AppColors.mainColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

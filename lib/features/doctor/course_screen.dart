import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/category_model.dart';

class CourseScreen extends GetWidget<DoctorViewModel> {
  CourseScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.setImageUrl();
    return GetX<DoctorViewModel>(
      builder: (courseCtrl) {
        return courseCtrl.action.value
            ? const Scaffold(
                body: Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.mainColor,
                  ),
                ),
              )
            : Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(Dimensions.height15),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimensions.height100 + Dimensions.height100,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GetX<DoctorViewModel>(
                                  builder: (imageCtrl) {
                                    return imageCtrl.imageCourse!.value.isEmpty
                                        ? Container(
                                            height: Dimensions.height100 +
                                                Dimensions.height100,
                                            width: double.infinity,
                                            color: Colors.grey[400],
                                            child: Center(
                                              child: BigText(
                                                text: 'Course Thumbnail',
                                                color: Colors.white,
                                                size: Dimensions.height20,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: Dimensions.height100 +
                                                Dimensions.height100,
                                            width: double.infinity,
                                            color: Colors.grey[400],
                                            child: Image.file(
                                              File(
                                                  imageCtrl.imageCourse!.value),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.onImageButtonPressed(
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
                                text: 'Course Title',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSaved: (value) {
                                  controller.title = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Course Title';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                text: 'Description',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSaved: (value) {
                                  controller.description = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                text: 'Price',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSaved: (value) {
                                  controller.price = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Price';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                text: 'Category',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Categories')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Error when getting data');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }
                                  List<CategoryModel> categories = [];
                                  if (snapshot.hasData) {
                                    snapshot.data!.docs.forEach(
                                      (element) {
                                        categories.add(CategoryModel.fromJson(
                                            element.data()
                                                as Map<String, dynamic>));
                                      },
                                    );
                                  }
                                  controller.setCategoryId(
                                    categories[0].categoryId!,
                                    categories[0].title!,
                                  );
                                  return GetX<DoctorViewModel>(
                                    builder: (con) {
                                      return DropdownButton<String>(
                                        value: controller.categoryName!.value,
                                        isExpanded: true,
                                        padding:
                                            EdgeInsets.all(Dimensions.height10),
                                        items: List.generate(
                                          categories.length,
                                          (index) {
                                            return DropdownMenuItem(
                                              value: categories[index].title!,
                                              child: Text(
                                                  categories[index].title!),
                                            );
                                          },
                                        ),
                                        onChanged: (value) {
                                          final catId =
                                              categories.firstWhere((element) {
                                            return element.title == value;
                                          }).categoryId;
                                          controller.setCategoryId(
                                              catId!, value!);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height15,
                          ),
                          GetX<DoctorViewModel>(
                            builder: (process) {
                              return process.action.value
                                  ? const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.mainColor,
                                      ),
                                    )
                                  : MainButton(
                                      text: 'Add',
                                      onTap: () {
                                        _formKey.currentState!.save();
                                        if (controller
                                            .imageCourse!.value.isNotEmpty) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            controller.addCourse();
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
                  ),
                ),
              );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';

class AddStudentScreen extends GetWidget<AdminViewModel> {
  AddStudentScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX<AdminViewModel>(
      builder: (dataCtrl) {
        return dataCtrl.action.value
            ? const Scaffold(
                body: Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.mainColor,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.mainColor,
                  leading: IconButton(
                    onPressed: () {
                      controller.setImageUrl();
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Add Student',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(Dimensions.height15),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimensions.height100,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GetX<AdminViewModel>(
                                  builder: (imageCtrl) {
                                    return imageCtrl.imageUrl!.value.isEmpty
                                        ? CircleAvatar(
                                            radius: Dimensions.height50,
                                            backgroundColor: Colors.grey[400],
                                          )
                                        : CircleAvatar(
                                            radius: Dimensions.height50,
                                            backgroundImage: FileImage(
                                              File(
                                                imageCtrl.imageUrl!.value,
                                              ),
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
                                text: 'Full Name',
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
                                  controller.fullName = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Full Name';
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
                                text: 'Code',
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
                                  controller.code = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Code';
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
                                text: 'Phone',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSaved: (value) {
                                  controller.phone = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please, Enter your Phone';
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
                                text: 'Email',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSaved: (value) {
                                  controller.email = value!;
                                },
                                validator: (value) {
                                  final regex = RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                  if (value!.isEmpty) {
                                    return 'Please, Enter Email';
                                  } else if (!regex.hasMatch(value)) {
                                    return 'Email is not valid';
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
                                text: 'Password',
                                color: Colors.black,
                                size: Dimensions.font16,
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              GetX<AdminViewModel>(
                                builder: (ctrl) {
                                  return TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: ctrl.shownPassword.value,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.shownPassword.value
                                              ? Icons.remove_red_eye_rounded
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          controller.changeShownPassword();
                                        },
                                      ),
                                    ),
                                    onSaved: (value) {
                                      controller.password = value!;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please, Enter Password';
                                      } else if (value.length < 6) {
                                        return 'Password is not valid';
                                      }
                                      return null;
                                    },
                                  );
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
                                      text: 'Add',
                                      onTap: () {
                                        _formKey.currentState!.save();
                                        if (controller
                                            .imageUrl!.value.isNotEmpty) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            controller.addStudent();
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

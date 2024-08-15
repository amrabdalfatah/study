import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/small_text.dart';

class AddDoctorScreen extends GetWidget<AdminViewModel> {
  AddDoctorScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Add Doctor',
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
                      CircleAvatar(
                        radius: Dimensions.height50,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: controller.imageDoctorUrl == null
                            ? null
                            : NetworkImage(controller.imageDoctorUrl!),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: Dimensions.height15,
                          backgroundColor: AppColors.mainColor,
                          child: Icon(
                            CupertinoIcons.add,
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
                      text: 'First Name',
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
                        // controller.email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, Enter your Email';
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
                      text: 'Last Name',
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
                        // controller.email = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, Enter your Email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

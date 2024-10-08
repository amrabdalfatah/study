import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/auth_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/auth/widgets/input_field.dart';
import 'package:study_academy/features/student/student_homeview.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthViewModel());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.height50,
                  ),
                  BigText(
                    text: 'Sign In',
                    color: Colors.black,
                    size: Dimensions.font32,
                  ),
                  SmallText(
                    text: 'Enter your info to login to your account',
                    color: Colors.grey,
                    size: Dimensions.font16,
                  ),
                  SizedBox(
                    height: Dimensions.height80,
                    width: double.infinity,
                  ),
                  SizedBox(
                    width: Dimensions.width100 * 3,
                    child: InputField(
                      label: 'Email',
                      isPassword: false,
                      controller: controller,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height15,
                  ),
                  SizedBox(
                    width: Dimensions.width100 * 3,
                    child: InputField(
                      label: 'Password',
                      isPassword: true,
                      controller: controller,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height30,
                  ),
                  SizedBox(
                    width: Dimensions.width100 * 3,
                    child: GetX<AuthViewModel>(
                      builder: (process) {
                        return process.action.value
                            ? const Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.mainColor,
                                ),
                              )
                            : MainButton(
                                text: 'Login',
                                onTap: () {
                                  AppConstants.isGuest = false;
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    controller.signInWithEmailAndPassword();
                                  }
                                },
                              );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height15,
                  ),
                  BigText(
                    text: 'OR Login as Guest',
                    color: Colors.black,
                    size: Dimensions.font16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.height15,
                      vertical: Dimensions.height20,
                    ),
                    child: MainButton(
                      text: 'Go to Home',
                      color: Colors.orange,
                      onTap: () {
                        AppConstants.isGuest = true;
                        Get.to(() => const StudentHomeView());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

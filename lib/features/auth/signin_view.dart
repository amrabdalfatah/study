import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/view_model/auth_viewmodel.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:get/get.dart';

class SigninView extends GetWidget<AuthViewModel> {
  SigninView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                        // controller: _emailController,
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
                          if (controller.email.isEmpty) {
                            return 'Please, Enter your Email';
                          } else if (!regex.hasMatch(value!)) {
                            return 'Your Email is not valid';
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
                      GetX<AuthViewModel>(builder: (authCTRL) {
                        return TextFormField(
                          // controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: authCTRL.shownPassword.value,
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
                            if (controller.password.isEmpty) {
                              return 'Please, Enter your Password';
                            } else if (controller.password.length < 6) {
                              return 'Your Password is not valid';
                            }
                            return null;
                          },
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height30,
                  ),
                  GetX<AuthViewModel>(builder: (process) {
                    return process.action.value
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.mainColor,
                            ),
                          )
                        : MainButton(
                            text: 'Login',
                            onTap: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                controller.signInWithEmailAndPassword();
                              }
                            },
                          );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

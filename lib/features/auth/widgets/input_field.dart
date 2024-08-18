import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/auth_viewmodel.dart';
import 'package:study_academy/core/widgets/small_text.dart';

class InputField extends StatelessWidget {
  final bool isPassword;
  final String label;
  final AuthViewModel controller;

  const InputField({
    super.key,
    required this.isPassword,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(
          text: label,
          color: Colors.black,
          size: Dimensions.font16,
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        isPassword
            ? GetX<AuthViewModel>(
                builder: (authCTRL) {
                  return TextFormField(
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
                },
              )
            : TextFormField(
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
    );
  }
}

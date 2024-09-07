import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/features/auth/signin_view.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.width100 * 2.5,
      height: Dimensions.height50,
      child: MainButton(
        text: 'Go to LogIn',
        onTap: () {
          Get.to(() => SignInView());
        },
      ),
    );
  }
}

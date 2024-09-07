import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/features/auth/signin_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWebView extends StatelessWidget {
  const HomeWebView({super.key});

  Future<void> _launchUrl() async {
    if (!await launchUrl(
      Uri.parse('https://wa.me/${AppConstants.phoneNumber}'),
    )) {
      Get.snackbar(
        'Error',
        'Could not launch URL',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagesStrings.back),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: Dimensions.height45,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: constraints.maxWidth / 3,
                  height: Dimensions.height50,
                  child: MainButton(
                    text: 'Go to LogIn',
                    onTap: () {
                      Get.to(() => SignInView());
                    },
                  ),
                ),
                SizedBox(width: Dimensions.width45),
                SizedBox(
                  width: constraints.maxWidth / 3,
                  height: Dimensions.height50,
                  child: MainButton(
                    text: 'Contact Us to Register',
                    color: Colors.green,
                    onTap: _launchUrl,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

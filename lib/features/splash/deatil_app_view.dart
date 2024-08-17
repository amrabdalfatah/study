import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/features/auth/signin_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DeatilAppView extends StatefulWidget {
  const DeatilAppView({super.key});

  @override
  State<DeatilAppView> createState() => _DeatilAppViewState();
}

class _DeatilAppViewState extends State<DeatilAppView> {
  final Uri _url = Uri.parse('https://wa.me/${AppConstants.phoneNumber}');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.heightImage,
              child: Image.asset(
                ImagesStrings.logo,
              ),
            ),
            SizedBox(
              height: Dimensions.height15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigText(
                  text: 'Finding The ',
                  color: Colors.black,
                  size: Dimensions.font32,
                ),
                BigText(
                  text: 'Perfect',
                  color: Colors.orange,
                  size: Dimensions.font32,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigText(
                  text: 'Course ',
                  color: Colors.orange,
                  size: Dimensions.font32,
                ),
                BigText(
                  text: 'for You',
                  color: Colors.black,
                  size: Dimensions.font32,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.height15,
                right: Dimensions.height15,
                top: Dimensions.height70,
              ),
              child: MainButton(
                text: 'Let\'s get Started',
                onTap: () {
                  Get.to(() => SignInView());
                },
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            ),
            BigText(
              text: 'OR',
              color: Colors.black,
              size: Dimensions.font16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.height15,
                vertical: Dimensions.height20,
              ),
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
  }
}

import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/login_button.dart';
import 'package:study_academy/core/widgets/register_button.dart';

class DeatilAppView extends StatefulWidget {
  const DeatilAppView({super.key});

  @override
  State<DeatilAppView> createState() => _DeatilAppViewState();
}

class _DeatilAppViewState extends State<DeatilAppView> {
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    screenHeight = Dimensions.screenHeight;
  }

  void changeScreen() {
    setState(() {
      screenHeight = Dimensions.screenHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    changeScreen();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.4,
              child: Image.asset(
                ImagesStrings.logo,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
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
                  color: AppColors.mainColor,
                  size: Dimensions.font32,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigText(
                  text: 'Course ',
                  color: AppColors.mainColor,
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
                top: screenHeight * 0.03,
              ),
              child: const LoginButton(),
            ),
            SizedBox(
              height: screenHeight * 0.01,
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
              child: const RegisterButton(),
            ),
          ],
        ),
      ),
    );
  }
}

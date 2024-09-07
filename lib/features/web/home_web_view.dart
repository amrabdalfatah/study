import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/widgets/login_button.dart';
import 'package:study_academy/core/widgets/register_button.dart';

class HomeWebView extends StatelessWidget {
  const HomeWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesStrings.back),
            fit: BoxFit.cover,
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
              LoginButton(),
              SizedBox(width: Dimensions.width45),
              RegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

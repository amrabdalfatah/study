import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';

import 'deatil_app_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        timer.cancel();
        Get.to(() => const DeatilAppView());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(
              Dimensions.height10,
            ),
            child: SizedBox(
              height: Dimensions.height100,
              child: Image.asset(
                ImagesStrings.logo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height15,
            width: double.infinity,
            child: const CupertinoActivityIndicator(
              color: AppColors.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}

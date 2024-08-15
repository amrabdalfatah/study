import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/routes.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.height15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.grey[100],
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BigText(
                    text: 'Add Doctor',
                    color: Colors.black,
                    size: Dimensions.font20,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.addDoctorRoute);
                    },
                    icon: const Icon(
                      CupertinoIcons.add,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';

class ShowInfo extends StatelessWidget {
  final String fullName;
  final String image;
  final String email;
  final String password;
  final String phone;
  final void Function() deactive;
  final void Function() reset;

  const ShowInfo({
    super.key,
    required this.fullName,
    required this.image,
    required this.email,
    required this.password,
    required this.phone,
    required this.deactive,
    required this.reset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kIsWeb
            ? SizedBox(
                height: Dimensions.height100 * 2, child: null // WebImage(
                // imageUrl: image,
                // )
                )
            : CircleAvatar(
                radius: Dimensions.height100,
                backgroundColor: Colors.grey,
                foregroundImage: NetworkImage(image),
              ),
        SizedBox(height: Dimensions.height10),
        ListTile(
          leading: const Icon(
            Icons.person,
            color: Colors.black,
          ),
          title: BigText(
            text: fullName,
            color: Colors.black,
            size: Dimensions.font16,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        ListTile(
          leading: const Icon(
            Icons.email,
            color: Colors.black,
          ),
          title: BigText(
            text: email,
            color: Colors.black,
            size: Dimensions.font16,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        ListTile(
          leading: const Icon(
            Icons.password,
            color: Colors.black,
          ),
          title: BigText(
            text: password,
            color: Colors.black,
            size: Dimensions.font16,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        ListTile(
          leading: const Icon(
            Icons.phone,
            color: Colors.black,
          ),
          title: BigText(
            text: phone,
            color: Colors.black,
            size: Dimensions.font16,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        MainButton(
          text: 'Reset Device',
          onTap: reset,
          color: AppColors.mainColor,
        ),
        SizedBox(height: Dimensions.height10),
        MainButton(
          text: 'Delete',
          onTap: deactive,
          color: Colors.red,
        ),
      ],
    );
  }
}

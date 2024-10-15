import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';

class ProfilePage extends StatelessWidget {
  final String fullName;
  final String? image;
  final String email;
  final String password;
  final String phone;
  final String code;
  final void Function() deactive;
  final void Function()? reset;

  const ProfilePage({
    super.key,
    required this.fullName,
    required this.code,
    required this.image,
    required this.email,
    required this.password,
    required this.phone,
    required this.deactive,
    this.reset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(code),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        // child: ShowInfo(
        //   fullName: fullName,
        //   image: image,
        //   email: email,
        //   password: password,
        //   phone: phone,
        //   deactive: deactive,
        //   reset: reset,
        // ),
        child: Column(
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
                    foregroundImage: image != null
                        ? NetworkImage(image!)
                        : const AssetImage(ImagesStrings.logo),
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
                Icons.code,
                color: Colors.black,
              ),
              title: BigText(
                text: code,
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
            if (reset != null)
              MainButton(
                text: 'Reset Device',
                onTap: reset!,
                color: AppColors.mainColor,
              ),
            SizedBox(height: Dimensions.height10),
            MainButton(
              text: 'Delete',
              onTap: deactive,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

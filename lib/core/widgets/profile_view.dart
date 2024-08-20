import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';

class ProfileView extends StatelessWidget {
  final String fullName;
  final String image;
  final String email;
  final String phone;
  final void Function() signOut;

  const ProfileView({
    super.key,
    required this.fullName,
    required this.image,
    required this.email,
    required this.phone,
    required this.signOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
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
            size: Dimensions.font20,
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
            size: Dimensions.font20,
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
            size: Dimensions.font20,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        MainButton(
          text: 'Sign Out',
          onTap: signOut,
          color: Colors.red,
        ),
      ],
    );
  }
}

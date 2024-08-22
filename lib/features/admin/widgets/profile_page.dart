import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/features/admin/widgets/show_info.dart';

class ProfilePage extends StatelessWidget {
  final String fullName;
  final String image;
  final String email;
  final String password;
  final String phone;
  final void Function() deactive;

  const ProfilePage({
    super.key,
    required this.fullName,
    required this.image,
    required this.email,
    required this.password,
    required this.phone,
    required this.deactive,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: ShowInfo(
          fullName: fullName,
          image: image,
          email: email,
          password: password,
          phone: phone,
          deactive: deactive,
        ),
      ),
    );
  }
}

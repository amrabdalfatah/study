import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorViewModel>(
      init: DoctorViewModel(),
      builder: (controller) {
        return controller.dataLoaded.value
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.mainColor,
                  leading: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        ImagesStrings.logo,
                      ),
                    ),
                  ),
                  title: Text(
                    '${controller.doctorData!.firstName} ${controller.doctorData!.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        controller.signOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                body: controller.screens[controller.screenIndex.value],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: controller.screenIndex.value,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.mainColor,
                  unselectedItemColor: Colors.grey[400],
                  backgroundColor: Colors.white,
                  showSelectedLabels: false,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.book_solid),
                      label: 'Course',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.chat_bubble_2_fill),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled),
                      label: 'Profile',
                    ),
                  ],
                  onTap: controller.changeScreen,
                ),
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}

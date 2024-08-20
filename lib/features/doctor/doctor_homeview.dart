import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
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
                  title: Text(
                    controller.appBars[controller.screenIndex.value],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
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

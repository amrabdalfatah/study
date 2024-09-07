import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/doctor_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorViewModel>(
      init: DoctorViewModel(),
      builder: (controller) {
        return controller.dataLoaded.value
            ? Dimensions.screenWidth > 600
                ? Scaffold(
                    body: Row(
                      children: [
                        SizedBox(
                          width: Dimensions.width100 * 3,
                          child: Drawer(
                            width: double.infinity,
                            child: Column(
                              children: List.generate(
                                controller.appBars.length,
                                (index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        controller.changeScreen(index);
                                      },
                                      title: BigText(
                                        text: controller.appBars[index],
                                        color: controller.screenIndex.value ==
                                                index
                                            ? AppColors.mainColor
                                            : Colors.grey,
                                        size: Dimensions.font20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              controller.screens[controller.screenIndex.value],
                        ),
                      ],
                    ),
                  )
                : Scaffold(
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

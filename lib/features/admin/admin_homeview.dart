import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/utils/image_strings.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminViewModel>(
      init: AdminViewModel(),
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
                        '${controller.adminData!.fullName}',
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
                          icon: Icon(CupertinoIcons.person_crop_square),
                          label: 'Doctors',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.book_solid),
                          label: 'Courses',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.person_2_alt),
                          label: 'Students',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.chat_bubble_2_fill),
                          label: 'Chats',
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

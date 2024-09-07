import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/services/firestore/firestore_student.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/core/widgets/web_image.dart';
import 'package:study_academy/features/admin/add_student_course_view.dart';
import 'package:study_academy/features/admin/widgets/profile_page.dart';
import 'package:study_academy/model/student_model.dart';

class ShowStudent extends StatefulWidget {
  final StudentModel member;
  const ShowStudent({
    super.key,
    required this.member,
  });

  @override
  State<ShowStudent> createState() => _ShowStudentState();
}

class _ShowStudentState extends State<ShowStudent> {
  void deleteStudent(String sId, bool active) async {
    bool newActive = !active;
    await FireStoreStudent().updateStudentInfo(
      key: 'isActive',
      value: newActive,
      studentId: sId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: kIsWeb
                        ? WebImage(
                            imageUrl: widget.member.image!,
                          )
                        : CircleAvatar(
                            radius: Dimensions.height50,
                            backgroundColor: Colors.grey,
                            foregroundImage: NetworkImage(
                              widget.member.image!,
                            ),
                          ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(
                          text: '${widget.member.fullName}',
                          color: Colors.black,
                          size: Dimensions.font16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: widget.member.code!,
                          color: Colors.black,
                          size: Dimensions.font12,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: widget.member.email!,
                          color: Colors.black,
                          size: Dimensions.font12,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: widget.member.phone!,
                          color: Colors.black,
                          size: Dimensions.font12,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: widget.member.isActive! ? 'Active' : 'Deactive',
                          color: widget.member.isActive!
                              ? Colors.green[800]
                              : Colors.red,
                          size: Dimensions.font12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: Dimensions.height10),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                  text: 'Info',
                                  onTap: () {
                                    Get.to(
                                      () => ProfilePage(
                                        fullName: widget.member.fullName!,
                                        image: widget.member.image!,
                                        email: widget.member.email!,
                                        password: widget.member.password!,
                                        phone: widget.member.phone!,
                                        deactive: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return CupertinoAlertDialog(
                                                title: const Text(
                                                    'Delete Student'),
                                                content: Text(
                                                  'Are you sure to ${widget.member.isActive! ? 'deactivate' : 'active'} this student?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      deleteStudent(
                                                        widget
                                                            .member.studentId!,
                                                        widget.member.isActive!,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: Dimensions.width10),
                              Expanded(
                                child: MainButton(
                                  text: 'Courses',
                                  onTap: () {
                                    Get.to(() => AddStudentCourseView(
                                          studentId: widget.member.studentId!,
                                          studentName: widget.member.fullName!,
                                        ));
                                  },
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

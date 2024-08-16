import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/services/firestore_student.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
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
  void deleteStudent(String sId) async {
    await FireStoreStudent().deleteStudent(sId);
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
                  SizedBox(
                    height: constraints.maxHeight / 3,
                    width: double.infinity,
                    child: Image.network(
                      widget.member.image!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(
                          text:
                              '${widget.member.firstName} ${widget.member.lastName}',
                          color: Colors.black,
                          size: Dimensions.font16,
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
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                  text: 'Delete',
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Delete Student'),
                                          content: const Text(
                                            'Are you sure to delete this student?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                deleteStudent(
                                                  widget.member.studentId!,
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
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: Dimensions.width10),
                              Expanded(
                                child: MainButton(
                                  text: 'Courses',
                                  onTap: () {},
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

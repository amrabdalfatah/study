import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/services/firestore_doctor.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/doctor_model.dart';

class ShowDoctor extends StatefulWidget {
  final DoctorModel member;
  const ShowDoctor({
    super.key,
    required this.member,
  });

  @override
  State<ShowDoctor> createState() => _ShowDoctorState();
}

class _ShowDoctorState extends State<ShowDoctor> {
  void deleteDoctor(String dId, bool active) async {
    bool newActive = !active;
    await FireStoreDoctor().updateDoctorInfo(
      key: 'isActive',
      value: newActive,
      doctorId: dId,
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
                                  text: widget.member.isActive!
                                      ? 'Delete'
                                      : 'Active',
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Delete Doctor'),
                                          content: Text(
                                            'Are you sure to ${widget.member.isActive! ? 'deactivate' : 'active'} this doctor?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                deleteDoctor(
                                                  widget.member.doctorId!,
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

import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/doctor_model.dart';

class ShowDoctor extends StatelessWidget {
  final DoctorModel member;
  const ShowDoctor({
    super.key,
    required this.member,
  });

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
                      member.image!,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(
                          text: '${member.firstName} ${member.lastName}',
                          color: Colors.black,
                          size: Dimensions.font16,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: member.email!,
                          color: Colors.black,
                          size: Dimensions.font12,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: member.phone!,
                          color: Colors.black,
                          size: Dimensions.font12,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: member.isActive! ? 'Active' : 'Deactive',
                          color:
                              member.isActive! ? Colors.green[800] : Colors.red,
                          size: Dimensions.font12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: Dimensions.height10),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                  text: 'Delete',
                                  onTap: () {},
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

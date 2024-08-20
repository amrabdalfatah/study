import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/features/doctor/widgets/type_view.dart';
import 'package:study_academy/model/course_model.dart';

class LessonsDetails extends StatelessWidget {
  final String title;
  final CourseModel course;
  const LessonsDetails({
    super.key,
    required this.course,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Files'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TypeView(
              title: title,
              course: course,
              type: 'Files',
            ),
            TypeView(
              title: title,
              course: course,
              type: 'Videos',
            ),
          ],
        ),
      ),
    );
  }
}

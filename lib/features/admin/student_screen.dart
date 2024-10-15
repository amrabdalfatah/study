import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/admin_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/model/student_model.dart';

import 'add_student_screen.dart';
import 'widgets/show_student.dart';

class StudentScreen extends GetWidget<AdminViewModel> {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Students').snapshots(),
          builder: (context, snapshot) {
            List<StudentModel> students = [];
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              students = snapshot.data!.docs.map((e) {
                return StudentModel.fromJson(e.data());
              }).toList();
              controller.setFinalStudents(students);
            }
            return SizedBox(
              child: students.isEmpty
                  ? Center(
                      child: SmallText(
                        text: 'You don\'t added Students',
                        color: Colors.black,
                        size: Dimensions.font20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : ShowStudentsWithSearch(
                      students: students,
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudentScreen());
        },
        mini: true,
        backgroundColor: AppColors.mainColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class ShowStudentsWithSearch extends StatefulWidget {
  const ShowStudentsWithSearch({
    super.key,
    required this.students,
  });

  final List<StudentModel> students;

  @override
  State<ShowStudentsWithSearch> createState() => _ShowStudentsWithSearchState();
}

class _ShowStudentsWithSearchState extends State<ShowStudentsWithSearch> {
  List<StudentModel> studentsHere = [];

  @override
  void initState() {
    super.initState();
    studentsHere = widget.students;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextField(
            onChanged: (val) {
              studentsHere = [];
              widget.students.forEach((student) {
                if (student.email!.contains(val)) {
                  studentsHere.add(student);
                } else if (student.fullName!.contains(val)) {
                  studentsHere.add(student);
                } else if (student.code!.contains(val)) {
                  studentsHere.add(student);
                }
              });
              setState(() {});
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search by email, or code, or full name',
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.height15,
        ),
        BigText(
          text: 'Students',
          color: Colors.black,
          size: Dimensions.font20,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: Dimensions.height15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: studentsHere.length,
            itemBuilder: (context, index) {
              return ShowStudent(
                member: studentsHere[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

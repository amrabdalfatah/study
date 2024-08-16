import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/features/admin/widgets/show_length.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          children: [
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Dimensions.height10,
                  crossAxisSpacing: Dimensions.height10,
                ),
                children: const [
                  ShowLength(title: 'Students'),
                  ShowLength(title: 'Doctors'),
                  ShowLength(title: 'Categories'),
                  ShowLength(title: 'Courses'),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height10),
            SizedBox(
              height: Dimensions.height100,
              width: double.infinity,
              child: ListView(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';

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
                children: [
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'Total Students',
                            color: Colors.black,
                            size: Dimensions.font16,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Students')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int lengthStudent = 0;
                              if (snapshot.hasData) {
                                lengthStudent = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$lengthStudent',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'Total Doctors',
                            color: Colors.black,
                            size: Dimensions.font16,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Doctors')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int lengthDoctor = 0;
                              if (snapshot.hasData) {
                                lengthDoctor = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$lengthDoctor',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'Doctors',
                            color: Colors.black,
                            size: Dimensions.font20,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Doctors')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int lengthDoctor = 0;
                              if (snapshot.hasData) {
                                lengthDoctor = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$lengthDoctor',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridTile(
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BigText(
                            text: 'Doctors',
                            color: Colors.black,
                            size: Dimensions.font20,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Doctors')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error when getting data');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              int lengthDoctor = 0;
                              if (snapshot.hasData) {
                                lengthDoctor = snapshot.data!.docs.length;
                              }
                              return BigText(
                                text: '$lengthDoctor',
                                color: AppColors.mainColor,
                                size: Dimensions.font32,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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

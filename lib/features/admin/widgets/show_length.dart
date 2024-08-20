import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';

class ShowLength extends StatelessWidget {
  final String title;
  const ShowLength({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BigText(
              text: title,
              color: Colors.black,
              size: Dimensions.font20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection(title).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error when getting data');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                int length = 0;
                if (snapshot.hasData) {
                  length = snapshot.data!.docs.length;
                }
                return BigText(
                  text: '$length',
                  color: AppColors.mainColor,
                  size: Dimensions.font32,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

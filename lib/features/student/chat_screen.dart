import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/view_model/student_viewmodel.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/group_chat_page.dart';

class ChatScreen extends GetWidget<StudentViewModel> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Registers')
            .where('studentId', isEqualTo: AppConstants.userId)
            .snapshots(),
        builder: (ctx, snapshot) {
          List<String> roomsId = [];
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasData) {
            roomsId.clear();
            snapshot.data!.docs.forEach((e) {
              roomsId.add(e.data()['courseId']);
            });
          }
          return ListView.separated(
            itemBuilder: (ctx, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Rooms')
                    .doc(roomsId[index])
                    .get(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  Map<String, dynamic> dataRooms = {};
                  if (snapshot.hasData) {
                    dataRooms.clear();
                    dataRooms = snapshot.data!.data()!;
                  }
                  return ListTile(
                    onTap: () {
                      Get.to(
                        () => GroupChatPage(
                          groupName: dataRooms['name'],
                          image: dataRooms['image'],
                          roomId: dataRooms['roomId'],
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      foregroundImage: NetworkImage(
                        dataRooms['image']!,
                      ),
                    ),
                    title: BigText(
                      text: dataRooms['name']!,
                      color: Colors.black,
                      size: Dimensions.font20,
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              );
            },
            separatorBuilder: (ctx, index) => const Divider(),
            itemCount: roomsId.length,
          );
        },
      ),
    );
  }
}

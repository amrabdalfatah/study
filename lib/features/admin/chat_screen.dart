import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/group_chat_page.dart';
import 'package:study_academy/core/widgets/small_text.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
        builder: (context, snapshot) {
          List<Map> rooms = [];
          if (snapshot.hasError) {
            return const Text('Something went wrong'); 
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasData) {
            rooms = snapshot.data!.docs.map((e) {
              return e.data();
            }).toList();
          }
          return rooms.isEmpty
              ? Center(
                  child: SmallText(
                    text: 'There are not chat rooms',
                    color: Colors.black,
                    size: Dimensions.font20,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.to(
                          () => GroupChatPage(
                            groupName: rooms[index]['name'],
                            image: rooms[index]['image'],
                            roomId: rooms[index]['roomId'],
                          ),
                        );
                      },
                      title: Row(
                        children: [
                          kIsWeb
                              ? SizedBox(
                                  width: Dimensions.width100,
                                  height: Dimensions.height100,
                                  child: null,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  foregroundImage: NetworkImage(
                                    rooms[index]['image']!,
                                  ),
                                ),
                          SizedBox(width: Dimensions.width20),
                          BigText(
                            text: rooms[index]['name']!,
                            color: Colors.black,
                            size: Dimensions.font20,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: rooms.length,
                );
        },
      ),
    );
  }
}

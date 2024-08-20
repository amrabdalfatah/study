import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/widgets/chat_messages.dart';
import 'package:study_academy/core/widgets/new_message.dart';

class GroupChatPage extends StatelessWidget {
  final String groupName;
  final String image;
  final String roomId;
  const GroupChatPage({
    super.key,
    required this.groupName,
    required this.image,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              Expanded(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: NetworkImage(
                    image,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              roomId: roomId,
            ),
          ),
          const Divider(),
          NewMessage(
            roomId: roomId,
          ),
        ],
      ),
    );
  }
}

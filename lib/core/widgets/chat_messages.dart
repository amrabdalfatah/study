import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/message_bubble.dart';

class ChatMessages extends StatefulWidget {
  final String roomId;
  const ChatMessages({
    super.key,
    required this.roomId,
  });

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomId)
          .collection('Chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Messages Found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.all(Dimensions.height10),
          reverse: true,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final currentMessageUserId = chatMessage['userId'];
            return GestureDetector(
              onTap: () {
                if (AppConstants.typePerson == TypePerson.admin) {
                  Get.defaultDialog(
                    title: 'Delete',
                    content: const Text('Are you sure to delete this message?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (chatMessage['type'] == 'image') {
                            await FirebaseStorage.instance
                                .refFromURL(chatMessage['text'])
                                .delete();
                          }
                          await FirebaseFirestore.instance
                              .collection('Rooms')
                              .doc(widget.roomId)
                              .collection('Chat')
                              .doc(chatMessage['id'])
                              .delete()
                              .whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  );
                  setState(() {});
                }
              },
              child: MessageBubble.first(
                userImage: null,
                username: chatMessage['userCode'],
                message: chatMessage['text'],
                type: chatMessage['type'],
                isMe: AppConstants.userId == currentMessageUserId,
              ),
            );
          },
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}

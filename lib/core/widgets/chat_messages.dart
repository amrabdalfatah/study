import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  final String roomId;
  const ChatMessages({
    super.key,
    required this.roomId,
  });
  // TODO: Edit Here

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Rooms')
          .doc(roomId)
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
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;
            final bool nextUserIsSame =
                nextMessageUserId == currentMessageUserId;
            // Test this
            return MessageBubble.first(
              userImage: null,
              username: AppConstants.userName,
              message: chatMessage['text'],
              isMe: authUser.uid == currentMessageUserId,
            );
            // if (nextUserIsSame) {
            //   return MessageBubble.next(
            //     message: chatMessage['text'],
            //     isMe: authUser.uid == currentMessageUserId,
            //   );
            // } else {
            //   return MessageBubble.first(
            //     userImage: null,
            //     username: null,
            //     message: chatMessage['text'],
            //     isMe: authUser.uid == currentMessageUserId,
            //   );
            // }
          },
          itemCount: loadedMessages.length,
        );
      },
    );
  }
}

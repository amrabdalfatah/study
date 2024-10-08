// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:study_academy/core/common/enums/enums.dart';
// import 'package:study_academy/core/common/providers/message_reply_provider.dart';
// import 'package:study_academy/core/widgets/loader.dart';
// // import 'package:study_academy/features/rooms/controller/chat_controller.dart';
// import 'package:study_academy/features/rooms/widgets/my_message_card.dart';
// import 'package:study_academy/features/rooms/widgets/sender_message_card.dart';
// import 'package:study_academy/model/message.dart';

// class ChatList extends ConsumerStatefulWidget {
//   final String recieverUserId;
//   final bool isGroupChat;
//   const ChatList({
//     Key? key,
//     required this.recieverUserId,
//     required this.isGroupChat,
//   }) : super(key: key); 

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
// }

// class _ChatListState extends ConsumerState<ChatList> {
//   final ScrollController messageController = ScrollController();

//   @override
//   void dispose() {
//     super.dispose();
//     messageController.dispose();
//   }

//   void onMessageSwipe(
//     String message,
//     bool isMe,
//     MessageEnum messageEnum,
//   ) {
//     ref.read(messageReplyProvider.state).update(
//           (state) => MessageReply(
//             message,
//             isMe,
//             messageEnum,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Message>>(
//         // stream: widget.isGroupChat
//         //     ? ref
//         //         .read(chatControllerProvider)
//         //         .groupChatStream(widget.recieverUserId)
//         //     : ref
//         //         .read(chatControllerProvider)
//         //         .chatStream(widget.recieverUserId),
//         stream: ,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Loader();
//           }

//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             messageController
//                 .jumpTo(messageController.position.maxScrollExtent);
//           });

//           return ListView.builder(
//             controller: messageController,
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final messageData = snapshot.data![index];

//               if (!messageData.isSeen &&
//                   messageData.recieverid ==
//                       FirebaseAuth.instance.currentUser!.uid) {
//                 // ref.read(chatControllerProvider).setChatMessageSeen(
//                 //       context,
//                 //       widget.recieverUserId,
//                 //       messageData.messageId,
//                 //     );
//               }
//               if (messageData.senderId ==
//                   FirebaseAuth.instance.currentUser!.uid) {
//                 return MyMessageCard(
//                   message: messageData.text,
//                   type: messageData.type,
//                   repliedText: messageData.repliedMessage,
//                   username: messageData.repliedTo,
//                   repliedMessageType: messageData.repliedMessageType,
//                   onLeftSwipe: (drag) => onMessageSwipe(
//                     messageData.text,
//                     true,
//                     messageData.type,
//                   ),
//                   isSeen: messageData.isSeen,
//                 );
//               }
//               return SenderMessageCard(
//                 message: messageData.text,
//                 type: messageData.type,
//                 username: messageData.repliedTo,
//                 repliedMessageType: messageData.repliedMessageType,
//                 onRightSwipe: (drag) => onMessageSwipe(
//                   messageData.text,
//                   false,
//                   messageData.type,
//                 ),
//                 repliedText: messageData.repliedMessage,
//               );
//             },
//           );
//         });
//   }
// }

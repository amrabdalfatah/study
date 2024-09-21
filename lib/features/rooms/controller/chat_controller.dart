// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:study_academy/core/common/enums/enums.dart';
// import 'package:study_academy/model/message.dart';

// import '../../../core/common/providers/message_reply_provider.dart';
// import '../../../model/group.dart';
// import '../repository/chat_repository.dart';

// final chatControllerProvider = Provider((ref) {
//   final chatRepository = ref.watch(chatRepositoryProvider);
//   return ChatController(
//     chatRepository: chatRepository,
//     ref: ref,
//   );
// });

// class ChatController {
//   final ChatRepository chatRepository;
//   final ProviderRef ref;
//   ChatController({
//     required this.chatRepository,
//     required this.ref,
//   });

//   Stream<List<Group>> chatGroups() {
//     return chatRepository.getChatGroups();
//   }

//   Stream<List<Message>> chatStream(String recieverUserId) {
//     return chatRepository.getChatStream(recieverUserId);
//   }

//   Stream<List<Message>> groupChatStream(String groupId) {
//     return chatRepository.getGroupChatStream(groupId);
//   }

//   void sendTextMessage(
//     BuildContext context,
//     String text,
//     String recieverUserId,
//     bool isGroupChat,
//   ) {
//     final messageReply = ref.read(messageReplyProvider);
//     ref.read(userDataAuthProvider).whenData(
//           (value) => chatRepository.sendTextMessage(
//             context: context,
//             text: text,
//             recieverUserId: recieverUserId,
//             senderUser: value!,
//             messageReply: messageReply,
//             isGroupChat: isGroupChat,
//           ),
//         );
//     ref.read(messageReplyProvider.state).update((state) => null);
//   }

//   void sendFileMessage(
//     BuildContext context,
//     File file,
//     String recieverUserId,
//     MessageEnum messageEnum,
//     bool isGroupChat,
//   ) {
//     final messageReply = ref.read(messageReplyProvider);
//     ref.read(userDataAuthProvider).whenData(
//           (value) => chatRepository.sendFileMessage(
//             context: context,
//             file: file,
//             recieverUserId: recieverUserId,
//             senderUserData: value!,
//             messageEnum: messageEnum,
//             ref: ref,
//             messageReply: messageReply,
//             isGroupChat: isGroupChat,
//           ),
//         );
//     ref.read(messageReplyProvider.state).update((state) => null);
//   }

//   void setChatMessageSeen(
//     BuildContext context,
//     String recieverUserId,
//     String messageId,
//   ) {
//     chatRepository.setChatMessageSeen(
//       context,
//       recieverUserId,
//       messageId,
//     );
//   }
// }

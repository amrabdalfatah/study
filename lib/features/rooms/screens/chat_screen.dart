// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:study_academy/core/utils/colors.dart';
// import 'package:study_academy/core/widgets/loader.dart';
// import 'package:study_academy/features/rooms/widgets/bottom_chat_field.dart';
// import 'package:study_academy/features/rooms/widgets/chat_list.dart';

// class MobileChatScreen extends ConsumerWidget {
//   static const String routeName = '/mobile-chat-screen';
//   final String name;
//   final String uid;
//   // final bool isGroupChat;
//   // final String profilePic;
//   const MobileChatScreen({
//     super.key,
//     required this.name,
//     required this.uid,
//     // required this.isGroupChat,
//     // required this.profilePic,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appBarColor,
//         // title: isGroupChat
//         //     ? Text(name)
//         //     : null,
//         title: StreamBuilder(
//             // stream: ref.read(authControllerProvider).userDataById(uid),
//             stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Loader();
//               }
//               return Column(
//                 children: [
//                   Text(name),
//                   // Text(
//                   //   snapshot.data!.isOnline ? 'online' : 'offline',
//                   //   style: const TextStyle(
//                   //     fontSize: 13,
//                   //     fontWeight: FontWeight.normal,
//                   //   ),
//                   // ),
//                 ],
//               );
//             }),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ChatList(
//               recieverUserId: uid,
//               // isGroupChat: isGroupChat,
//               isGroupChat: false,
//             ),
//           ),
//           BottomChatField(
//               // recieverUserId: uid,
//               // isGroupChat: isGroupChat,
//               ),
//         ],
//       ),
//     );
//   }
// }

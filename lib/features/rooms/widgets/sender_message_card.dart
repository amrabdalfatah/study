// import 'package:flutter/material.dart';
// import 'package:study_academy/core/common/enums/enums.dart';
// import 'package:study_academy/core/utils/colors.dart';
// import 'package:study_academy/features/rooms/widgets/display_text_image_gif.dart';
// import 'package:swipe_to/swipe_to.dart';

// class SenderMessageCard extends StatelessWidget {
//   const SenderMessageCard({
//     Key? key,
//     required this.message,
//     required this.type,
//     required this.onRightSwipe,
//     required this.repliedText,
//     required this.username,
//     required this.repliedMessageType,
//   }) : super(key: key);
//   final String message;
//   final MessageEnum type;
//   final GestureDragUpdateCallback onRightSwipe;
//   final String repliedText;
//   final String username;
//   final MessageEnum repliedMessageType;

//   @override
//   Widget build(BuildContext context) {
//     final isReplying = repliedText.isNotEmpty; 

//     return SwipeTo(
//       onRightSwipe: onRightSwipe,
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width - 45,
//           ),
//           child: Card(
//             elevation: 1,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             color: senderMessageColor,
//             margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: type == MessageEnum.text
//                       ? const EdgeInsets.only(
//                           left: 10,
//                           right: 30,
//                           top: 5,
//                           bottom: 20,
//                         )
//                       : const EdgeInsets.only(
//                           left: 5,
//                           top: 5,
//                           right: 5,
//                           bottom: 25,
//                         ),
//                   child: Column(
//                     children: [
//                       if (isReplying) ...[
//                         Text(
//                           username,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 3),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: backgroundColor.withOpacity(0.5),
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(
//                                 5,
//                               ),
//                             ),
//                           ),
//                           child: DisplayTextImageGIF(
//                             message: repliedText,
//                             type: repliedMessageType,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                       DisplayTextImageGIF(
//                         message: message,
//                         type: type,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

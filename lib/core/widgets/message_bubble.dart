import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/features/rooms/widgets/display_text_image_gif.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.username,
    required this.fileName,
    required this.message,
    required this.type,
    required this.isMe,
  }) : isFirstInSequence = true;

  final bool isFirstInSequence;
  final String? username;
  final String? fileName;
  final String message;
  final String type;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 18),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: messageColor,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: type == 'text'
                              ? const EdgeInsets.only(
                                  left: 10,
                                  right: 30,
                                  top: 5,
                                  bottom: 20,
                                )
                              : const EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  right: 5,
                                  bottom: 25,
                                ),
                          child: Column(
                            children: [
                              DisplayTextImageGIF(
                                message: message,
                                type: type,
                                fileName: fileName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: isMe
                  //         ? Colors.grey[300]
                  //         : theme.colorScheme.secondary.withAlpha(200),
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: !isMe && isFirstInSequence
                  //           ? Radius.zero
                  //           : const Radius.circular(12),
                  //       topRight: isMe && isFirstInSequence
                  //           ? Radius.zero
                  //           : const Radius.circular(12),
                  //       bottomLeft: const Radius.circular(12),
                  //       bottomRight: const Radius.circular(12),
                  //     ),
                  //   ),
                  //   constraints: const BoxConstraints(maxWidth: 200),
                  //   padding: const EdgeInsets.symmetric(
                  //     vertical: 10,
                  //     horizontal: 14,
                  //   ),
                  //   margin: const EdgeInsets.symmetric(
                  //     vertical: 4,
                  //     horizontal: 12,
                  //   ),
                  //   child: type == 'image'
                  //       ? Container(
                  //           height: Dimensions.height100 * 3,
                  //           width: double.infinity,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.only(
                  //               bottomLeft:
                  //                   Radius.circular(Dimensions.height20),
                  //               bottomRight:
                  //                   Radius.circular(Dimensions.height20),
                  //             ),
                  //           ),
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.only(
                  //               bottomLeft:
                  //                   Radius.circular(Dimensions.height20),
                  //               bottomRight:
                  //                   Radius.circular(Dimensions.height20),
                  //             ),
                  //             child: kIsWeb
                  //                 ? null // WebImage(imageUrl: message)
                  //                 : Image.network(
                  //                     message,
                  //                     fit: BoxFit.contain,
                  //                   ),
                  //           ),
                  //         )
                  //       : Text(
                  //           message,
                  //           style: TextStyle(
                  //             height: 1.3,
                  //             color: isMe
                  //                 ? Colors.black87
                  //                 : theme.colorScheme.onSecondary,
                  //           ),
                  //           softWrap: true,
                  //         ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SenderMessageCard extends StatelessWidget {
  final bool isFirstInSequence;
  final String? username;
  final String? fileName;
  final String message;
  final String type;
  const SenderMessageCard({
    super.key,
    required this.username,
    required this.fileName,
    required this.message,
    required this.type,
  }) : isFirstInSequence = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFirstInSequence) const SizedBox(height: 18),
            if (username != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 13,
                  right: 13,
                ),
                child: Text(
                  username!,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: senderMessageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: type == 'text'
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      children: [
                        DisplayTextImageGIF(
                          message: message,
                          type: type,
                          fileName: fileName,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

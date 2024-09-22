import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/small_text.dart';
import 'package:study_academy/features/rooms/widgets/show_pdf_screen.dart';
import 'package:study_academy/features/rooms/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final String type;
  final String? fileName;
  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return type == 'text'
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
        : type == 'audio'
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                );
              })
            : type == 'video'
                ? VideoPlayerItem(
                    videoUrl: message,
                  )
                : type == 'pdf'
                    ? GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ShowPdfScreen(
                              fileName: fileName ?? 'PDF',
                              fileUrl: message,
                            ),
                          );
                        },
                        child: SizedBox(
                          height: Dimensions.height100 * 2,
                          width: Dimensions.width100 * 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: Dimensions.height100,
                                ),
                              ),
                              if (fileName != null)
                                SmallText(
                                  text: fileName!,
                                  size: Dimensions.font12,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: Dimensions.height100 * 2,
                        width: Dimensions.width100 * 2,
                        child: CachedNetworkImage(
                          imageUrl: message,
                          fit: BoxFit.cover,
                        ),
                      );
  }
}

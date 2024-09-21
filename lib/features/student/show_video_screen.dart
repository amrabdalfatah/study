import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/image_strings.dart';

class ShowVideoScreen extends StatefulWidget {
  final String title;
  final String url;
  const ShowVideoScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ShowVideoScreen> createState() => _ShowVideoScreenState();
}

class _ShowVideoScreenState extends State<ShowVideoScreen> {
  late CachedVideoPlayerPlusController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerPlusController.networkUrl(Uri.parse(
      widget.url,
    ))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !(controller.value.isInitialized)
          ? const Center(child: CupertinoActivityIndicator())
          : AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedVideoPlayerPlus(controller),
                  Image.asset(
                    ImagesStrings.logo,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.1),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:video_player/video_player.dart';

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
  bool isVideoLoading = true;
  late File videoFile;
  late VideoPlayerController _controller;

  @override
  void initState() {
    print(widget.url);
    loadVideo();
    super.initState();
  }

  loadVideo() async {
    try {
      // File cacheFile = await DefaultCacheManager().getSingleFile(widget.url);
      // videoFile = cacheFile;

      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _controller.initialize();

      isVideoLoading = false;
      setState(() {});
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(widget.title),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          color: Colors.black,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}

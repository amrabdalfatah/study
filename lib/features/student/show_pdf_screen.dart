import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';

class ShowPdfScreen extends StatefulWidget {
  final String title;
  final String url;
  const ShowPdfScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ShowPdfScreen> createState() => _ShowPdfScreenState();
}

class _ShowPdfScreenState extends State<ShowPdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('PDF'),
      ),
    );
  }
}

// body: PDF(
//   swipeHorizontal: true,
// ).cachedFromUrl(widget.url),

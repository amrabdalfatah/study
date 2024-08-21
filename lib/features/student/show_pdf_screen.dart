import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
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
      body: PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(widget.url),
    );
  }
}

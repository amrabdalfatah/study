import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_academy/core/utils/colors.dart';

class ShowPdfScreen extends StatefulWidget {
  final String fileName;
  final String fileUrl;
  const ShowPdfScreen({
    super.key,
    required this.fileName,
    required this.fileUrl,
  });

  @override
  State<ShowPdfScreen> createState() => _ShowPdfScreenState();
}

class _ShowPdfScreenState extends State<ShowPdfScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String remotePDFpath = '';

  @override
  void initState() {
    remotePDFpath = widget.fileUrl;
    // createFileOfPdfUrl().then((f) {
    //   setState(() {
    //     // remotePDFpath = f.path;
    //     remotePDFpath = widget.fileUrl;
    //   });
    // });
    super.initState();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = widget.fileUrl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(widget.fileName),
      ),
      body: Stack(
        children: <Widget>[
          const PDF().cachedFromUrl(widget.fileUrl),
          // PDFView(
          //   filePath: remotePDFpath,
          //   enableSwipe: true,
          //   swipeHorizontal: true,
          //   autoSpacing: false,
          //   pageFling: true,
          //   pageSnap: true,
          //   defaultPage: currentPage!,
          //   fitPolicy: FitPolicy.BOTH,
          //   preventLinkNavigation:
          //       false, // if set to true the link is handled in flutter
          //   onRender: (_pages) {
          //     setState(() {
          //       pages = _pages;
          //       isReady = true;
          //     });
          //   },
          //   onError: (error) {
          //     setState(() {
          //       errorMessage = error.toString();
          //     });
          //     print(error.toString());
          //   },
          //   onPageError: (page, error) {
          //     setState(() {
          //       errorMessage = '$page: ${error.toString()}';
          //     });
          //     print('$page: ${error.toString()}');
          //   },
          //   onViewCreated: (PDFViewController pdfViewController) {
          //     _controller.complete(pdfViewController);
          //   },
          //   onLinkHandler: (String? uri) {
          //     print('goto uri: $uri');
          //   },
          //   onPageChanged: (int? page, int? total) {
          //     print('page change: $page/$total');
          //     setState(() {
          //       currentPage = page;
          //     });
          //   },
          // ),
          // errorMessage.isEmpty
          //     ? !isReady
          //         ? Center(
          //             child: CircularProgressIndicator(),
          //           )
          //         : Container()
          //     : Center(
          //         child: Text(errorMessage),
          //       )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

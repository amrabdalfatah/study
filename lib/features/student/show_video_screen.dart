import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            controller.runJavaScript('''
      var element = document.querySelector('#ast-mobile-header.ast-mobile-header-wrap[data-type="dropdown"]');
      if (element) {
        element.style.display = 'none';
      }
    ''');
            isLoading = false;
            setState(() {});
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    // controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoading)
          ? const Center(child: CupertinoActivityIndicator())
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                WebViewWidget(
                  controller: controller,
                ),
                Container(
                  height: Dimensions.height100 * 1.5,
                  color: AppColors.mainColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.height10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: BigText(
                            text: widget.title,
                            color: Colors.white,
                            size: Dimensions.font20,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

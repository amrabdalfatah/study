// import 'package:flutter/material.dart';
// import 'dart:ui_web' as ui;
// import 'dart:html';

// class WebImage extends StatelessWidget {
//   final String imageUrl;
//   const WebImage({
//     super.key,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     ui.platformViewRegistry.registerViewFactory(
//       imageUrl,
//       (_) => ImageElement()
//         ..src = imageUrl
//         ..style.width = '100%'
//         ..style.height = '100%',
//     );
//     return HtmlElementView(
//       viewType: imageUrl,
//     );
//   }
// }

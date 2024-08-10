import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class SmallText extends StatelessWidget {
  const SmallText({
    super.key,
    this.color = Colors.white,
    required this.text,
    this.textAlign = TextAlign.center,
    this.overFlow = TextOverflow.ellipsis,
    this.fontFamily,
    this.fontWeight = FontWeight.w400,
    this.size = 0,
    this.height = 1.2,
  });

  final String text;
  final Color? color;
  final double size;
  final double height;
  final TextOverflow overFlow;
  final TextAlign textAlign;
  final String? fontFamily;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overFlow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        color: color,
        fontSize: size == 0 ? Dimensions.font12 : size,
        height: height,
      ),
    );
  }
}
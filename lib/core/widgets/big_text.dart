import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class BigText extends StatelessWidget {
  const BigText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.textAlign = TextAlign.center,
    this.overFlow = TextOverflow.ellipsis,
    this.fontFamily,
    this.fontWeight = FontWeight.w700,
    this.size = 0,
  });

  final String text;
  final Color? color;
  final double size;
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
      maxLines: 1,
      style: TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size == 0 ? Dimensions.font45 : size,
        fontWeight: fontWeight,
      ),
    );
  }
}

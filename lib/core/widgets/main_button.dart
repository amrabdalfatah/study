
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'small_text.dart';

class MainButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final Color color;
  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppColors.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.height50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Center(
          child: SmallText(
            text: text,
            color: Colors.white,
            fontFamily: "Urbanist",
            fontWeight: FontWeight.w600,
            size: Dimensions.font16,
          ),
        ),
      ),
    );
  }
}
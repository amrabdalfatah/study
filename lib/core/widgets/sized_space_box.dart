import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class SizedSpaceBox extends StatelessWidget {
  const SizedSpaceBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height20,
    );
  }
}
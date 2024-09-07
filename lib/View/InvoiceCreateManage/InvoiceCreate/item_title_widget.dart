import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class BuildItemlTitle extends StatelessWidget {
  const BuildItemlTitle({
    super.key,
    required this.title,
    required this.textAlign,
    this.padding,
    required this.width,
    required this.height,
    required this.alignment,
  });

  final String title;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      child: Text(
        title,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }
}

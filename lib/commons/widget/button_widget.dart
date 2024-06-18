import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  //height default 50
  final String text;
  final Color textColor;
  final Color bgColor;
  final Color? borderColor;

  final VoidCallback function;
  final double? height;
  final double? borderRadius;
  final double sizeTitle;
  final EdgeInsets padding;
  const ButtonWidget({
    super.key,
    this.width,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.function,
    this.borderColor,
    this.height,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.sizeTitle = 14,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        padding: padding,
        height: (height != null) ? height : 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 15),
          border: Border.all(color: borderColor ?? AppColor.WHITE),
          color: bgColor,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: sizeTitle,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

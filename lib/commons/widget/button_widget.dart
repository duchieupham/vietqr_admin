import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  //height default 50
  final String text;
  final Color textColor;
  final Color bgColor;
  final VoidCallback function;
  final double? height;
  final double? borderRadius;
  final double sizeTitle;

  const ButtonWidget({
    Key? key,
    this.width,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.function,
    this.height,
    this.borderRadius,
    this.sizeTitle = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        height: (height != null) ? height : 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 15),
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
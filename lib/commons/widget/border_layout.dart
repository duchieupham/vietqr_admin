import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class BorderLayout extends StatelessWidget {
  final double? width;
  final bool isError;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double borderWidth;

  const BorderLayout({
    super.key,
    this.width,
    required this.isError,
    required this.child,
    this.padding,
    this.height,
    this.borderWidth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: (padding != null) ? padding : null,
      decoration: BoxDecoration(
        border: Border.all(
            color: (isError)
                ? DefaultTheme.RED_TEXT
                : DefaultTheme.GREY_TOP_TAB_BAR,
            width: borderWidth),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}

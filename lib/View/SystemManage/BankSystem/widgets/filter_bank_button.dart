import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'dart:ui' as ui;

class FilterBankSystemButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool isSelect;
  const FilterBankSystemButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: ui.TextDirection.ltr);

        textPainter.layout();

        double textWidth = textPainter.width;
        return InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(right: 30),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => isSelect
                      ? VietQRTheme.gradientColor.brightBlueLinear
                          .createShader(bounds)
                      : VietQRTheme.gradientColor.disableButtonLinear
                          .createShader(bounds),
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.WHITE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 3,
                  width: textWidth,
                  decoration: BoxDecoration(
                    gradient: isSelect
                        ? VietQRTheme.gradientColor.brightBlueLinear
                        : VietQRTheme.gradientColor.disableButtonLinear,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

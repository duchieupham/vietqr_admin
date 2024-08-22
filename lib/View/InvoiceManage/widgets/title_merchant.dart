import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class TitleItemMerchantWidget extends StatelessWidget {
  final double width;
  const TitleItemMerchantWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildItemTitle('STT',
              height: 40,
              width: 40,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('VSO Đại lý',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tên đại lý',
              height: 40,
              width: 200,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Chưa TT (VND)',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Đã TT (VND)',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          Expanded(
            child: Container(
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      // decoration: const BoxDecoration(
      //     border: Border(
      //         left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }
}

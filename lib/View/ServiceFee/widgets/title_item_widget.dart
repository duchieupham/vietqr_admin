import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../commons/constants/configurations/theme.dart';

class TitleItemWidget extends StatelessWidget {
  const TitleItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
      child: Row(
        children: [
          _buildItemTitle('STT',
              height: 50,
              width: 50,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian TT',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Phí TT',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('VSO',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tên đại lý',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('CCCD/MST',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Dịch vụ \nđăng ký',
              height: 50,
              width: 200,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Gói phí',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Nền tảng đăng ký',
              height: 50,
              width: 200,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
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
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(
            fontSize: 12, color: AppColor.BLACK, fontWeight: FontWeight.bold),
      ),
    );
  }
}

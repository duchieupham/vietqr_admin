import 'package:flutter/material.dart';

import '../../../../commons/constants/configurations/theme.dart';

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
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Số tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Mã hóa đơn',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Dịch vụ',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Người thực hiện',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('SĐT',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thông tin thêm',
              height: 50,
              width: 130,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian tạo',
              height: 50,
              width: 150,
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

import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';

class TitleItemBankWidget extends StatelessWidget {
  const TitleItemBankWidget({super.key});

  // final double width;
  // const TitleItemBankWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
      child: Row(
        children: [
          _buildItemTitle('STT',
              height: 40,
              width: 50,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('TK ngân hàng',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Chủ tài khoản',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          // _buildItemTitle('Ngân hàng',
          //     height: 40,
          //     width: 120,
          //     alignment: Alignment.center,
          //     textAlign: TextAlign.center),
          _buildItemTitle('Ngày kích hoạt',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Ngày hết hạn',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Luồng',
              height: 40,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('CCCD/MST/ĐKKD',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('SĐT xác thực',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),

          _buildItemTitle('VSO TK ngân hàng',
              height: 40,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('TK VietQR',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Email',
              height: 40,
              width: 200,
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

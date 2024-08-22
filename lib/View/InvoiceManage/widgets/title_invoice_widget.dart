import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';

class TitleItemInvoiceWidget extends StatelessWidget {
  final double width;
  const TitleItemInvoiceWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildItemTitle('KH thanh toán',
              height: 40,
              width: 200,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tài khoản VietQR',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Mã hoá đơn',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tổng tiền (VND)',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('VSO',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian TT',
              height: 40,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Đại lý',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Hoá đơn',
              height: 40,
              width: 250,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('TK ngân hàng',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Email',
              height: 40,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian tạo',
              height: 40,
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

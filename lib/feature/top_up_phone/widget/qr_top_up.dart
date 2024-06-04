import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';

import '../../../commons/constants/utils/string_utils.dart';
import '../../../models/DTO/qr_code_dto.dart';

class QRTopUp extends StatelessWidget {
  final QRCodeTDTO qrCodeTDTO;
  const QRTopUp({super.key, required this.qrCodeTDTO});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Image.asset(
          'assets/images/logo-vietqr-vn.png',
          width: 110,
          fit: BoxFit.fitWidth,
        ),
        Expanded(
          child: QrImageView(
            data: qrCodeTDTO.qrCode,
            version: QrVersions.auto,
            embeddedImage:
                const AssetImage('assets/images/ic-viet-qr-small.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(25, 25),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'STK: ${qrCodeTDTO.bankAccount}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                image: DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(
                    qrCodeTDTO.imgId,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(qrCodeTDTO.bankname),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          StringUtils.formatNumber(qrCodeTDTO.amount),
          style: const TextStyle(fontSize: 16, color: AppColor.BLUE_TEXT),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(qrCodeTDTO.content),
        const SizedBox(
          height: 8,
        ),
        Text(qrCodeTDTO.userBankName),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ButtonWidget(
            width: 100,
            height: 45,
            text: 'Đóng',
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
            borderRadius: 5,
            function: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

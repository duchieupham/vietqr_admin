import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';
import 'package:vietqr_admin/models/DTO/qr_box_dto.dart';
import 'package:vietqr_admin/models/DTO/service_fee_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';
import '../../../../models/DTO/merchant_dto.dart';

class ItemQrBoxWidget extends StatelessWidget {
  final int index;
  final QrBoxDTO dto;
  const ItemQrBoxWidget({super.key, required this.index, required this.dto});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.macAddr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.boxCode,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.merchantName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.terminalName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.terminalCode,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto.bankAccount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                  Text(
                    dto.bankShortName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.userBankName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.feePackage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.boxAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                dto.certificate,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

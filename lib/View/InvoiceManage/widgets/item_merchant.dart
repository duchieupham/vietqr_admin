import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';

class ItemMerchantWidget extends StatelessWidget {
  final int index;
  final ItemMerchant dto;
  const ItemMerchantWidget({super.key, required this.index, required this.dto});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            width: 40,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(dto.vso).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.vso.isNotEmpty ? dto.vso : '-',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                )),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 200,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(dto.merchantName).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.merchantName.isNotEmpty ? dto.merchantName : '-',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                )),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    StringUtils.formatNumberWithOutVND(
                        dto.pendingAmount.toString()),
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.pendingAmount == 0
                      ? '-'
                      : StringUtils.formatNumberWithOutVND(
                          dto.pendingAmount.toString()),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      color: dto.pendingAmount == 0
                          ? AppColor.BLACK
                          : AppColor.ORANGE_DARK,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    StringUtils.formatNumberWithOutVND(
                        dto.completeAmount.toString()),
                  ).then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColor.WHITE,
                      textColor: AppColor.BLACK,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                },
                child: Text(
                  dto.completeAmount == 0
                      ? '-'
                      : StringUtils.formatNumberWithOutVND(
                          dto.completeAmount.toString()),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      color: dto.completeAmount == 0
                          ? AppColor.BLACK
                          : AppColor.GREEN,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }
}

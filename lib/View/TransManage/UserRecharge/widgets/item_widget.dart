import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';
import '../../../../models/DTO/user_recharge_dto.dart';

class ItemWidget extends StatelessWidget {
  final int index;
  final RechargeItem dto;
  const ItemWidget({super.key, required this.index, required this.dto});

  @override
  Widget build(BuildContext context) {
    String service = '';
    if (dto.paymentType == 0) {
      service = 'Nạp tiền VQR';
    } else if (dto.paymentType == 1) {
      service = 'Nạp tiền điện thoại';
    } else {
      service = 'Phần mềm VietQR';
    }
    bool hasData2 = false;
    if (dto.additionData2 != null || dto.additionData2.isNotEmpty) {
      hasData2 = true;
    }

    return Container(
      // color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
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
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto.timePaid != 0
                        ? DateFormat('dd-MM-yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                dto.timePaid * 1000))
                        : '-',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: dto.timePaid != 0
                            ? FontWeight.normal
                            : FontWeight.bold),
                  ),
                  dto.timePaid != 0
                      ? Text(
                          DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  dto.timePaid * 1000)),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumber(dto.amount.toString()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: dto.status == 0
                      ? AppColor.ORANGE_DARK
                      : (dto.status == 1 ? AppColor.GREEN : AppColor.GREY_TEXT),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.billNumber.isNotEmpty ? dto.billNumber : '-',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: dto.billNumber.isEmpty ? 20 : 12,
                    color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                service,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.fullName,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.phoneNo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 130,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto.additionData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                  hasData2
                      ? Text(
                          dto.additionData2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.BLACK),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto.timeCreated.toString().isNotEmpty
                        ? DateFormat('dd-MM-yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                dto.timeCreated * 1000))
                        : '-',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    dto.timeCreated.toString().isNotEmpty
                        ? DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                dto.timeCreated * 1000))
                        : '',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

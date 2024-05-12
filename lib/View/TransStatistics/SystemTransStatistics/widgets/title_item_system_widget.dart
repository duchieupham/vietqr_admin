import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';
import '../../../../models/DTO/system_transaction_dto.dart';

class TitleItemSystemTransactionWidget extends StatelessWidget {
  final ScrollController controller;
  final SysTransExtraData extra;
  final DateTime time;

  const TitleItemSystemTransactionWidget(
      {super.key,
      required this.controller,
      required this.extra,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black
                .withOpacity(0.3), // Shadow color with some transparency
            spreadRadius: 0, // No spread radius
            blurRadius: 2, // Blur radius to create the blur effect
            offset:
                const Offset(-2, 0), // Horizontal offset for right side shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.3)),
              child: Row(
                children: [
                  _buildItemTitle('STT',
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('Thời gian',
                      height: 50,
                      width: 130,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('Tổng GD',
                      height: 50,
                      width: 80,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('Tổng tiền (VND)',
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đến',
                      height: 50,
                      width: 80,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đến (VND)',
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đi',
                      height: 50,
                      width: 80,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đi (VND)',
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đối soát',
                      height: 50,
                      width: 80,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                  _buildItemTitle('GD đối soát (VND)',
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Container(
              color: AppColor.TRANSPARENT,
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
                    child: const SelectionArea(
                      child: Text(
                        '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: AppColor.BLACK),
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
                    width: 130,
                    child: SelectionArea(
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(time),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: AppColor.BLACK),
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
                    width: 80,
                    child: SelectionArea(
                      child: Text(
                        extra.totalCount.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                        StringUtils.formatNumberWithOutVND(
                            extra.totalTrans.toString()),
                        // '500,000,000',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                    width: 80,
                    child: SelectionArea(
                      child: Text(
                        extra!.creCountTotal.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                        StringUtils.formatNumberWithOutVND(
                            extra!.creditTotal.toString()),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                    width: 80,
                    child: SelectionArea(
                      child: Text(
                        extra!.deCountTotal.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                        StringUtils.formatNumberWithOutVND(
                            extra!.debitTotal.toString()),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                    width: 80,
                    child: SelectionArea(
                      child: Text(
                        extra!.recCountTotal.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
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
                        StringUtils.formatNumberWithOutVND(
                            extra!.recTotal.toString()),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.BLACK),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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

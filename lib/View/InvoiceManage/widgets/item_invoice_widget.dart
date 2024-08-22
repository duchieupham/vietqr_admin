import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';

class ItemInvoiceWidget extends StatelessWidget {
  final int index;
  final InvoiceItem dto;
  const ItemInvoiceWidget({super.key, required this.index, required this.dto});

  @override
  Widget build(BuildContext context) {
    String formattedDateTimePaid = dto.timePaid.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timePaid * 1000))
        : '-';
    String formattedDateTimeCreated = dto.timeCreated.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timeCreated * 1000))
        : '-';
    return Container(
      // color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 40,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 200,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(dto.fullName).then(
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
                  dto.fullName.isNotEmpty ? dto.fullName : '-',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                )),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(dto.phoneNo).then(
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
                  dto.phoneNo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                )),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(dto.billNumber).then(
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
                  dto.billNumber,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                )),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerRight,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    StringUtils.formatNumberWithOutVND(dto.amount.toString()),
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
                  StringUtils.formatNumberWithOutVND(dto.amount.toString()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: dto.status == 1
                          ? AppColor.GREEN
                          : AppColor.ORANGE_DARK),
                )),
            // child: Text(
            //   StringUtils.formatNumberWithOutVND(dto.amount.toString()),
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.bold,
            //       color: dto.status == 1
            //           ? AppColor.GREEN
            //           : AppColor.ORANGE_DARK),
            // ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment:
                dto.vso.isNotEmpty ? Alignment.centerLeft : Alignment.center,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 120,
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                )),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerRight,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 120,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                    dto.timePaid.toString() != '0'
                        ? formattedDateTimePaid
                        : '-',
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
                  dto.timePaid.toString() != '0' ? formattedDateTimePaid : '-',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                )),
            // child: Text(
            //   dto.timePaid.toString() != '0' ? formattedDateTimePaid : '-',
            //   textAlign: TextAlign.right,
            //   style: const TextStyle(fontSize: 12),
            // ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: dto.midName.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
              onPressed: () async {
                await FlutterClipboard.copy(
                  dto.midName.isNotEmpty ? dto.midName : '-',
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
                dto.midName.isNotEmpty ? dto.midName : '-',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
            // child: Text(
            //   dto.midName.isNotEmpty ? dto.midName : '-',
            //   textAlign: TextAlign.left,
            //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            // ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 250,
            child: TextButton(
              onPressed: () async {
                await FlutterClipboard.copy(dto.invoiceName).then(
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
                dto.invoiceName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
            // child: Text(
            //   dto.invoiceName,
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            //   textAlign: TextAlign.left,
            //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            // ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: () async {
                  await FlutterClipboard.copy(
                          '${dto.bankAccount} - ${dto.bankShortName}')
                      .then(
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
                  '${dto.bankAccount}\n${dto.bankShortName}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                )),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 150,
            child: TextButton(
              onPressed: () async {
                await FlutterClipboard.copy(
                  dto.email.isNotEmpty ? dto.email : '-',
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
                dto.email.isNotEmpty ? dto.email : '-',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
            // child: Text(
            //   dto.email.isNotEmpty ? dto.email : '-',
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            // ),
          ),
          Container(
            // padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerRight,
            // decoration: const BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(color: AppColor.GREY_BUTTON),
            //         right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 40,
            width: 130,
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
                dto.timeCreated.toString() != '0'
                    ? formattedDateTimeCreated
                    : '-',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
            // child: Text(
            //   dto.timeCreated.toString() != '0'
            //       ? formattedDateTimeCreated
            //       : '-',
            //   textAlign: TextAlign.end,
            //   style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            // ),
          ),
        ],
      ),
    );
  }
}

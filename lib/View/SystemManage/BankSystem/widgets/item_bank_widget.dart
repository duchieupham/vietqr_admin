import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/commons/constants/utils/share_utils.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';

class ItemBankWidget extends StatelessWidget {
  final int index;
  final BankSystemItem dto;
  final Color colorText;
  const ItemBankWidget(
      {super.key,
      required this.index,
      required this.dto,
      required this.colorText});

  @override
  Widget build(BuildContext context) {
    String formattedDateTimeRegister = dto.validFeeTo.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.validFeeTo * 1000))
        : '-';
    String formattedDateTimeStared = dto.validFrom.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.validFeeTo * 1000))
        : '-';
    return Container(
      // color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //STT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            height: 40,
            width: 50,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),

          //Số tk
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.bankAccount.isNotEmpty
                    ? '${dto.bankShortName} - ${dto.bankAccount}'
                    : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.bankAccount.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 150,
              child: Text(
                // dto.getTimeRegister.toString() != '0'
                //     ? formattedDateTimeRegister
                //     : '-',
                dto.bankAccount.isNotEmpty
                    ? '${dto.bankShortName} - ${dto.bankAccount}'
                    : '-',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //Chủ tk
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.bankAccountName.isNotEmpty ? dto.bankAccountName : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.bankAccountName.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 150,
              child: Text(
                dto.bankAccountName.isNotEmpty ? dto.bankAccountName : '-',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //Ngày kích hoạt
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.validFrom.toString() != '0' ? formattedDateTimeStared : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment:
                  dto.validFrom != 0 ? Alignment.centerRight : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.validFrom.toString() != '0' ? formattedDateTimeStared : '-',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //Ngày hết hạn
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.validFeeTo.toString() != '0'
                    ? formattedDateTimeRegister
                    : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.validFeeTo != 0
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.validFeeTo.toString() != '0'
                    ? formattedDateTimeRegister
                    : '-',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //Luồng
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.mmsActive ? 'TF' : 'MF',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              height: 40,
              width: 100,
              child: Text(
                dto.mmsActive ? 'TF' : 'MF',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //CCCD/CMND
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.nationalId.isNotEmpty ? dto.nationalId : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.nationalId.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.nationalId.isNotEmpty ? dto.nationalId : '-',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //SĐT xác thực
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.phoneAuthenticated.isNotEmpty
                    ? dto.phoneAuthenticated
                    : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.phoneAuthenticated.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.phoneAuthenticated.isNotEmpty
                    ? dto.phoneAuthenticated
                    : '-',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //vso
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.vso.isNotEmpty ? dto.vso : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment:
                  dto.vso.isNotEmpty ? Alignment.centerRight : Alignment.center,
              height: 40,
              width: 100,
              child: Text(
                dto.vso.isNotEmpty ? dto.vso : '-',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //TK VietQR
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.phoneNo.isNotEmpty ? dto.phoneNo : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.phoneNo.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.phoneNo.isNotEmpty ? dto.phoneNo : '-',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),

          //Email
          InkWell(
            onTap: () async {
              await FlutterClipboard.copy(
                dto.email.isNotEmpty ? dto.email : '-',
              ).then(
                (value) => Fluttertoast.showToast(
                  msg: 'Đã sao chép',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Colors.black,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.email.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 200,
              child: Text(
                dto.email.isNotEmpty ? dto.email : '-',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

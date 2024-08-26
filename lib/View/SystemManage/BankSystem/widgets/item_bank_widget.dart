import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/models/DTO/bank_system_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';

class ItemBankWidget extends StatelessWidget {
  final int index;
  final BankSystemItem dto;
  const ItemBankWidget({super.key, required this.index, required this.dto});

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
      child: SelectionArea(
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
            Container(
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
                dto.bankAccount.isNotEmpty ? dto.bankAccount : '-',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),

            //Chủ tk
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.bankAccountName.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 150,
              child: Text(
                dto.bankAccountName.isNotEmpty ? dto.bankAccountName : '-',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //Ngân hàng
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.bankShortName.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.bankShortName.isNotEmpty ? dto.bankShortName : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //SĐT xác thực
            Container(
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
                style: const TextStyle(fontSize: 12),
              ),
            ),

            //Ngày kích hoạt
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment:
                  dto.validFrom != 0 ? Alignment.centerRight : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.validFrom.toString() != '0'
                    ? formattedDateTimeStared
                    : '-',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //Ngày hết hạn
            Container(
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
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //Luồng
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              height: 40,
              width: 100,
              child: Text(
                dto.mmsActive ? 'TF' : 'MF',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //CCCD/CMND
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.nationalId.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.nationalId.isNotEmpty ? dto.nationalId : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //vso
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment:
                  dto.vso.isNotEmpty ? Alignment.centerRight : Alignment.center,
              height: 40,
              width: 100,
              child: Text(
                dto.vso.isNotEmpty ? dto.vso : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //TK VietQR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.phoneNo.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 120,
              child: Text(
                dto.phoneNo.isNotEmpty ? dto.phoneNo : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),

            //Email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: dto.email.isNotEmpty
                  ? Alignment.centerRight
                  : Alignment.center,
              height: 40,
              width: 200,
              child: Text(
                dto.email.isNotEmpty ? dto.email : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

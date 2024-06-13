import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/constants/utils/string_utils.dart';

class ItemUserWidget extends StatelessWidget {
  final int index;
  final UserSystemDTO dto;
  const ItemUserWidget({super.key, required this.index, required this.dto});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: SelectionArea(
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
              child: Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
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
              child: Text(
                dto.phoneNo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              width: 180,
              child: Text(
                dto.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              child: Text(
                dto.email,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
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
              child: Text(
                '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              child: Text(
                '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              child: Text(
                '-',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              width: 100,
              child: Text(
                dto.gender == 1 ? 'Nữ' : "Nam",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              child: Text(
                '0',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              width: 100,
              child: Text(
                '110',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
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
              child: Text(
                dto.address,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

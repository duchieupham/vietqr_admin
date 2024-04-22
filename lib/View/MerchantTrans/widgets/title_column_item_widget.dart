import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../models/DTO/merchant_dto.dart';

class TitleColumnItemWidget extends StatelessWidget {
  final int index;
  final MerchantData dto;
  const TitleColumnItemWidget({
    super.key,
    required this.index,
    required this.dto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 130,
          child: SelectionArea(
            child: Text(
              dto.vso!.isNotEmpty ? dto.vso! : '-',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: dto.vso!.isEmpty ? 20 : 12),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 150,
          child: SelectionArea(
            child: Text(
              dto.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            ),
          ),
        ),
      ],
    );
  }
}

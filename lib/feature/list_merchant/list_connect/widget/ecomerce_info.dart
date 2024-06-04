import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/connect_info_provider.dart';

import '../../../../models/DTO/ecomerce_dto.dart';

class EcomerceInfo extends StatelessWidget {
  final EcomerceDTO dto;
  const EcomerceInfo({super.key, required this.dto});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectInfoProvider>(
        create: (context) => ConnectInfoProvider(),
        child: SelectionArea(
          child: Builder(builder: (context) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTemplateInfo('URL', dto.url),
                _buildTemplateInfo('Số điện thoại', dto.phoneNo),
                _buildTemplateInfo('Email', dto.email),
                _buildTemplateInfo('Họ tên', dto.getFullName()),
              ],
            );
          }),
        ));
  }

  Widget _buildTemplateInfo(String title, String value) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.BANK_CARD_COLOR_3.withOpacity(0.15)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
              flex: 4,
              child: Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}

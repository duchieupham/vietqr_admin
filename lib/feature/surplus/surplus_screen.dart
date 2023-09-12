import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/models/balance_dto.dart';

class SurplusScreen extends StatefulWidget {
  const SurplusScreen({super.key});

  @override
  State<SurplusScreen> createState() => _SurplusScreenState();
}

class _SurplusScreenState extends State<SurplusScreen> {
  BalanceDTO dto = BalanceDTO();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() async {
    dto = await getBalance();
    setState(() {});
  }

  Future<BalanceDTO> getBalance() async {
    BalanceDTO result = BalanceDTO();

    try {
      String url = 'https://api.vietqr.org/vqr/api/epay/query-balance';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BalanceDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Số dư khả dụng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Text(
          StringUtils.formatNumber(dto.availableBalance),
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColor.BLUE_TEXT),
        ),
        const SizedBox(height: 60),
        ...[
          _buildTemplateInfo(
              'Cash Balance', StringUtils.formatNumber(dto.cashBalance)),
          _buildTemplateInfo(
              'Bonus Balance', StringUtils.formatNumber(dto.bonusBalance)),
          _buildTemplateInfo(
              'Holding Balance', StringUtils.formatNumber(dto.holdingBalance)),
          _buildTemplateInfo('Available Balance',
              StringUtils.formatNumber(dto.availableBalance)),
        ]
      ],
    );
  }

  Widget _buildTemplateInfo(String title, String value) {
    return Container(
      height: 48,
      width: 500,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.BANK_CARD_COLOR_3.withOpacity(0.15)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
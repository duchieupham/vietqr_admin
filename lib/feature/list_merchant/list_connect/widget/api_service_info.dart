import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/connect_info_provider.dart';

import '../../../../models/DTO/api_service_dto.dart';

class ApiServiceInfo extends StatelessWidget {
  final ApiServiceDTO dto;
  const ApiServiceInfo({Key? key, required this.dto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectInfoProvider>(
        create: (context) => ConnectInfoProvider(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildTemplateInfo('Merchant', dto.merchant),
            _buildTemplateInfo('Nền tảng', dto.platform),
            _buildTemplateInfo(
                'Trạng thái', dto.active == 0 ? 'Không hoạt động' : 'Hoạt động',
                colorValue:
                    dto.active == 0 ? AppColor.BLACK : AppColor.BLUE_TEXT),
            _buildTemplateInfo('URL', dto.url),
            _buildTemplateInfo('IP', dto.ip),
            _buildTemplateInfo('Port', dto.port),
            _buildTemplateInfo('Suffix URL', dto.suffix),
            _buildTemplateInfo('Username', dto.customerUsername),
            Consumer<ConnectInfoProvider>(builder: (context, provider, child) {
              return _buildTemplateInfoPass(
                  'Password', dto.customerPassword, provider.showPassUser,
                  onShow: () {
                provider.updateShowPassUser(!provider.showPassUser);
              });
            }),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Thông tin kết nối của hệ thống',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildTemplateInfo('Username', dto.systemUsername),
            Consumer<ConnectInfoProvider>(builder: (context, provider, child) {
              return _buildTemplateInfoPass(
                  'Password', dto.systemPassword, provider.showPassSystem,
                  onShow: () {
                provider.updateShowPassSystem(!provider.showPassSystem);
              });
            }),
          ],
        ));
  }

  Widget _buildTemplateInfo(String title, String value,
      {Color colorValue = AppColor.BLACK}) {
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
              child: SelectableText(
                value.isEmpty ? '-' : value,
                style: TextStyle(fontSize: 12, color: colorValue),
              )),
        ],
      ),
    );
  }

  Widget _buildTemplateInfoPass(String title, String value, bool showPass,
      {required VoidCallback onShow}) {
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
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              flex: 4,
              child: SelectableText(
                showPass ? value : '***********',
                style: const TextStyle(fontSize: 12),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: onShow,
              child: showPass
                  ? Image.asset(
                      'assets/images/ic-hide.png',
                      height: 16,
                    )
                  : Image.asset(
                      'assets/images/ic-unhide.png',
                      height: 16,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

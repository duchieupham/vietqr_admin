import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';

import '../../../commons/constants/configurations/numeral.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/constants/env/env_config.dart';
import '../../../feature/dashboard/provider/menu_provider.dart';

class EnvironmentSettingScreen extends StatefulWidget {
  const EnvironmentSettingScreen({super.key});

  @override
  State<EnvironmentSettingScreen> createState() =>
      _EnvironmentSettingScreenState();
}

class _EnvironmentSettingScreenState extends State<EnvironmentSettingScreen> {
  String? _selectedEnvironment;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cập nhật trạng thái môi trường từ provider
    final provider = Provider.of<MenuProvider>(context);
    _selectedEnvironment = provider.environment == Numeral.ENV_GO_LIVE
        ? 'golive/product'
        : 'test/develop';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerWidget(),
            const Divider(),
            _bodyWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Thay đổi môi trường hiển thị dữ liệu',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        RadioListTile<String>(
          activeColor: AppColor.BLUE_TEXT,
          title: const Text('Môi trường TEST / DEVELOP'),
          value: 'test/develop',
          groupValue: _selectedEnvironment,
          onChanged: (value) {
            setState(() {
              _selectedEnvironment = value;
            });
          },
        ),
        RadioListTile<String>(
          activeColor: AppColor.BLUE_TEXT,
          title: const Text('Môi trường GOLIVE / PRODUCT'),
          value: 'golive/product',
          groupValue: _selectedEnvironment,
          onChanged: (value) {
            setState(() {
              _selectedEnvironment = value;
            });
          },
        ),
        const SizedBox(
          height: 50,
        ),
        InkWell(
          onTap: _saveEnvironmentSettings,
          child: const MButtonWidget(
            title: 'Lưu',
            isEnable: true,
            width: 200,
            height: 40,
            // onTap: _saveEnvironmentSettings,
          ),
        ),
      ],
    );
  }

  void _saveEnvironmentSettings() {
    final provider = Provider.of<MenuProvider>(context, listen: false);

    if (_selectedEnvironment == 'golive/product') {
      EnvConfig.instance.updateEnv(EnvType.GOLIVE);
      provider.updateENV(1);
    } else if (_selectedEnvironment == 'test/develop') {
      EnvConfig.instance.updateEnv(EnvType.DEV);
      provider.updateENV(0);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cài đặt môi trường đã được lưu.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Thiết lập và cài đặt",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Cài đặt môi trường",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'ServicePack/service_pack_screen.dart';
import 'SettingEnv/environment_setting_screen.dart';

// ignore: constant_identifier_names
enum SettingEnv { FEE, ENV }

class SettingEnvScreen extends StatefulWidget {
  final SettingEnv type;
  const SettingEnvScreen({super.key, required this.type});

  @override
  State<SettingEnvScreen> createState() => _SettingEnvScreenState();
}

class _SettingEnvScreenState extends State<SettingEnvScreen> {
  SettingEnv type = SettingEnv.FEE;
  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FrameViewWidget(
        title: const SizedBox(),
        menu: MenuLeft(
          currentType: MenuType.SETTING,
          subMenuSetting: [
            ItemDropDownMenu(
              title: 'Thiết lập gói phí DV',
              isSelect: type == SettingEnv.FEE,
              onTap: () => onTapMenu(SettingEnv.FEE),
            ),
            ItemDropDownMenu(
              title: 'Cài đặt môi trường',
              isSelect: type == SettingEnv.ENV,
              onTap: () => onTapMenu(SettingEnv.ENV),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(SettingEnv value) {
    if (value == SettingEnv.FEE) {
      html.window.history.pushState(null, '/setting', '/setting-fee');
      type = value;
    } else if (value == SettingEnv.ENV) {
      html.window.history.pushState(null, '/setting', '/setting-env');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == SettingEnv.FEE) {
      return const ServicePackScreen();
    } else {
      return const EnvironmentSettingScreen();
    }
  }
}

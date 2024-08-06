import 'package:flutter/material.dart';
import 'package:vietqr_admin/View/SystemManage/BankSystem/bank_system_screen.dart';
import 'package:vietqr_admin/View/SystemManage/UserSystem/user_system_screen.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/widget/frame_view_widget.dart';
import 'package:vietqr_admin/commons/widget/item_menu_dropdown.dart';
import 'package:vietqr_admin/commons/widget/menu_left.dart';
import 'dart:html' as html;

// ignore: camel_case_types, constant_identifier_names
enum SystemManage { USER, BANK }

class SystemManageScreen extends StatefulWidget {
  final SystemManage type;

  const SystemManageScreen({super.key, required this.type});

  @override
  State<SystemManageScreen> createState() => _SystemManageScreenState();
}

class _SystemManageScreenState extends State<SystemManageScreen> {
  SystemManage type = SystemManage.USER;
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
          currentType: MenuType.SYS_MANAGE,
          subMenuSys: [
            ItemDropDownMenu(
              title: 'Quản lý người dùng',
              isSelect: type == SystemManage.USER,
              onTap: () => onTapMenu(SystemManage.USER),
            ),
            ItemDropDownMenu(
              title: 'Quản lý TK ngân hàng',
              isSelect: type == SystemManage.BANK,
              onTap: () => onTapMenu(SystemManage.BANK),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(SystemManage value) {
    if (value == SystemManage.USER) {
      html.window.history.pushState(null, '/system', '/system-user');
      type = value;
    } else if (value == SystemManage.BANK) {
      html.window.history.pushState(null, '/system', '/system-bank');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == SystemManage.USER) {
      return const UserSystemScreen();
    } else {
      return const BankSystemScreen();
    }
  }
}

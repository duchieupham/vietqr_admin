import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'SysTrans/transaction_screen.dart';
import 'UserRecharge/user_recharge_screen.dart';

// ignore: constant_identifier_names
enum Transtype { SYS_TRANS, RECHARGE_TRANS }

class TransManageScreen extends StatefulWidget {
  final Transtype type;

  const TransManageScreen({super.key, required this.type});

  @override
  State<TransManageScreen> createState() => _TransManageScreenState();
}

class _TransManageScreenState extends State<TransManageScreen> {
  Transtype type = Transtype.SYS_TRANS;
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
          currentType: MenuType.TRANS_MANAGE,
          subMenuTransManage: [
            ItemDropDownMenu(
              title: 'Giao dịch hệ thống',
              isSelect: type == Transtype.SYS_TRANS,
              onTap: () => onTapMenu(Transtype.SYS_TRANS),
            ),
            ItemDropDownMenu(
              title: 'Thu phí VietQR',
              isSelect: type == Transtype.RECHARGE_TRANS,
              onTap: () => onTapMenu(Transtype.RECHARGE_TRANS),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(Transtype value) {
    if (value == Transtype.SYS_TRANS) {
      html.window.history.pushState(null, '/trans-manage', '/sys-trans');
      type = value;
    } else if (value == Transtype.RECHARGE_TRANS) {
      html.window.history.pushState(null, '/trans-manage', '/user-recharge');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == Transtype.SYS_TRANS) {
      return const SysTransactionScreen();
    } else {
      return const UserRechargeScreen();
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:html' as html;

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'MerchantTrans/merchant_transaction_screen.dart';
import 'SystemTransStatistics/system_transaction_screen.dart';

// ignore: constant_identifier_names
enum TransStatistics { SYS_TRANS_STATISTICS, MERCHANT_TRANS_STATISTICS }

class TransStatisticsScreen extends StatefulWidget {
  final TransStatistics type;
  const TransStatisticsScreen({super.key, required this.type});

  @override
  State<TransStatisticsScreen> createState() => _TransStatisticsScreenState();
}

class _TransStatisticsScreenState extends State<TransStatisticsScreen> {
  TransStatistics type = TransStatistics.SYS_TRANS_STATISTICS;
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
          currentType: MenuType.TRANS_STATISTICS,
          subMenuTransStatistics: [
            ItemDropDownMenu(
              title: 'Thống kê GD hệ thống',
              isSelect: type == TransStatistics.SYS_TRANS_STATISTICS,
              onTap: () => onTapMenu(TransStatistics.SYS_TRANS_STATISTICS),
            ),
            ItemDropDownMenu(
              title: 'Thống kê GD đại lý',
              isSelect: type == TransStatistics.MERCHANT_TRANS_STATISTICS,
              onTap: () => onTapMenu(TransStatistics.MERCHANT_TRANS_STATISTICS),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(TransStatistics value) {
    if (value == TransStatistics.SYS_TRANS_STATISTICS) {
      html.window.history
          .pushState(null, '/trans-statistics', '/sys-trans-statistics');
      type = value;
    } else if (value == TransStatistics.MERCHANT_TRANS_STATISTICS) {
      html.window.history
          .pushState(null, '/trans-statistics', '/merchant-trans');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == TransStatistics.SYS_TRANS_STATISTICS) {
      return const SystemTransStatisticsScreen();
    } else {
      return const MerchantTransactionScreen();
    }
  }
}

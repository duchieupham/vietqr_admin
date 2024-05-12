import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:html' as html;
import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'AnnualFeeAfter/annual_fee_after_screen.dart';
import 'ServiceFee/service_fee_screen.dart';

// ignore: constant_identifier_names
enum TransFee { FEE_TRANS, ANNUAL_FEE }

class FeeManageScreen extends StatefulWidget {
  final TransFee type;

  const FeeManageScreen({super.key, required this.type});

  @override
  State<FeeManageScreen> createState() => _FeeManageScreenState();
}

class _FeeManageScreenState extends State<FeeManageScreen> {
  TransFee type = TransFee.FEE_TRANS;
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
          currentType: MenuType.TRANS_FEE,
          subMenuTransFee: [
            ItemDropDownMenu(
              title: 'Thu phí giao dịch',
              isSelect: type == TransFee.FEE_TRANS,
              onTap: () => onTapMenu(TransFee.FEE_TRANS),
            ),
            ItemDropDownMenu(
              title: 'Thu phí duy trì',
              isSelect: type == TransFee.ANNUAL_FEE,
              onTap: () => onTapMenu(TransFee.ANNUAL_FEE),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(TransFee value) {
    if (value == TransFee.FEE_TRANS) {
      html.window.history.pushState(null, '/trans-fee', '/trans-fee');
      type = value;
    } else if (value == TransFee.ANNUAL_FEE) {
      html.window.history.pushState(null, '/trans-fee', '/annual-fee');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == TransFee.FEE_TRANS) {
      return const ServiceFeeScreen();
    } else {
      return const AnnualFeeAfterScreen();
    }
  }
}

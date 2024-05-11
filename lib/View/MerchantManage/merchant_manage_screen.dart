import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../commons/constants/enum/type_menu_home.dart';
import '../../commons/widget/frame_view_widget.dart';
import '../../commons/widget/item_menu_dropdown.dart';
import '../../commons/widget/menu_left.dart';
import 'dart:html' as html;

import '../../feature/integration_connectivity/integration_connectivity_screen.dart';
import '../../feature/list_merchant/list_connect/list_connect_screen.dart';

// ignore: constant_identifier_names
enum MerchantType { MERCHANT_LIST, API_SERVICE, TEST_CALLBACK }

class MerchantManageScreen extends StatefulWidget {
  final MerchantType type;

  const MerchantManageScreen({super.key, required this.type});

  @override
  State<MerchantManageScreen> createState() => _MerchantManageScreenState();
}

class _MerchantManageScreenState extends State<MerchantManageScreen> {
  MerchantType type = MerchantType.MERCHANT_LIST;
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
          currentType: MenuType.MERCHANT_MANAGE,
          subMenuMerchantManage: [
            ItemDropDownMenu(
              title: 'Danh sách đại lý',
              isSelect: type == MerchantType.MERCHANT_LIST,
              onTap: () => onTapMenu(MerchantType.MERCHANT_LIST),
            ),
            ItemDropDownMenu(
              title: 'Kết nối API Service',
              isSelect: type == MerchantType.API_SERVICE,
              onTap: () => onTapMenu(MerchantType.API_SERVICE),
            ),
            ItemDropDownMenu(
              title: 'Test Callback',
              isSelect: type == MerchantType.TEST_CALLBACK,
              onTap: () => onTapMenu(MerchantType.TEST_CALLBACK),
            ),
          ],
        ),
        child: _buildBody());
  }

  void onTapMenu(MerchantType value) {
    if (value == MerchantType.MERCHANT_LIST) {
      html.window.history.pushState(null, '/merchant-manage', '/merchant-list');
      type = value;
    } else if (value == MerchantType.API_SERVICE) {
      html.window.history.pushState(null, '/merchant-manage', '/api-service');
      type = value;
    } else if (value == MerchantType.TEST_CALLBACK) {
      html.window.history.pushState(null, '/merchant-manage', '/test-callback');
      type = value;
    }
    setState(() {});
  }

  Widget _buildBody() {
    if (type == MerchantType.MERCHANT_LIST) {
      return const ListConnectScreen();
    } else if (type == MerchantType.API_SERVICE) {
      return const IntegrationConnectivityScreen(
        isTestCallBack: false,
      );
    } else if (type == MerchantType.TEST_CALLBACK) {
      return const IntegrationConnectivityScreen(
        isTestCallBack: true,
      );
    }
    return const SizedBox();
  }
}

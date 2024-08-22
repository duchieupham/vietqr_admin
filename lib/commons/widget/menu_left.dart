import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import 'item_menu_home.dart';

class MenuLeft extends StatelessWidget {
  final MenuType currentType;
  final List<Widget> subMenuVas;
  final List<Widget> subMenuMerchantManage;
  final List<Widget> subMenuTransManage;
  final List<Widget> subMenuTransStatistics;
  final List<Widget> subMenuTransFee;
  final List<Widget> subMenuInvoice;
  final List<Widget> subMenuQrBox;
  final List<Widget> subMenuSys;

  final List<Widget> subMenuSetting;

  const MenuLeft({
    super.key,
    required this.currentType,
    this.subMenuVas = const [],
    this.subMenuMerchantManage = const [],
    this.subMenuTransManage = const [],
    this.subMenuTransStatistics = const [],
    this.subMenuTransFee = const [],
    this.subMenuInvoice = const [],
    this.subMenuQrBox = const [],
    this.subMenuSetting = const [],
    this.subMenuSys = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColor.BLUE_BGR,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 40),
        Expanded(
          child: _buildListItem(context),
        )
      ]),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenuHome(
                title: 'Dịch vụ GTGT',
                enableDropDownList: true,
                listItemDrop: subMenuVas,
                isSelect: currentType == MenuType.VAS,
                bold: true,
                onTap: () {
                  context.go('/vnpt-epay');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý hệ thống',
                enableDropDownList: true,
                listItemDrop: subMenuSys,
                isSelect: currentType == MenuType.SYS_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/system-user');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý đại lý',
                enableDropDownList: true,
                listItemDrop: subMenuMerchantManage,
                isSelect: currentType == MenuType.MERCHANT_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/merchant-list');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý giao dịch',
                enableDropDownList: true,
                listItemDrop: subMenuTransManage,
                isSelect: currentType == MenuType.TRANS_MANAGE,
                bold: true,
                onTap: () {
                  context.go('/sys-trans');
                },
              ),
              ItemMenuHome(
                title: 'Thống kê giao dịch',
                enableDropDownList: true,
                listItemDrop: subMenuTransStatistics,
                isSelect: currentType == MenuType.TRANS_STATISTICS,
                bold: true,
                onTap: () {
                  context.go('/sys-trans-statistics');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý thu phí',
                enableDropDownList: true,
                listItemDrop: subMenuTransFee,
                isSelect: currentType == MenuType.TRANS_FEE,
                bold: true,
                onTap: () {
                  context.go('/trans-fee');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý hóa đơn',
                enableDropDownList: true,
                listItemDrop: subMenuInvoice,
                isSelect: currentType == MenuType.INVOICE,
                bold: true,
                onTap: () {
                  context.go('/invoice-list');
                },
              ),
              ItemMenuHome(
                title: 'Quản lý QR Box',
                enableDropDownList: true,
                listItemDrop: subMenuQrBox,
                isSelect: currentType == MenuType.QR_BOX,
                bold: true,
                onTap: () {
                  context.go('/qr-box');
                },
              ),
              ItemMenuHome(
                title: 'Thiết lập và cài đặt',
                enableDropDownList: true,
                listItemDrop: subMenuSetting,
                isSelect: currentType == MenuType.SETTING,
                bold: true,
                onTap: () {
                  context.go('/setting-fee');
                },
              ),
            ],
          ),
        ),
        ItemMenuHome(
          title: 'Đăng xuất',
          isLogout: true,
          // isSelect: currentType == MenuType.LOG_OUT,
          bold: true,
          onTap: () {
            UserInformationHelper.instance.setAdminId('');
            context.go('/login');
          },
        ),
      ],
    );
  }
}

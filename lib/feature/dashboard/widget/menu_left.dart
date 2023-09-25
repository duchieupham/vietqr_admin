import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuLeft extends StatelessWidget {
  const MenuLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 15)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Menu',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Consumer<MenuProvider>(
          builder: (context, provider, child) {
            return Expanded(
              child: _buildListItem(
                provider,
                () {
                  provider.updateShowMenuLink(false);
                  provider.selectSubMenu(SubMenuType.OTHER);
                },
                (type) {
                  provider.updateShowMenuLink(true);
                  provider.selectMenu(type);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListItem(
      MenuProvider provider, Function closeMenuLink, Function(MenuType) onTab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ItemMenu(
                title: 'Người dùng',
                isSelect: provider.menuHomeType == MenuType.USER,
                onTap: () {
                  onTab(MenuType.USER);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Tài khoản ngân hàng',
                isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
                onTap: () {
                  onTab(MenuType.ACCOUNT_BANK);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Merchant',
                isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
                onTap: () {
                  onTab(MenuType.SERVICE_CONNECT);
                },
              ),
              ItemMenu(
                title: 'Thông báo đẩy',
                isSelect: provider.menuHomeType == MenuType.PUSH_NOTIFICATION,
                onTap: () {
                  onTab(MenuType.PUSH_NOTIFICATION);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Bài Post',
                isSelect: provider.menuHomeType == MenuType.POST,
                onTap: () {
                  onTab(MenuType.POST);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Giao dịch',
                isSelect: provider.menuHomeType == MenuType.TRANSACTION,
                onTap: () {
                  onTab(MenuType.TRANSACTION);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Gói dịch vụ',
                isSelect: provider.menuHomeType == MenuType.SERVICE_PACK,
                onTap: () {
                  onTab(MenuType.SERVICE_PACK);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'Log',
                isSelect: provider.menuHomeType == MenuType.LOG,
                onTap: () {
                  onTab(MenuType.LOG);
                  closeMenuLink();
                },
              ),
              ItemMenu(
                title: 'VNPT Epay',
                isSelect: provider.menuHomeType == MenuType.VNPT_EPAY,
                onTap: () {
                  onTab(MenuType.VNPT_EPAY);
                },
              ),
            ],
          ),
        ),
        ItemMenu(
          title: 'Đăng xuất',
          isLogout: true,
          isSelect: provider.menuHomeType == MenuType.LOGOUT,
          onTap: () {
            onTab(MenuType.LOGOUT);
          },
        ),
      ],
    );
  }
}

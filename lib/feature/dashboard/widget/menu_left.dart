import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuLeft extends StatelessWidget {
  final Function(MenuType) onTab;
  final MenuProvider menuProvider;
  const MenuLeft({super.key, required this.onTab, required this.menuProvider});

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
        Expanded(
            child: _buildListItem(menuProvider, () {
          menuProvider.updateShowMenuLink(false);
          menuProvider.selectSubMenu(SubMenuType.OTHER);
        }))
      ],
    );
  }

  Widget _buildListItem(MenuProvider provider, Function closeMenuLink) {
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
                provider.selectMenu(MenuType.USER);
                closeMenuLink();
              },
            ),
            ItemMenu(
              title: 'Tài khoản ngân hàng',
              isSelect: provider.menuHomeType == MenuType.ACCOUNT_BANK,
              onTap: () {
                onTab(MenuType.ACCOUNT_BANK);
                provider.selectMenu(MenuType.ACCOUNT_BANK);
                closeMenuLink();
              },
            ),
            ItemMenu(
              title: 'Dịch vụ kết nối',
              isSelect: provider.menuHomeType == MenuType.SERVICE_CONNECT,
              onTap: () {
                onTab(MenuType.SERVICE_CONNECT);
                provider.selectMenu(MenuType.SERVICE_CONNECT);
              },
            ),
            ItemMenu(
              title: 'Thông báo đẩy',
              isSelect: provider.menuHomeType == MenuType.PUSH_NOTIFICATION,
              onTap: () {
                closeMenuLink();
                provider.selectMenu(MenuType.PUSH_NOTIFICATION);
              },
            ),
            ItemMenu(
              title: 'Bài Post',
              isSelect: provider.menuHomeType == MenuType.POST,
              onTap: () {
                closeMenuLink();
                provider.selectMenu(MenuType.POST);
              },
            ),
          ],
        )),
        ItemMenu(
          title: 'Đăng xuất',
          isLogout: true,
          isSelect: provider.menuHomeType == MenuType.LOGOUT,
          onTap: () {
            onTab(MenuType.LOGOUT);
            provider.selectMenu(MenuType.LOGOUT);
          },
        ),
      ],
    );
  }
}

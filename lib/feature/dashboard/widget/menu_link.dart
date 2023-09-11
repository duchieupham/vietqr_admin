import 'package:flutter/material.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuLink extends StatelessWidget {
  final Function(SubMenuType) onTab;
  final MenuProvider menuProvider;

  const MenuLink({super.key, required this.onTab, required this.menuProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Dịch vụ kết nối API',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(
          child: _buildListItem(
            menuProvider,
            () {
              menuProvider.updateShowMenuLink(false);
            },
          ),
        )
      ],
    );
  }

  Widget _buildListItem(MenuProvider provider, Function closeMenuLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemMenu(
          title: 'Danh sách kết nối',
          isSelect: provider.subMenuType == SubMenuType.LIST_CONNECT,
          onTap: () {
            onTab(SubMenuType.LIST_CONNECT);
            provider.selectSubMenu(SubMenuType.LIST_CONNECT);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Kết nối mới',
          isSelect: provider.subMenuType == SubMenuType.NEW_CONNECT,
          onTap: () {
            onTab(SubMenuType.NEW_CONNECT);
            provider.selectSubMenu(SubMenuType.NEW_CONNECT);
            closeMenuLink();
          },
        ),
        ItemMenu(
          title: 'Chạy callback',
          isSelect: provider.subMenuType == SubMenuType.RUN_CALLBACK,
          onTap: () {
            onTab(SubMenuType.RUN_CALLBACK);
            provider.selectSubMenu(SubMenuType.RUN_CALLBACK);
            closeMenuLink();
          },
        ),
      ],
    );
  }
}

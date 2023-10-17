import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';

import '../provider/menu_provider.dart';
import 'item_menu_home.dart';

class MenuConfig extends StatelessWidget {
  const MenuConfig({super.key});

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
            'Cấu hình',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(child: _buildListItem())
      ],
    );
  }

  Widget _buildListItem() {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemMenu(
              title: 'Lark Webhook',
              isSelect:
                  provider.initPage == SubMenuType.LARK_WEB_HOOK.pageNumber,
              onTap: () {
                provider.selectSubMenu(SubMenuType.LARK_WEB_HOOK);
                // provider.updateShowMenuLink(false);
              },
            ),
          ],
        );
      },
    );
  }
}

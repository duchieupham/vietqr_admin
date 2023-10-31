import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';

import 'lark_web_hook/lark_web_hook/lark_web_hook_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const LarkHook(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WHITE,
      body: Column(
        children: [
          Consumer<MenuProvider>(builder: (context, provider, child) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.2),
              ),
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  const Text(
                    'Cấu hình',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItemMenuTop(
                          title: 'Lark Webhook',
                          isSelect: provider.initPage ==
                              SubMenuType.LARK_WEB_HOOK.pageNumber,
                          onTap: () {
                            provider.selectSubMenu(SubMenuType.LARK_WEB_HOOK);
                            // provider.updateShowMenuLink(false);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: Consumer<MenuProvider>(
              builder: (context, provider, child) {
                return pages[provider.initPage];
              },
            ),
          ),
        ],
      ),
    );
  }
}

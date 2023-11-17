import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';

import 'list_connect/list_connect_screen.dart';
import 'new_connect/new_connect_screen.dart';
import 'run_callback/run_callback_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const ListConnectScreen(),
      const NewConnectScreen(),
      const RunCallBackScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  'Đại lý',
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
                        title: 'Danh sách Đại lý',
                        isSelect: provider.initPage ==
                            SubMenuType.LIST_CONNECT.pageNumber,
                        onTap: () {
                          provider.selectSubMenu(SubMenuType.LIST_CONNECT);
                          // provider.updateShowMenuLink(false);
                        },
                      ),
                      ItemMenuTop(
                        title: 'Kết nối mới',
                        isSelect: provider.initPage ==
                            SubMenuType.NEW_CONNECT.pageNumber,
                        onTap: () {
                          provider.selectSubMenu(SubMenuType.NEW_CONNECT);
                          // provider.updateShowMenuLink(false);
                        },
                      ),
                      ItemMenuTop(
                        title: 'Chạy callback',
                        isSelect: provider.initPage ==
                            SubMenuType.RUN_CALLBACK.pageNumber,
                        onTap: () {
                          provider.selectSubMenu(SubMenuType.RUN_CALLBACK);
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/integration_connectivity/provider/menu_top_provider.dart';

import 'new_connect/new_connect_screen.dart';
import 'run_callback/run_callback_screen.dart';

class IntegrationConnectivityScreen extends StatefulWidget {
  final bool isTestCallBack;
  const IntegrationConnectivityScreen(
      {super.key, required this.isTestCallBack});

  @override
  State<IntegrationConnectivityScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<IntegrationConnectivityScreen> {
  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    pages = [
      const NewConnectScreen(),
      const RunCallBackScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuConnectivityProvider>(
      create: (context) => MenuConnectivityProvider(),
      child: Container(
        color: AppColor.WHITE,
        child: Column(
          children: [
            Consumer<MenuConnectivityProvider>(
                builder: (context, provider, child) {
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
                      'Tích hợp và kết nối',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isTestCallBack == false
                              ? ItemMenuTop(
                                  title: 'Kết nối mới',
                                  isSelect: provider.initPage ==
                                      SubMenuType.NEW_CONNECT.pageNumber,
                                  onTap: () {
                                    // provider.changeSubPage(SubMenuType.NEW_CONNECT);
                                    // provider.updateShowMenuLink(false);
                                  },
                                )
                              : ItemMenuTop(
                                  title: 'Chạy callback',
                                  isSelect: provider.initPage ==
                                      SubMenuType.RUN_CALLBACK.pageNumber,
                                  onTap: () {
                                    // provider.changeSubPage(SubMenuType.RUN_CALLBACK);
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
              child: Consumer<MenuConnectivityProvider>(
                builder: (context, provider, child) {
                  return pages[widget.isTestCallBack == false ? 0 : 1];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

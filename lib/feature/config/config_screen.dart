import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

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
          Consumer<MenuProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: pages[provider.initPage],
              );
            },
          ),
        ],
      ),
    );
  }
}

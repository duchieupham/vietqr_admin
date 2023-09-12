import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/env/env_config.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

import 'list_connect/list_connect_screen.dart';
import 'new_connect/new_connect_screen.dart';
import 'provider/service_provider.dart';
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
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ChangeNotifierProvider(
          create: (context) => ServiceProvider(),
          child: Consumer<ServiceProvider>(
            builder: (context, provider, child) {
              return Container(
                color: AppColor.BLUE_TEXT.withOpacity(0.2),
                height: 40,
                width: width,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text('Môi trường'),
                    const SizedBox(width: 24),
                    InkWell(
                      onTap: () {
                        int intPage =
                            Provider.of<MenuProvider>(context, listen: false)
                                .initPage;
                        EnvConfig.instance.updateEnv(EnvType.DEV);
                        if (intPage == 2) {
                          eventBus.fire(GetListConnect());
                        }
                        provider.updateENV(0);
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: provider.environment == 0
                              ? AppColor.BLUE_TEXT.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Test',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.environment == 0
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        int intPage =
                            Provider.of<MenuProvider>(context, listen: false)
                                .initPage;

                        if (intPage == 4) {
                          await DialogWidget.instance.openMsgDialog(
                              title: 'Thông báo',
                              msg: 'Chức năng ko khả dụng cho môi trường Live');
                        } else {
                          EnvConfig.instance.updateEnv(EnvType.GOLIVE);
                          if (intPage == 2) {
                            eventBus.fire(GetListConnect());
                          }
                          provider.updateENV(1);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: provider.environment == 1
                              ? AppColor.BLUE_TEXT.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'GoLive',
                          style: TextStyle(
                              fontSize: 12,
                              color: provider.environment == 1
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.BLACK),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Consumer<MenuProvider>(
          builder: (context, provider, child) {
            return Expanded(
              child: pages[provider.initPage],
            );
          },
        ),
      ],
    );
  }
}

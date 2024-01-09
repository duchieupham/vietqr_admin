import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/list_merchant/active_fee/active_fee_screen.dart';
import 'package:vietqr_admin/feature/list_merchant/annual_fee/annual_fee_screen.dart';
import 'package:vietqr_admin/feature/service_pack/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/provider/menu_top_provider.dart';
import 'package:vietqr_admin/models/service_pack_dto.dart';

class ServiceFeeScreen extends StatefulWidget {
  const ServiceFeeScreen({Key? key}) : super(key: key);

  @override
  State<ServiceFeeScreen> createState() => _ServicePackScreenState();
}

class _ServicePackScreenState extends State<ServiceFeeScreen> {
  late ServicePackBloc _bloc;
  StreamSubscription? _subscription;
  List<ServicePackDTO> listServicePack = [];
  final PageController pageViewController = PageController();

  @override
  void initState() {
    _bloc = ServicePackBloc()
      ..add(const ServicePackGetListEvent(initPage: true));
    _subscription = eventBus.on<RefreshServicePackList>().listen((data) {
      _bloc.add(const ServicePackGetListEvent(initPage: true));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicePackBloc>(
        create: (context) => _bloc,
        child: Column(
          children: [
            ChangeNotifierProvider<MenuTopProvider>(
              create: (context) => MenuTopProvider(),
              child: Consumer<MenuTopProvider>(
                  builder: (context, provider, child) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ItemMenuTop(
                              title: 'Phí giao dịch',
                              isSelect: provider.page == 0,
                              onTap: () {
                                provider.changePage(0);
                                pageViewController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOutQuart,
                                );
                              },
                            ),
                            ItemMenuTop(
                              title: 'Phí thuê bao',
                              isSelect: provider.page == 1,
                              onTap: () {
                                provider.changePage(1);
                                pageViewController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOutQuart,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                );
              }),
            ),
            Expanded(
                child: PageView(
              controller: pageViewController,
              children: const [
                ActiveFeeScreen(),
                AnnualFeeScreen(),
              ],
            )),
          ],
        ));
  }
}

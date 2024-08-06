import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/constants/utils/base_api.dart';
import 'package:vietqr_admin/commons/constants/utils/log.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/integration_connectivity/provider/menu_top_provider.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';

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
  List<BankTypeDTO> listBankType = [];
  BankTypeDTO selectBank = const BankTypeDTO(
      id: '0',
      bankCode: '',
      bankName: 'Chọn ngân hàng thụ hưởng',
      bankShortName: '',
      imageId: '',
      caiValue: '',
      status: 0);
  @override
  void initState() {
    super.initState();
    getBanks();
  }

  Future<void> getBanks() async {
    try {
      String url = 'https://api.vietqr.org/vqr/api/bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          listBankType = [
            const BankTypeDTO(
                id: '0',
                bankCode: '',
                bankName: 'Chọn ngân hàng thụ hưởng',
                bankShortName: '',
                imageId: '',
                caiValue: '',
                status: 0),
            ...data
                .map<BankTypeDTO>((e) => BankTypeDTO.fromJson(e))
                .where((i) => i.bankCode == 'MB' || i.bankCode == 'BIDV')
                .toList()
          ];
        });
      }
    } catch (e) {
      LOG.error(e.toString());
    }
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
                  // return pages[widget.isTestCallBack == false ? 0 : 1];
                  if (!widget.isTestCallBack) {
                    return NewConnectScreen(
                      onSelectBank: (bank) {
                        setState(() {
                          selectBank = bank;
                        });
                      },
                      listBank: listBankType,
                      selectBank: selectBank,
                    );
                  }
                  return const RunCallBackScreen();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

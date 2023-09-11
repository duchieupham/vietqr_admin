import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/feature/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_connect/provider/add_bank_provider.dart';

class AddBankPopup extends StatelessWidget {
  final String customerSyncId;
  final String accountCustomerId;
  final InfoConnectBloc bloc;
  const AddBankPopup(
      {Key? key,
      required this.customerSyncId,
      required this.accountCustomerId,
      required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTitle(context),
          Expanded(
            child:
                Consumer<AddBankProvider>(builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        _buildDefaultBank(),
                        _buildTemplateInfo('Số tài khoản',
                            child: TextField(
                              style: const TextStyle(fontSize: 12),
                              onChanged: provider.updateBankAccount,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập STK MB Bank',
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: DefaultTheme.GREY_TEXT)),
                            )),
                        if (provider.errorAccountNumber) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Số tài khoản không đúng định dạng',
                            style: TextStyle(
                                fontSize: 12, color: DefaultTheme.RED_TEXT),
                          ),
                        ],
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTemplateInfo('Chủ tài khoản',
                            child: Text(
                              provider.userBankName,
                              style: const TextStyle(fontSize: 12),
                            )),
                        if (provider.errorAccountName) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Chủ tài khoản không hợp lệ',
                            style: TextStyle(
                                fontSize: 12, color: DefaultTheme.RED_TEXT),
                          ),
                        ]
                      ],
                    )),
                    ButtonWidget(
                      height: 40,
                      text: 'Thêm',
                      borderRadius: 5,
                      textColor: DefaultTheme.WHITE,
                      bgColor: DefaultTheme.BLUE_TEXT,
                      function: () {
                        provider.checkErrorAccountNumber();
                        if (!provider.errorAccountNumber &&
                            !provider.errorAccountNumber) {
                          Map<String, dynamic> param = {};
                          param['bankAccount'] = provider.bankAccount;
                          param['userBankName'] = provider.userBankName;
                          param['customerSyncId'] = customerSyncId;
                          param['accountCustomerId'] = accountCustomerId;
                          bloc.add(AddBankConnectEvent(param: param));
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildDefaultBank() {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: DefaultTheme.BANK_CARD_COLOR_3.withOpacity(0.15)),
      child: Row(
        children: const [
          Text(
            'Ngân hàng',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            width: 28,
          ),
          Text(
            'MB Bank(Mặc định)',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateInfo(String title, {required Widget child}) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: DefaultTheme.GREY_LIGHT)),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            width: 28,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Thêm TK ngân hàng để đồng bộ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 24,
            ))
      ],
    );
  }
}

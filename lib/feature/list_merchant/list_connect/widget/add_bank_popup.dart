import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/add_bank_provider.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/widget/dialog_select_bank_type.dart';
import 'package:vietqr_admin/models/DTO/bank_type_dto.dart';

class AddBankPopup extends StatefulWidget {
  final String customerSyncId;
  final String accountCustomerId;
  final InfoConnectBloc bloc;

  const AddBankPopup(
      {super.key,
      required this.customerSyncId,
      required this.accountCustomerId,
      required this.bloc});

  @override
  State<AddBankPopup> createState() => _AddBankPopupState();
}

class _AddBankPopupState extends State<AddBankPopup> {
  late AddBankProvider _addBankProvider;

  @override
  void initState() {
    _addBankProvider = Provider.of<AddBankProvider>(context, listen: false);
    _addBankProvider.getListBankType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextEditingController bankAccountController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTitle(context),
          Expanded(
            child:
                Consumer<AddBankProvider>(builder: (context, provider, child) {
              provider.getListBankType();
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        // _buildDefaultBank(),
                        _buildSelectBank(
                            provider, context, bankAccountController),
                        _buildTemplateInfo('Số tài khoản',
                            child: TextField(
                              style: const TextStyle(fontSize: 12),
                              controller: bankAccountController,
                              onChanged: (value) {
                                provider.onSearchChanged(value);
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập số tài khoản',
                                  hintStyle: TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT)),
                            )),
                        if (provider.errorAccountNumber) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Số tài khoản không đúng định dạng',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.RED_TEXT),
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
                                fontSize: 12, color: AppColor.RED_TEXT),
                          ),
                        ]
                      ],
                    )),
                    ButtonWidget(
                      height: 40,
                      text: 'Thêm',
                      borderRadius: 5,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () {
                        provider.checkErrorAccountNumber();
                        if (!provider.errorAccountNumber &&
                            !provider.errorAccountNumber) {
                          Map<String, dynamic> param = {};
                          param['bankAccount'] = provider.bankAccount;
                          param['userBankName'] = provider.userBankName;
                          param['customerSyncId'] = widget.customerSyncId;
                          param['accountCustomerId'] = widget.accountCustomerId;
                          param['bankCode'] = provider.selectBankType!.bankCode;
                          widget.bloc.add(AddBankConnectEvent(param: param));
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
          color: AppColor.BANK_CARD_COLOR_3.withOpacity(0.15)),
      child: const Row(
        children: [
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

  Widget _buildSelectBank(
      AddBankProvider provider, context, bankAccountController) {
    return InkWell(
      onTap: () async {
        provider.clearBankAndUserName();
        bankAccountController.clear();
        final data = await showDialog(
          context: context,
          builder: (context) {
            return DialogSelectBankType(
              list: provider.listBankTypes.isEmpty
                  ? []
                  : provider.listBankTypes
                      .where(
                        (element) => element.status == 1,
                      )
                      .toList(),
              isSearch: false,
            );
          },
        );

        if (data is BankTypeDTO) {
          provider.updateBankType(data);
        }
      },
      child: Container(
        height: 48,
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColor.GREY_LIGHT)),
        child: Row(
          children: [
            const Text(
              'Ngân hàng',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              width: 28,
            ),
            Text(
              provider.selectBankType != null
                  ? '${provider.selectBankType!.bankShortName} - ${provider.selectBankType!.bankName}'
                  : 'Chọn ngân hàng',
              style: TextStyle(
                  fontSize: 12,
                  color: provider.selectBankType != null
                      ? AppColor.BLACK
                      : AppColor.GREY_TEXT),
            ),
            const SizedBox(
              width: 10,
            ),
            const RotatedBox(
              quarterTurns: 5,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
          ],
        ),
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
          border: Border.all(color: AppColor.GREY_LIGHT)),
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

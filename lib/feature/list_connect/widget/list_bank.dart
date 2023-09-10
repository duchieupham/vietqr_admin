import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/dashboard/bank/blocs/bank_type_bloc.dart';
import 'package:vietqr_admin/feature/list_connect/provider/bank_type_provider.dart';
import 'package:vietqr_admin/feature/list_connect/widget/add_bank_popup.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';

import '../../../commons/constants/utils/image_utils.dart';

class ListBank extends StatelessWidget {
  final List<BankAccountDTO> listBank;
  final bool showButtonAddBank;
  final ApiServiceDTO apiServiceDTO;
  final String customerSyncId;
  const ListBank(
      {Key? key,
      required this.listBank,
      this.showButtonAddBank = false,
      required this.apiServiceDTO,
      required this.customerSyncId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách tài khoản đồng bộ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
          children: listBank.map((e) {
            return _buildItemBank(e);
          }).toList(),
        )),
        if (showButtonAddBank) ...[
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(
            height: 40,
            text: 'Thêm ngân hàng đồng bộ mới',
            borderRadius: 5,
            textColor: DefaultTheme.WHITE,
            bgColor: DefaultTheme.BLUE_TEXT,
            function: () {
              DialogWidget.instance.openPopupCenter(
                  child: BlocProvider<BankTypeBloc>(
                create: (BuildContext context) => BankTypeBloc(),
                child: ChangeNotifierProvider<BankTypeProvider>(
                  create: (context) => BankTypeProvider(),
                  child: AddBankPopup(
                    customerSyncId: customerSyncId,
                    accountCustomerId: apiServiceDTO.accountCustomerId,
                  ),
                ),
              ));
            },
          ),
        ]
      ],
    );
  }

  Widget _buildItemBank(BankAccountDTO dto) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: DefaultTheme.GREY_BUTTON)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: DefaultTheme.GREY_BUTTON),
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imgId))),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dto.bankCode} -  ${dto.bankAccount}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  dto.bankShortName.toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Text(
                      'Trạng thái: ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      dto.authenticated ? 'Đã liên kết' : 'Chưa liên kết',
                      style: TextStyle(
                          fontSize: 12,
                          color: dto.authenticated
                              ? DefaultTheme.BLUE_TEXT
                              : DefaultTheme.BLACK),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Text(
                      'Đồng bộ: ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Luồng ${dto.flow}',
                      style: const TextStyle(
                          fontSize: 12, color: DefaultTheme.BLUE_TEXT),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Spacer(
                      flex: 4,
                    ),
                    InkWell(
                        onTap: () {},
                        child: const Text(
                          'Chi tiết',
                          style: TextStyle(
                              color: DefaultTheme.BLUE_TEXT,
                              decoration: TextDecoration.underline,
                              fontSize: 13),
                        )),
                    const Spacer(),
                    InkWell(
                        onTap: () {},
                        child: const Text(
                          'Chuyển hướng',
                          style: TextStyle(
                              color: DefaultTheme.BLUE_TEXT,
                              decoration: TextDecoration.underline,
                              fontSize: 13),
                        )),
                    const Spacer(),
                    InkWell(
                        onTap: () {},
                        child: const Text(
                          'Xoá đông bộ',
                          style: TextStyle(
                              color: DefaultTheme.RED_TEXT,
                              decoration: TextDecoration.underline,
                              fontSize: 13),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

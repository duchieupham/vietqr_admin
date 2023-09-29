import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/provider/add_bank_provider.dart';
import 'package:vietqr_admin/feature/connect_service/list_connect/widget/add_bank_popup.dart';
import 'package:vietqr_admin/models/api_service_dto.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';

import '../events/info_connect_event.dart';

class ListBank extends StatelessWidget {
  final List<BankAccountDTO> listBank;
  final bool showButtonAddBank;
  final ApiServiceDTO apiServiceDTO;
  final String customerSyncId;
  final InfoConnectBloc bloc;
  final bool isVertical;

  const ListBank(
      {Key? key,
      required this.listBank,
      this.showButtonAddBank = false,
      required this.apiServiceDTO,
      required this.customerSyncId,
      this.isVertical = false,
      required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách tài khoản đồng bộ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        if (isVertical)
          ...listBank.map((e) {
            return _buildItemBank(e, context);
          }).toList()
        else
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: listBank.map((e) {
              return _buildItemBank(e, context);
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
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              DialogWidget.instance.openPopupCenter(
                  child: ChangeNotifierProvider<AddBankProvider>(
                create: (context) => AddBankProvider(),
                child: AddBankPopup(
                  customerSyncId: customerSyncId,
                  accountCustomerId: apiServiceDTO.accountCustomerId,
                  bloc: bloc,
                ),
              ));
            },
          ),
        ]
      ],
    );
  }

  Widget _buildItemBank(BankAccountDTO dto, BuildContext context) {
    return SelectionArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColor.GREY_TEXT.withOpacity(0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColor.GREY_BUTTON),
                  image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(dto.imgId))),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    dto.customerBankName.toUpperCase(),
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
                                ? AppColor.BLUE_TEXT
                                : AppColor.BLACK),
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
                            fontSize: 12, color: AppColor.BLUE_TEXT),
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
                                color: AppColor.BLUE_TEXT,
                                decoration: TextDecoration.underline,
                                fontSize: 13),
                          )),
                      const Spacer(),
                      InkWell(
                          onTap: () {},
                          child: const Text(
                            'Chuyển hướng',
                            style: TextStyle(
                                color: AppColor.BLUE_TEXT,
                                decoration: TextDecoration.underline,
                                fontSize: 13),
                          )),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            DialogWidget.instance.openMsgDialogQuestion(
                                title: 'Xoá đồng bộ',
                                msg: 'Bạn có chắc chắn muốn xoá đồng bộ?',
                                onConfirm: () {
                                  Map<String, dynamic> param = {};
                                  param['bankId'] = dto.bankId;
                                  param['customerSyncId'] = dto.customerSyncId;
                                  bloc.add(
                                      RemoveBankConnectEvent(param: param));
                                  Navigator.pop(context);
                                });
                          },
                          child: const Text(
                            'Xoá đông bộ',
                            style: TextStyle(
                                color: AppColor.RED_TEXT,
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
      ),
    );
  }
}

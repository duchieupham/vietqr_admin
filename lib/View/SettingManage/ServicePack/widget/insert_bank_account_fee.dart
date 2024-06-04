import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/textfield_widget.dart';
import 'package:vietqr_admin/View/SettingManage/ServicePack/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/View/SettingManage/ServicePack/event/service_pack_event.dart';
import 'package:vietqr_admin/View/SettingManage/ServicePack/provider/insert_bank_account_fee_provider.dart';
import 'package:vietqr_admin/View/SettingManage/ServicePack/state/service_pack_state.dart';

import '../../../../models/DTO/merchant_fee_dto.dart';

class InsertBankAccountFeePopup extends StatefulWidget {
  final ServicePackBloc servicePackBloc;
  final String merchantName;
  final String serviceFeeId;
  const InsertBankAccountFeePopup(
      {super.key,
      required this.servicePackBloc,
      this.merchantName = '',
      required this.serviceFeeId});

  @override
  State<InsertBankAccountFeePopup> createState() =>
      _CreateServicePackPopupState();
}

class _CreateServicePackPopupState extends State<InsertBankAccountFeePopup> {
  late ServicePackBloc bloc;
  List<MerchantFee> listMerchantFee = [];
  List<MerchantFee> listMerchantValue = [];
  @override
  void initState() {
    bloc = ServicePackBloc()..add(GetListMerchantBankAccountEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicePackBloc>(
      create: (context) => bloc,
      child: ChangeNotifierProvider<InsertBankAccountFeeProvider>(
        create: (context) => InsertBankAccountFeeProvider(),
        child: BlocConsumer<ServicePackBloc, ServicePackState>(
            listener: (context, state) {
          if (state is GetListMerchantBankAccountSuccessState) {
            listMerchantFee = state.result;
            listMerchantValue = state.result;
          }
          if (state is ServicePackLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is InsertBankAccountSuccessState) {
            Navigator.pop(context);
            widget.servicePackBloc.add(const ServicePackGetListEvent());
            Navigator.pop(context);
          }
          if (state is ServicePackInsertFailsState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
                title: 'Không thể thêm',
                msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Consumer<InsertBankAccountFeeProvider>(
                builder: (context, provider, child) {
              return Column(
                children: [
                  _buildTitle(context),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor.GREY_BUTTON),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            hintText: 'Tìm kiếm bằng tên Merchant',
                            keyboardAction: TextInputAction.done,
                            disableBorder: true,
                            onChange: (Object value) {
                              setState(() {
                                if (value.toString().isNotEmpty) {
                                  listMerchantValue = listMerchantFee
                                      .where((dto) => dto.merchant
                                          .toUpperCase()
                                          .contains(
                                              value.toString().toUpperCase()))
                                      .toList();
                                } else {
                                  listMerchantValue = listMerchantFee;
                                }
                              });
                            },
                            inputType: TextInputType.text,
                            isObscureText: false,
                          ),
                        ),
                        const Icon(Icons.search)
                      ],
                    ),
                  ),
                  if (listMerchantValue.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text('Không có dữ liệu')
                        ],
                      ),
                    ),
                    const Spacer()
                  ] else ...[
                    Expanded(
                      child: ListView(
                        children: listMerchantValue.map((e) {
                          return _buildListItem(e, provider);
                        }).toList(),
                      ),
                    ),
                    ButtonWidget(
                      height: 40,
                      text: 'Hoàn tất',
                      borderRadius: 5,
                      sizeTitle: 12,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: () {
                        Map<String, dynamic> param = {};
                        if (provider.valueRadio.merchant.isNotEmpty) {
                          param['insertType'] = 0;
                          param['bankId'] = '';
                          param['customerSyncId'] =
                              provider.valueRadio.customerSyncId;
                        } else {
                          param['insertType'] = 1;
                          param['bankId'] = provider.valueSubItem.bankId;
                          param['customerSyncId'] = '';
                        }
                        param['serviceFeeId'] = widget.serviceFeeId;
                        bloc.add(InsertBankAccountFeeEvent(param: param));
                      },
                    ),
                  ]
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildListItem(
      MerchantFee dto, InsertBankAccountFeeProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.GREY_TEXT.withOpacity(0.1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const RotatedBox(
                quarterTurns: 5,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text('Merchant: ${dto.merchant}'),
              const Spacer(),
              Radio<MerchantFee>(
                  value: dto,
                  activeColor: AppColor.BLUE_TEXT,
                  groupValue: provider.valueRadio,
                  onChanged: (dto) {
                    provider.changeValueRatio(dto!);
                  })
            ],
          ),
          if (dto.bankAccounts?.isNotEmpty ?? false)
            ...dto.bankAccounts!.map((e) {
              return _buildItemBankAccount(e, provider, dto);
            })
        ],
      ),
    );
  }

  Widget _buildItemBankAccount(MerchantBankAccount dto,
      InsertBankAccountFeeProvider provider, MerchantFee merchantFee) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColor.GREY_TEXT.withOpacity(0.5)),
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imgId))),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(dto.bankAccount),
          Expanded(
            child: Text(
              dto.userBankName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          if (merchantFee.customerSyncId == provider.valueRadio.customerSyncId)
            InkWell(
              onTap: () {
                print('-dadadad');
                provider.changeValueSubItem(dto);
              },
              child: Container(
                width: 18,
                height: 18,
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.BLUE_TEXT,
                ),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.WHITE, width: 2.5),
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
              ),
            )
          else
            Radio<MerchantBankAccount>(
                value: dto,
                activeColor: AppColor.BLUE_TEXT,
                groupValue: provider.valueSubItem,
                onChanged: (dto) {
                  provider.changeValueSubItem(dto!);
                })
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Text(
          'Áp dụng gói ${widget.merchantName}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

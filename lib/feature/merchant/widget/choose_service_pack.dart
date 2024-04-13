import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/service_pack/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/feature/service_pack/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/service_pack/provider/service_pack_provider.dart';
import 'package:vietqr_admin/feature/service_pack/state/service_pack_state.dart';

import '../../../models/DTO/service_pack_dto.dart';

class ChooseServicePackPopup extends StatefulWidget {
  final String bankAccount;
  final String bankID;
  final Function onSuccess;
  const ChooseServicePackPopup(
      {Key? key,
      required this.bankAccount,
      required this.bankID,
      required this.onSuccess})
      : super(key: key);

  @override
  State<ChooseServicePackPopup> createState() => _ServicePackScreenState();
}

class _ServicePackScreenState extends State<ChooseServicePackPopup> {
  late ServicePackBloc _bloc;
  List<ServicePackDTO> listServicePack = [];
  final PageController pageViewController = PageController();

  ServicePackDTO _valueRadio = const ServicePackDTO();
  SubServicePackDTO _valueSubRadio = const SubServicePackDTO();
  @override
  void initState() {
    _bloc = ServicePackBloc()
      ..add(const ServicePackGetListEvent(initPage: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServicePackBloc>(
        create: (context) => _bloc, child: _buildListServicePack());
  }

  Widget _buildListServicePack() {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        _buildTitle(context),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ChangeNotifierProvider<ServicePackProvider>(
            create: (context) => ServicePackProvider(),
            child: Consumer<ServicePackProvider>(
                builder: (context, provider, child) {
              return BlocConsumer<ServicePackBloc, ServicePackState>(
                listener: (context, state) {
                  if (state is ServicePackLoadingState) {
                    DialogWidget.instance.openLoadingDialog();
                  }
                  if (state is ServicePackGetListSuccessState) {
                    listServicePack = state.result;
                    listServicePack.sort((a, b) {
                      return a.item!.shortName
                          .toLowerCase()
                          .compareTo(b.item!.shortName.toLowerCase());
                    });
                    if (state.initPage) {
                      provider.init(listServicePack);
                    } else {
                      provider.updateListServicePack(listServicePack);
                    }
                  }
                  if (state is ServicePackLoadingState) {
                    DialogWidget.instance.openLoadingDialog();
                  }
                  if (state is InsertBankAccountSuccessState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    widget.onSuccess();
                  }
                  if (state is ServicePackInsertFailsState) {
                    Navigator.pop(context);
                    DialogWidget.instance.openMsgDialog(
                        title: 'Không thể thêm',
                        msg: ErrorUtils.instance
                            .getErrorMessage(state.dto.message));
                  }
                },
                builder: (context, state) {
                  if (listServicePack.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('Không có dữ liệu'),
                    );
                  }
                  return SingleChildScrollView(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                  width: 1095,
                                  child: Column(
                                    children: [
                                      _buildTitleItem(),
                                      ...listServicePack.map((e) {
                                        int index = listServicePack.indexOf(e);

                                        return _buildItem(e, provider, index);
                                      }).toList(),
                                    ],
                                  ))),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: AppColor.BLUE_DARK),
                              child: _buildItemTitle('Chọn',
                                  height: 50,
                                  width: 60,
                                  alignment: Alignment.center),
                            ),
                            ...listServicePack.map((e) {
                              int index = listServicePack.indexOf(e);

                              return Column(
                                children: [
                                  Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? AppColor.GREY_BG
                                            : AppColor.WHITE,
                                        border: Border(
                                          bottom: const BorderSide(
                                              color: AppColor.GREY_BUTTON),
                                          left: BorderSide(
                                              color: AppColor.BLUE_DARK
                                                  .withOpacity(0.5)),
                                        )),
                                    height: 50,
                                    child: Radio<ServicePackDTO>(
                                        value: e,
                                        activeColor: AppColor.BLUE_TEXT,
                                        groupValue: _valueRadio,
                                        onChanged: (dto) {
                                          setState(() {
                                            _valueRadio = dto!;
                                            _valueSubRadio =
                                                const SubServicePackDTO();
                                          });
                                        }),
                                  ),
                                  if (provider.showListSubItem(e.item!))
                                    Column(
                                      children: e.subItems!.map((subItem) {
                                        int indexSub =
                                            e.subItems!.indexOf(subItem);
                                        return Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: indexSub % 2 == 0
                                                  ? AppColor.GREY_BG
                                                  : AppColor.WHITE,
                                              border: Border(
                                                bottom: const BorderSide(
                                                    color:
                                                        AppColor.GREY_BUTTON),
                                                left: BorderSide(
                                                    color: AppColor.BLUE_DARK
                                                        .withOpacity(0.5)),
                                              )),
                                          height: 50,
                                          child: Radio<SubServicePackDTO>(
                                              value: subItem,
                                              activeColor: AppColor.BLUE_TEXT,
                                              groupValue: _valueSubRadio,
                                              onChanged: (dto) {
                                                setState(() {
                                                  _valueRadio =
                                                      const ServicePackDTO();
                                                  _valueSubRadio = dto!;
                                                });
                                              }),
                                        );
                                      }).toList(),
                                    )
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      )
                    ],
                  ));
                },
              );
            }),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ButtonWidget(
          height: 40,
          width: 200,
          text: 'Áp dụng',
          borderRadius: 5,
          sizeTitle: 12,
          textColor: AppColor.WHITE,
          bgColor: ((_valueRadio.item?.id.isNotEmpty ?? false) ||
                  _valueSubRadio.id.isNotEmpty)
              ? AppColor.BLUE_TEXT
              : AppColor.GREY_BUTTON,
          function: () {
            Map<String, dynamic> param = {};
            param['insertType'] = 1;
            param['bankId'] = widget.bankID;
            param['customerSyncId'] = '';
            if (_valueRadio.item?.id.isNotEmpty ?? false) {
              param['serviceFeeId'] = _valueRadio.item?.id;
            }
            if (_valueSubRadio.id.isNotEmpty) {
              param['serviceFeeId'] = _valueSubRadio.id;
            }
            print('------------------------------$param ');
            _bloc.add(InsertBankAccountFeeEvent(param: param));
          },
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('',
              height: 50, width: 40, alignment: Alignment.center),
          _buildItemTitle('Mã gói',
              height: 50,
              width: 90,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Mô tả ngắn',
              height: 50,
              width: 140,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Phí kích hoạt',
              height: 50,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Phí thuê bao',
              height: 50,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời hạn',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Phí/GD',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Phần trăm phí/Tổng tiền',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thuế(VAT)',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Ghi nhận GD',
              height: 50,
              width: 135,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItem(
      ServicePackDTO dto, ServicePackProvider provider, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (dto.subItems?.isNotEmpty ?? false)
              InkWell(
                onTap: () {
                  provider.expandListSubItem(dto.item!);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: AppColor.GREY_TEXT.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30)),
                  child: RotatedBox(
                    quarterTurns: provider.showListSubItem(dto.item!) ? 3 : 5,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(
                width: 40,
              ),
            Expanded(
                child: _buildInfoServicePack(dto.item!, index,
                    provider: provider)),
          ],
        ),
        if (provider.showListSubItem(dto.item!))
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              children: dto.subItems!.map((e) {
                int indexSub = dto.subItems!.indexOf(e);
                return _buildInfoServicePack(e, indexSub, isSubItem: true);
              }).toList(),
            ),
          )
      ],
    );
  }

  Widget _buildInfoServicePack(SubServicePackDTO dto, int index,
      {bool isSubItem = false, ServicePackProvider? provider}) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      height: 50,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 90,
            child: SelectableText(
              dto.shortName.isNotEmpty ? dto.shortName : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 140,
            child: SelectableText(
              dto.name.isNotEmpty ? dto.name : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 120,
            child: SelectableText(
              StringUtils.formatNumber(dto.activeFee.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 120,
            child: SelectableText(
              StringUtils.formatNumber(dto.annualFee.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              dto.monthlyCycle.toString() ?? '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              StringUtils.formatNumber(dto.transFee.toString() ?? '0'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 150,
            child: SelectableText(
              '${dto.percentFee}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              '${dto.vat}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 135,
            child: SelectableText(
              dto.countingTransType == 0 ? 'Tất cả' : 'Chỉ GD có đối soát',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColor.WHITE, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 12, color: AppColor.WHITE),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Áp dụng cho TK ${widget.bankAccount}',
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';
import 'package:vietqr_admin/models/service_charge_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../provider/active_fee_provider.dart';

class ServiceFee extends StatefulWidget {
  const ServiceFee({super.key});

  @override
  State<ServiceFee> createState() => _SaleReportState();
}

class _SaleReportState extends State<ServiceFee> {
  late MerchantBloc merchantBloc;

  List<ServiceChargeDTO> listActiveFee = [];

  @override
  void initState() {
    super.initState();
    merchantBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          return BlocConsumer<MerchantBloc, MerchantState>(
              listener: (context, state) {
            if (state is MerchantLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is MerchantGetMerchantFeeSuccessfulState) {
              if (!state.isLoadingPage) {
                Navigator.pop(context);
              }

              listActiveFee = state.list;
            }
          }, builder: (context, state) {
            if (state is MerchantLoadingActiveFeeState) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              if (listActiveFee.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('Không có dữ liệu')),
                );
              } else {
                return SingleChildScrollView(
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1330,
                        child: Column(
                          children: [
                            _buildTitleItem(),
                            ...listActiveFee.map((e) {
                              int i = listActiveFee.indexOf(e);
                              return _buildItem(i, e);
                            }).toList()
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          });
        }))
      ],
    );
  }

  Widget _buildItem(int index, ServiceChargeDTO dto) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: AppColor.BLACK_LIGHT))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
            alignment: Alignment.center,
            child: Row(
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: (dto.fees?.length ?? 0) * 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: AppColor.GREY_TEXT.withOpacity(0.1)))),
                    child: SelectableText(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                _buildBoxItem(
                  TimeUtils.instance.formatMonthYear(dto.month),
                  width: 120,
                  height: (dto.fees?.length ?? 0) * 50,
                ),
                _buildBoxItem(
                  dto.merchantName,
                  width: 120,
                  height: (dto.fees?.length ?? 0) * 50,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dto.fees!.map((bankAccount) {
                    int index = dto.fees!.indexOf(bankAccount);
                    return _buildItemFee(bankAccount, true);
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            decoration:
                BoxDecoration(color: AppColor.BLUE_CARD.withOpacity(0.1)),
            child: Row(
              children: [
                const SizedBox(
                  width: 410,
                ),
                _buildBoxItem('Tổng',
                    width: 120,
                    height: 30,
                    textAlign: TextAlign.end,
                    fontWeight: FontWeight.bold),
                _buildBoxItem(
                  '${dto.totalTrans}',
                  height: 30,
                  fontWeight: FontWeight.bold,
                  width: 100,
                ),
                _buildBoxItem(
                  '${StringUtils.formatNumber(dto.totalAmount)} VND',
                  height: 30,
                  fontWeight: FontWeight.bold,
                  width: 140,
                ),
                _buildBoxItem(
                  '',
                  width: 80,
                  height: 30,
                ),
                _buildBoxItem(
                  '${StringUtils.formatNumber(dto.totalFee)} VND',
                  width: 120,
                  fontWeight: FontWeight.bold,
                  height: 30,
                ),
                _buildBoxItem(
                  '${StringUtils.formatNumber(dto.totalVatFee)} VND',
                  width: 120,
                  fontWeight: FontWeight.bold,
                  height: 30,
                ),
                _buildBoxItem(
                  '${StringUtils.formatNumber(dto.totalFeeAfterVat)} VND',
                  width: 120,
                  fontWeight: FontWeight.bold,
                  height: 30,
                ),
                _buildBoxItem(dto.status == 1 ? 'Đã TT' : 'Chưa TT',
                    width: 120,
                    height: 30,
                    fontWeight: FontWeight.bold,
                    valueColor:
                        dto.status == 1 ? AppColor.BLACK : AppColor.RED_TEXT),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemFee(BankInfo dto, bool lastItem) {
    return Row(
      children: [
        _buildBoxItem('${dto.bankShortName}\n${dto.bankAccount}',
            width: 120, notBottomBorder: lastItem, textAlign: TextAlign.start),
        _buildBoxItem(
          dto.serviceName,
          width: 120,
          notBottomBorder: lastItem,
        ),
        _buildBoxItem(dto.totalTrans.toString(),
            width: 100, notBottomBorder: lastItem),
        _buildBoxItem(
          '${StringUtils.formatNumber(dto.totalAmount)} VND',
          width: 140,
          notBottomBorder: lastItem,
        ),
        _buildBoxItem('${dto.vat}%', width: 80, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.totalFee)} VND',
            width: 120, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.vatFee)} VND',
            width: 120, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.totalFeeAfterVat)} VND',
            width: 120, notBottomBorder: lastItem),
        _buildBoxItem(dto.status == 1 ? 'Đã TT' : 'Chưa TT',
            width: 120,
            notBottomBorder: lastItem,
            valueColor: dto.status == 1 ? AppColor.BLACK : AppColor.RED_TEXT),
      ],
    );
  }

  Widget _buildBoxItem(String value,
      {double width = 100,
      bool notBottomBorder = true,
      Color? valueColor,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.center,
      double height = 50}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          border: Border(
              bottom: notBottomBorder
                  ? BorderSide.none
                  : BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)),
              right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)))),
      height: height,
      alignment: Alignment.center,
      width: width,
      child: SelectableText(
        value,
        textAlign: textAlign,
        style:
            TextStyle(fontSize: 12, color: valueColor, fontWeight: fontWeight),
      ),
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('STT', width: 50, padding: EdgeInsets.zero),
          _buildItemTitle('Thời gian',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tên đại lý',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Số tài khoản',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Gói dịch vụ',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng GD',
              width: 100, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng tiền GD',
              width: 140, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('%VAT',
              width: 80, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Phí DV',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Phí VAT',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng tiền',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Trạng thái',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return ChangeNotifierProvider<ActiveFeeProvider>(
      create: (context) => ActiveFeeProvider()..getListYear(),
      child: Consumer<ActiveFeeProvider>(builder: (context, provider, child) {
        return Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
          child: Row(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phí dịch vụ',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 114,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Năm',
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<int>(
                      value: provider.year,
                      icon: const RotatedBox(
                        quarterTurns: 5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ),
                      underline: const SizedBox.shrink(),
                      onChanged: (int? value) {
                        provider.updateYear(value ?? DateTime.now().year);
                        merchantBloc.add(GetMerchantFeeEvent(
                            customerSyncId: Session.instance.connectDTO.id,
                            year: value.toString(),
                            status: provider.status,
                            isLoadingPage: false));
                      },
                      items: provider.years
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.BLUE_TEXT),
                ),
                child: Row(
                  children: [
                    ButtonWidget(
                        text: 'Chưa thanh toán',
                        textColor: provider.status == 0
                            ? AppColor.WHITE
                            : AppColor.BLACK,
                        bgColor: provider.status == 0
                            ? AppColor.BLUE_TEXT
                            : AppColor.TRANSPARENT,
                        sizeTitle: 12,
                        borderRadius: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        function: () {
                          provider.changeStatus(0);
                          merchantBloc.add(GetMerchantFeeEvent(
                              customerSyncId: Session.instance.connectDTO.id,
                              year: provider.year.toString(),
                              status: 0,
                              isLoadingPage: false));
                        }),
                    const SizedBox(
                      width: 8,
                    ),
                    ButtonWidget(
                        text: 'Đã thanh toán',
                        textColor: provider.status == 1
                            ? AppColor.WHITE
                            : AppColor.BLACK,
                        bgColor: provider.status == 1
                            ? AppColor.BLUE_TEXT
                            : AppColor.TRANSPARENT,
                        borderRadius: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sizeTitle: 12,
                        function: () {
                          provider.changeStatus(1);
                          merchantBloc.add(GetMerchantFeeEvent(
                              customerSyncId: Session.instance.connectDTO.id,
                              year: provider.year.toString(),
                              status: 1,
                              isLoadingPage: false));
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItemTitle(
    String title, {
    TextAlign? textAlign,
    EdgeInsets? padding,
    double? width,
  }) {
    return Container(
      width: width,
      height: 50,
      padding: padding,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColor.WHITE, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 12, color: AppColor.WHITE),
      ),
    );
  }
}

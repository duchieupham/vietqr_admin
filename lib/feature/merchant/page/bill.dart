import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';

import '../../../models/DTO/service_charge_dto.dart';

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  late MerchantBloc merchantBloc;

  List<ServiceChargeDTO> listActiveFee = [];
  List<ServiceChargeDTO> listBill = [];
  int totalAmount = 0;
  int totalVat = 0;
  int totalAmountAfterVat = 0;
  @override
  void initState() {
    super.initState();
    merchantBloc = BlocProvider.of(context);
  }

  getTotalAmount(List<ServiceChargeDTO> listActiveFee) {
    totalAmount = 0;
    totalVat = 0;
    totalAmountAfterVat = 0;
    for (var element in listActiveFee) {
      totalAmount += element.totalFee;
      totalVat += element.totalVatFee;
      totalAmountAfterVat += element.totalFeeAfterVat;
    }
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
              listBill = state.list;
              listBill.removeAt(0);
              getTotalAmount(listBill);
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Phí dịch vụ tháng hiện tại',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                            width: 1240,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTitleItem(),
                                _buildItem(0, listActiveFee.first),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Hoá đơn cần thanh toán',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 1240,
                              child: Column(
                                children: [
                                  _buildTitleItem(),
                                  ...listActiveFee.map((e) {
                                    int i = listActiveFee.indexOf(e);
                                    return _buildItem(i, e);
                                  }),
                                  _buildItemTotal(totalAmount,
                                      'Tổng tiền hàng (Total amount excl. VAT):'),
                                  _buildItemTotal(
                                      totalVat, 'Tiền thuế GTGT (VAT amount):'),
                                  _buildItemTotal(totalAmountAfterVat,
                                      'Tổng tiền thanh toán (Total Amount):'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          });
        }))
      ],
    );
  }

  Widget _buildItemTotal(int value, String title) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColor.BLUE_TEXT.withOpacity(0.1),
          border: Border(
              left: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)),
              bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)),
              right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                  ),
                  const Spacer(),
                  Text(
                    '${StringUtils.formatNumber(value)} VND',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index, ServiceChargeDTO dto) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      child: Row(
        children: [
          _buildBoxItem(
            '${index + 1}',
            width: 50,
          ),
          _buildBoxItem(
            'Phần mền VietQR thông báo xử lý giao dịch tháng ${TimeUtils.instance.formatMonthYear(dto.month)}',
            width: 350,
          ),
          _buildBoxItem(
            'Tháng',
            width: 120,
          ),
          _buildBoxItem('1', width: 80, textAlign: TextAlign.center),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalFee)} VND',
              width: 140),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalFee)} VND',
              width: 140),
          _buildBoxItem('8%', width: 80),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalVatFee)} VND',
              width: 140),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalFeeAfterVat)} VND',
              width: 140),
        ],
      ),
    );
  }

  Widget _buildBoxItem(String value,
      {double width = 100,
      bool notBottomBorder = false,
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
          _buildItemTitle('STT\n(No)', width: 50, padding: EdgeInsets.zero),
          _buildItemTitle(
              'Nội dung hóa đơn thanh toán\n(Name of goods and services)',
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Đơn vị tính\n(Unit)',
              textAlign: TextAlign.center,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Số lượng\n(Quantity)',
              textAlign: TextAlign.center,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Đơn giá\n(Unit price)',
              textAlign: TextAlign.center,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Thành tiền\n(Amount)',
              textAlign: TextAlign.center,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('%VAT\n(VAT rate)',
              textAlign: TextAlign.center,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tiền thuế GTGT\n(VAT Amount)',
              textAlign: TextAlign.center,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng tiền\n(Amount after VAT)',
              textAlign: TextAlign.center,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: const Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hóa đơn',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
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

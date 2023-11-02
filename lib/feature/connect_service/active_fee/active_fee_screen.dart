import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/bloc/active_fee_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/event/active_fee_event.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/provider/active_fee_provider.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/state/active_fee_state.dart';
import 'package:vietqr_admin/feature/connect_service/active_fee/widget/active_fee_detail.dart';
import 'package:vietqr_admin/models/active_fee_dto.dart';
import 'package:vietqr_admin/models/active_fee_total_static.dart';

class ActiveFeeScreen extends StatefulWidget {
  const ActiveFeeScreen({Key? key}) : super(key: key);

  @override
  State<ActiveFeeScreen> createState() => _ActiveFeeScreenState();
}

class _ActiveFeeScreenState extends State<ActiveFeeScreen> {
  final PageController pageViewController = PageController();
  late ActiveFeeBloc _activeFeeBloc;
  StreamSubscription? _subscription;
  List<ActiveFeeDTO> listActiveFeeDTO = [];
  ActiveFeeStaticDto activeFeeStaticDto = const ActiveFeeStaticDto();
  String nowMonth = '';
  @override
  void initState() {
    nowMonth = TimeUtils.instance.getFormatMonth(DateTime.now());
    _activeFeeBloc = ActiveFeeBloc()
      ..add(ActiveFeeGetListEvent(month: nowMonth, initPage: true));
    _activeFeeBloc.add(ActiveFeeGetTotalEvent(month: nowMonth));
    _subscription = eventBus.on<RefreshListActiveFee>().listen((data) {
      _activeFeeBloc
          .add(ActiveFeeGetListEvent(month: nowMonth, initPage: true));
      _activeFeeBloc.add(ActiveFeeGetTotalEvent(month: nowMonth));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActiveFeeBloc>(
      create: (context) => _activeFeeBloc,
      child: ChangeNotifierProvider<ActiveFeeProvider>(
        create: (context) => ActiveFeeProvider(),
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: PageView(
                controller: pageViewController,
                children: [
                  _buildList(),
                  const ActiveFeeDetail(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocConsumer<ActiveFeeBloc, ActiveFeeState>(
          listener: (context, state) {
        if (state is ActiveFeeLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state is ActiveFeeGetListSuccessState) {
          if (!state.initPage) {
            Navigator.pop(context);
          } else {
            activeFeeStaticDto = state.activeFeeStaticDto;
          }
          context.read<ActiveFeeProvider>().updateListData(state.result);
          listActiveFeeDTO = state.result;
        }
      }, builder: (context, state) {
        if (state is ActiveFeeLoadingInitState) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('Đang tải...')),
          );
        } else {
          if (listActiveFeeDTO.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text('Không có dữ liệu')),
            );
          } else {
            return Consumer<ActiveFeeProvider>(
                builder: (context, provider, child) {
              return SingleChildScrollView(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: provider.valueFilterType.id == 0 ? 800 : 1350,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                provider.valueFilterType.id == 0 ? 20 : 0),
                        child: Column(
                          children: [
                            if (provider.valueFilterType.id == 0)
                              const SizedBox(
                                height: 20,
                              ),
                            if (provider.valueFilterType.id == 0) ...[
                              _buildTitleItem(),
                              ...provider.listActiveFeeDTO.map((e) {
                                int i = provider.listActiveFeeDTO.indexOf(e);
                                return _buildItem(i, e);
                              }).toList()
                            ] else ...[
                              _buildTitleItemBank(),
                              ...provider.bankAccounts.map((e) {
                                int i = provider.bankAccounts.indexOf(e);
                                return _buildItemBank(i, e);
                              }).toList()
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          }
        }
      });
    });
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('No.',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Merchant',
              height: 50, width: 150, alignment: Alignment.center),
          _buildItemTitle('Số tiền cần thu',
              height: 50, width: 160, alignment: Alignment.center),
          _buildItemTitle('Trạng thái',
              height: 50, width: 140, alignment: Alignment.center),
          Expanded(
            child: _buildItemTitle('TK kết nối',
                height: 50, alignment: Alignment.center),
          ),
          _buildItemTitle('Action',
              height: 50, width: 120, alignment: Alignment.center),
        ],
      ),
    );
  }

  Widget _buildItem(int index, ActiveFeeDTO dto) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectableText(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 150,
            child: SelectableText(
              dto.merchant,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 160,
            child: SelectableText(
              StringUtils.formatNumber(dto.totalPayment.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 140,
            child: SelectableText(
              dto.status == 1 ? 'Đã TT' : 'Chưa TT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 1 ? AppColor.BLACK : AppColor.RED_TEXT,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              height: 50,
              child: SelectableText(
                '${dto.bankAccounts?.length ?? 0}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: InkWell(
              onTap: () {},
              child: Text(
                dto.status == 0 ? 'Đã thanh toán' : 'Chi tiết',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.BLUE_TEXT,
                    decoration: TextDecoration.underline),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitleItemBank() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('No.',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Merchant',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Tài khoản',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Số tiền cần thu',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Trạng thái TT',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Gói dịch vụ',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Tổng GD',
              height: 50, width: 100, alignment: Alignment.center),
          _buildItemTitle('Tổng tiền GD',
              height: 50, width: 140, alignment: Alignment.center),
          _buildItemTitle('GD Ghi nhận',
              height: 50, width: 136, alignment: Alignment.center),
          _buildItemTitle('VAT',
              height: 50, width: 80, alignment: Alignment.center),
          _buildItemTitle('Khuyến mại',
              height: 50, width: 120, alignment: Alignment.center),
          _buildItemTitle('Action',
              height: 50, width: 120, alignment: Alignment.center),
        ],
      ),
    );
  }

  Widget _buildItemBank(int index, ActiveFeeBankDTO dto) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 50,
            child: SelectableText(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectableText(
              dto.merchant,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            height: 50,
            width: 120,
            child: SelectableText(
              dto.bankAccount,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (dto.fees?.isNotEmpty ?? false)
            Column(
              children: dto.fees!.map((e) {
                return _buildItemFee(e);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildItemFee(FeeDTO dto) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(color: AppColor.GREY_BUTTON),
            right: BorderSide(color: AppColor.GREY_BUTTON),
            left: BorderSide(color: AppColor.GREY_BUTTON),
          )),
          height: 50,
          width: 120,
          child: SelectableText(
            StringUtils.formatNumber(dto.totalPayment.toString()),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 120,
          child: SelectableText(
            dto.status == 1 ? 'Đã TT' : 'Chưa TT',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: dto.status == 1 ? AppColor.BLACK : AppColor.RED_TEXT),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 120,
          child: SelectableText(
            dto.shortName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 100,
          child: SelectableText(
            dto.totalTrans.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 140,
          child: SelectableText(
            StringUtils.formatNumber(dto.totalAmount.toString()),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: dto.countingTransType == 1
                    ? AppColor.GREEN
                    : AppColor.BLACK),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 139,
          child: SelectableText(
            dto.countingTransType == 0 ? 'Tất cả' : 'Chỉ GD có đối soát',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: dto.countingTransType == 1
                    ? AppColor.GREEN
                    : AppColor.BLACK),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 80,
          child: SelectableText(
            '${dto.vat}%',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 120,
          child: SelectableText(
            StringUtils.formatNumber(dto.discountAmount.toString()),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColor.GREY_BUTTON),
                  right: BorderSide(color: AppColor.GREY_BUTTON))),
          height: 50,
          width: 120,
          child: InkWell(
            child: Text(
              dto.status == 1 ? '' : 'Đã thanh toán',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.BLUE_TEXT,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Consumer<ActiveFeeProvider>(builder: (context, provider, child) {
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
              width: 24,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Text(
                    'Lọc theo',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<FilterActiveFee>(
                    value: provider.valueFilterType,
                    icon: const RotatedBox(
                      quarterTurns: 5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    underline: const SizedBox.shrink(),
                    onChanged: (FilterActiveFee? value) {
                      provider.updateFilterType(value!);
                    },
                    items: provider.listFilterType
                        .map<DropdownMenuItem<FilterActiveFee>>(
                            (FilterActiveFee value) {
                      return DropdownMenuItem<FilterActiveFee>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            value.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final selected = await showMonthYearPicker(
                  context: context,
                  initialDate: provider.currentDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now(),
                );
                provider.changeDate(selected!);
                String month = TimeUtils.instance.getFormatMonth(selected);
                nowMonth = month;
                _activeFeeBloc.add(ActiveFeeGetListEvent(month: month));
                _activeFeeBloc.add(ActiveFeeGetTotalEvent(month: month));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Tháng',
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      TimeUtils.instance
                          .formatMonthToString(provider.currentDate),
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
            BlocConsumer<ActiveFeeBloc, ActiveFeeState>(
              listener: (context, state) {
                if (state is ActiveFeeGetTotalSuccessState) {
                  activeFeeStaticDto = state.activeFeeStaticDto;
                }
              },
              builder: (context, state) {
                return Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    _buildTemplateTotal(
                        'Tổng GD', activeFeeStaticDto.totalTrans.toString()),
                    const SizedBox(
                      width: 12,
                    ),
                    _buildTemplateTotal(
                        'Tổng số tiền',
                        StringUtils.formatNumber(
                            activeFeeStaticDto.totalPayment.toString())),
                    const SizedBox(
                      width: 12,
                    ),
                    _buildTemplateTotal(
                        'Chưa TT',
                        StringUtils.formatNumber(
                            activeFeeStaticDto.totalPaymentUnpaid.toString()),
                        valueColor: AppColor.RED_TEXT),
                    const SizedBox(
                      width: 12,
                    ),
                    _buildTemplateTotal(
                        'Đã TT',
                        StringUtils.formatNumber(
                            activeFeeStaticDto.totalPaymentPaid.toString()),
                        valueColor: AppColor.BLUE_TEXT),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTemplateTotal(String title, String value,
      {Color valueColor = AppColor.GREY_TEXT}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.GREY_BG,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11, color: valueColor),
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
}

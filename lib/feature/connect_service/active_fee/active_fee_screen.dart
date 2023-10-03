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
            return SingleChildScrollView(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1350,
                    child: Column(
                      children: [
                        _buildTitleItem(),
                        ...listActiveFeeDTO.map((e) {
                          int i = listActiveFeeDTO.indexOf(e);
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
    });
  }

  Widget _buildTitleItem() {
    return Row(
      children: const [
        SizedBox(
          width: 50,
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'No.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Merchant',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Bank Account',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Gói dịch vụ',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 136,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'GD Ghi nhận',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Tổng GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 140,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Tổng tiền GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'VAT',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Khuyến mại',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Số tiền cần thu',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Trạng thái',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20, right: 20),
            child: Text(
              'Action',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(int index, ActiveFeeDTO dto) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: AppColor.BLACK_LIGHT))),
      child: Padding(
        padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.5,
                          color: AppColor.GREY_TEXT.withOpacity(0.5)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SelectableText(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 12),
                      child: SelectableText(
                        dto.merchant,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 20),
                      child: SelectableText(
                        StringUtils.formatNumber(dto.totalPayment.toString()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 20),
                      child: SelectableText(
                        dto.status == 1 ? 'Đã TT' : 'Chưa TT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: dto.status == 1
                                ? AppColor.BLACK
                                : AppColor.RED_TEXT,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: Text(
                          dto.status == 0 ? 'Đã thanh toán' : 'Chi tiết',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.BLUE_TEXT,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (dto.bankAccounts?.isNotEmpty ?? false)
              Row(
                children: [
                  const SizedBox(
                    width: 170,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: dto.bankAccounts!.map((bankAccount) {
                      int index = dto.bankAccounts!.indexOf(bankAccount);
                      return Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    width: 0.5,
                                    color: AppColor.GREY_TEXT.withOpacity(0.5)),
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: index + 1 == dto.bankAccounts!.length
                                        ? AppColor.TRANSPARENT
                                        : AppColor.GREY_TEXT
                                            .withOpacity(0.5)))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, left: 20),
                                child: SelectableText(
                                  bankAccount.bankAccount,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            if (bankAccount.fees?.isNotEmpty ?? false)
                              Column(
                                children: bankAccount.fees!.map((e) {
                                  return _buildItemFee(e);
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemFee(FeeDTO dto) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.shortName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 139,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
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
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.totalTrans.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
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
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${dto.vat}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              StringUtils.formatNumber(dto.discountAmount.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              StringUtils.formatNumber(dto.totalPayment.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.status == 1 ? 'Đã TT' : 'Chưa TT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 1 ? AppColor.BLACK : AppColor.RED_TEXT),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
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
            if (provider.currentPage == 0) ...[
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
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
            ],
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
}

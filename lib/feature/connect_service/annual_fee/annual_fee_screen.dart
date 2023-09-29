import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/feature/connect_service/annual_fee/bloc/annual_fee_bloc.dart';
import 'package:vietqr_admin/feature/connect_service/annual_fee/event/annual_fee_event.dart';
import 'package:vietqr_admin/feature/connect_service/annual_fee/provider/annual_fee_provider.dart';
import 'package:vietqr_admin/feature/connect_service/annual_fee/state/annual_fee_state.dart';
import 'package:vietqr_admin/models/annual_fee_dto.dart';

class AnnualFeeScreen extends StatefulWidget {
  const AnnualFeeScreen({Key? key}) : super(key: key);

  @override
  State<AnnualFeeScreen> createState() => _AnnualFeeScreenState();
}

class _AnnualFeeScreenState extends State<AnnualFeeScreen> {
  late AnnualFeeBloc _annualFeeBloc;
  List<AnnualFeeDTO> listAnnualFee = [];
  StreamSubscription? _subscription;
  @override
  void initState() {
    _annualFeeBloc = AnnualFeeBloc()..add(const AnnualFeeGetListEvent());

    _subscription = eventBus.on<RefreshListAnnualFee>().listen((data) {
      _annualFeeBloc = AnnualFeeBloc()..add(const AnnualFeeGetListEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnnualFeeBloc>(
      create: (context) => _annualFeeBloc,
      child: ChangeNotifierProvider<AnnualFeeProvider>(
        create: (context) => AnnualFeeProvider(),
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: BlocConsumer<AnnualFeeBloc, AnnualFeeState>(
                listener: (context, state) {
                  if (state is AnnualFeeGetListSuccessState) {
                    listAnnualFee = state.result;
                  }
                },
                builder: (context, state) {
                  if (state is AnnualFeeLoadingState) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text('Đang tải...')),
                    );
                  } else {
                    if (listAnnualFee.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: Text('Không có dữ liệu')),
                      );
                    } else {
                      return _buildList();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1300,
              child: Column(
                children: [
                  _buildTitleItem(),
                  ...listAnnualFee.map((e) {
                    int i = listAnnualFee.indexOf(e);
                    return _buildItem(i, e);
                  }).toList()
                ],
              ),
            ),
          ),
        ),
      );
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
          width: 130,
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
          width: 110,
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
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Phí thuê bao',
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
              'Chu kỳ',
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
              'Đầu kì',
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
              'Cuối kỳ',
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
          width: 150,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Số tiền cần TT',
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

  Widget _buildItem(int index, AnnualFeeDTO dto) {
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
                        style: TextStyle(
                            fontSize: 12,
                            color: dto.status == 0
                                ? AppColor.RED_TEXT
                                : AppColor.BLACK),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 12),
                      child: SelectableText(
                        dto.merchant,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: dto.status == 0
                                ? AppColor.RED_TEXT
                                : AppColor.BLACK),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 20),
                      child: SelectableText(
                        StringUtils.formatNumber(dto.totalPayment.toString()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: dto.status == 0
                                ? AppColor.RED_TEXT
                                : AppColor.BLACK),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
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
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: Text(
                          dto.status == 1 ? '' : 'Đã thanh toán',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.BLUE_TEXT,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (dto.bankAccounts?.isNotEmpty ?? false)
              Row(
                children: [
                  const Spacer(),
                  Column(
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
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              StringUtils.formatNumber(dto.annualFee.toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${dto.monthlyCycle}T',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              TimeUtils.instance.formatOnlyDate(dto.startDate),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              TimeUtils.instance.formatOnlyDate(dto.endDate),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
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
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              StringUtils.formatNumber(dto.totalPayment.toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 0 ? AppColor.RED_TEXT : AppColor.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 100,
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
    return Consumer<AnnualFeeProvider>(builder: (context, provider, child) {
      return Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
        child: Row(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phí thuê bao',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 8),
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: AppColor.GREY_BG,
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Lọc theo',
            //         style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
            //       ),
            //       const SizedBox(
            //         width: 20,
            //       ),
            //       DropdownButton<FilterAnnualFee>(
            //         value: provider.valueFilter,
            //         icon: const RotatedBox(
            //           quarterTurns: 5,
            //           child: Icon(
            //             Icons.arrow_forward_ios,
            //             size: 12,
            //           ),
            //         ),
            //         underline: const SizedBox.shrink(),
            //         onChanged: (FilterAnnualFee? value) {
            //           provider.updateFilter(value!);
            //         },
            //         items: provider.listFilter
            //             .map<DropdownMenuItem<FilterAnnualFee>>(
            //                 (FilterAnnualFee value) {
            //           return DropdownMenuItem<FilterAnnualFee>(
            //             value: value,
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 4),
            //               child: Text(
            //                 value.title,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //             ),
            //           );
            //         }).toList(),
            //       ),
            //     ],
            //   ),
            // ),
            // if (provider.valueFilter.id == 0) ...[
            //   const SizedBox(
            //     width: 16,
            //   ),
            //   InkWell(
            //     onTap: () async {
            //       final selected = await showMonthYearPicker(
            //         context: context,
            //         initialDate: provider.currentDate,
            //         firstDate: DateTime(2022),
            //         lastDate: DateTime(20240),
            //       );
            //       provider.changeDate(selected!);
            //     },
            //     child: Container(
            //       margin: const EdgeInsets.symmetric(vertical: 8),
            //       padding: const EdgeInsets.symmetric(horizontal: 12),
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         color: AppColor.GREY_BG,
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       child: Row(
            //         children: [
            //           const Text(
            //             'Tháng',
            //             style:
            //                 TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
            //           ),
            //           const SizedBox(
            //             width: 20,
            //           ),
            //           Text(
            //             TimeUtils.instance
            //                 .formatMonthToString(provider.currentDate),
            //             style: const TextStyle(fontSize: 11),
            //           ),
            //           const SizedBox(
            //             width: 8,
            //           ),
            //           const Icon(
            //             Icons.calendar_month_outlined,
            //             size: 12,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ]
          ],
        ),
      );
    });
  }
}

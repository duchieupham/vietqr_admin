import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/provider/synthesis_repor_provider.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/widget/dialog_pick_month.dart';
import '../../../models/DTO/bank_account_dto.dart';
import '../../../models/DTO/synthesis_report_dto.dart';

class SynthesisReport extends StatefulWidget {
  const SynthesisReport({super.key});

  @override
  State<SynthesisReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SynthesisReport> {
  late MerchantBloc merchantBloc;

  List<SynthesisReportDTO> listSynthesisReport = [];

  @override
  void initState() {
    super.initState();
    merchantBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SynthesisReportProvider>(
      create: (context) => SynthesisReportProvider()..getListBankAccount(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            return BlocConsumer<MerchantBloc, MerchantState>(
                listener: (context, state) {
              if (state is MerchantLoadingListState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is MerchantGetSynthesisReportSuccessfulState) {
                if (!state.isLoadingPage) {
                  Navigator.pop(context);
                }

                listSynthesisReport = state.list;
              }
            }, builder: (context, state) {
              if (state is MerchantLoadingInitState) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                if (listSynthesisReport.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text('Không có dữ liệu')),
                  );
                } else {
                  return Consumer<SynthesisReportProvider>(
                      builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: provider.valueFilter.id == 1 ? 1090 : 970,
                            child: Column(
                              children: [
                                _buildTitleItem(provider.valueFilter.id == 1),
                                _buildItemTotal(
                                    0, listSynthesisReport.first, provider),
                              ],
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width:
                                      provider.valueFilter.id == 1 ? 1090 : 970,
                                  child: Column(
                                    children: listSynthesisReport.map((e) {
                                      int i = listSynthesisReport.indexOf(e);
                                      return _buildItem(i, e, provider);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                }
              }
            });
          }))
        ],
      ),
    );
  }

  Widget _buildItem(
      int index, SynthesisReportDTO dto, SynthesisReportProvider provider) {
    if (index > 0) {
      return Container(
        color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
        alignment: Alignment.center,
        child: Row(
          children: [
            _buildBoxItem('${index + 1}',
                width: 50,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            if (provider.valueFilter.id == 1)
              _buildBoxItem(
                  '${provider.bankAccountDTO.bankShortName}\n${provider.bankAccountDTO.bankAccount}',
                  width: 120,
                  textAlign: TextAlign.start,
                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            if (provider.valueTimeFilter.id == 1)
              _buildBoxItem(TimeUtils.instance.formatDate(dto.time),
                  width: 120,
                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal)
            else
              _buildBoxItem(TimeUtils.instance.formatMonthYear(dto.time),
                  width: 120,
                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem(dto.totalTrans.toString(),
                width: 120,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem('${StringUtils.formatNumber(dto.totalAmount)} VND',
                width: 160,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem(dto.totalTransC.toString(),
                width: 100,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem('${StringUtils.formatNumber(dto.totalCredit)} VND',
                width: 160,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem(dto.totalTransD.toString(),
                width: 100,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
            _buildBoxItem('${StringUtils.formatNumber(dto.totalDebit)} VND',
                width: 160,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildItemTotal(
      int index, SynthesisReportDTO dto, SynthesisReportProvider provider) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          _buildBoxItem('${index + 1}',
              width: 50,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          if (provider.valueFilter.id == 1)
            _buildBoxItem(
                '${provider.bankAccountDTO.bankShortName}\n${provider.bankAccountDTO.bankAccount}',
                width: 120,
                textAlign: TextAlign.start,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          if (provider.valueTimeFilter.id == 1)
            _buildBoxItem(TimeUtils.instance.formatDate(dto.time),
                width: 120,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal)
          else
            _buildBoxItem(TimeUtils.instance.formatMonthYear(dto.time),
                width: 120,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem(dto.totalTrans.toString(),
              width: 120,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalAmount)} VND',
              width: 160,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem(dto.totalTransC.toString(),
              width: 100,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalCredit)} VND',
              width: 160,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem(dto.totalTransD.toString(),
              width: 100,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
          _buildBoxItem('${StringUtils.formatNumber(dto.totalDebit)} VND',
              width: 160,
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal),
        ],
      ),
    );
  }

  Widget _buildBoxItem(String value,
      {double width = 100,
      Color? valueColor,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.center}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)),
              right: BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.1)))),
      height: 50,
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

  Widget _buildTitleItem(bool showTk) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('No.', width: 50, padding: EdgeInsets.zero),
          if (showTk)
            _buildItemTitle('TK ngân hàng',
                width: 120, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('Thời gian',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('Tổng giao dịch',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('Tổng tiền giao dịch',
              width: 160, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('GD vào',
              width: 100, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('Tổng tiền vào',
              width: 160, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('GD ra',
              width: 100, padding: const EdgeInsets.symmetric(horizontal: 4)),
          _buildItemTitle('Tổng tiền ra',
              width: 160, padding: const EdgeInsets.symmetric(horizontal: 4)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Consumer<SynthesisReportProvider>(
        builder: (context, provider, child) {
      return Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
        child: Row(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Báo cáo tổng hợp',
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
              width: 180,
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
                    'Lọc theo',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<FilterTransaction>(
                    value: provider.valueFilter,
                    icon: const RotatedBox(
                      quarterTurns: 5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    underline: const SizedBox.shrink(),
                    onChanged: (FilterTransaction? value) {
                      provider.changeFilter(value!);
                      merchantBloc.add(GetSynthesisReportEvent(
                          customerSyncId: Session.instance.connectDTO.id,
                          time: provider.time,
                          bankId: provider.bankAccountDTO.bankId,
                          type: provider.type,
                          isLoadingPage: false));
                    },
                    items: provider.listFilter
                        .map<DropdownMenuItem<FilterTransaction>>(
                            (FilterTransaction value) {
                      return DropdownMenuItem<FilterTransaction>(
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
            const SizedBox(
              width: 12,
            ),
            if (provider.valueFilter.id == 1) ...[
              Container(
                width: 200,
                height: 40,
                margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Số tài khoản',
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<BankAccountDTO>(
                      value: provider.bankAccountDTO,
                      icon: const RotatedBox(
                        quarterTurns: 5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ),
                      underline: const SizedBox.shrink(),
                      onChanged: (BankAccountDTO? value) {
                        provider.changeBankAccount(value!);
                        merchantBloc.add(GetSynthesisReportEvent(
                            customerSyncId: Session.instance.connectDTO.id,
                            time: provider.time,
                            bankId: provider.bankAccountDTO.bankId,
                            type: provider.type,
                            isLoadingPage: false));
                      },
                      items: provider.bankAccounts
                          .map<DropdownMenuItem<BankAccountDTO>>(
                              (BankAccountDTO value) {
                        return DropdownMenuItem<BankAccountDTO>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              value.bankAccount,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              width: 140,
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
                    'Thời gian',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<FilterTimeTransaction>(
                    value: provider.valueTimeFilter,
                    icon: const RotatedBox(
                      quarterTurns: 5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    underline: const SizedBox.shrink(),
                    onChanged: (FilterTimeTransaction? value) {
                      provider.changeTimeFilter(value!);
                      merchantBloc.add(GetSynthesisReportEvent(
                          customerSyncId: Session.instance.connectDTO.id,
                          time: provider.time,
                          bankId: provider.bankAccountDTO.bankId,
                          type: provider.type,
                          isLoadingPage: false));
                    },
                    items: provider.listTimeFilter
                        .map<DropdownMenuItem<FilterTimeTransaction>>(
                            (FilterTimeTransaction value) {
                      return DropdownMenuItem<FilterTimeTransaction>(
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
            const SizedBox(
              width: 12,
            ),
            if (provider.valueTimeFilter.id == 1)
              InkWell(
                onTap: () async {
                  // final selected = await showMonthYearPicker(
                  //   context: context,
                  //   initialDate: provider.timeCurrent,
                  //   firstDate: DateTime(2022),
                  //   lastDate: DateTime.now(),
                  // );
                  DateTime selected = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Material(
                        color: AppColor.TRANSPARENT,
                        child: Center(
                          child: DialogPickDate(
                            year: 2,
                            dateTime: provider.timeCurrent,
                          ),
                        ),
                      );
                    },
                  );
                  provider.updateCurrentTime(selected);

                  merchantBloc.add(GetSynthesisReportEvent(
                      customerSyncId: Session.instance.connectDTO.id,
                      time: provider.time,
                      bankId: provider.bankAccountDTO.bankId,
                      type: provider.type,
                      isLoadingPage: false));
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
                            .formatMonthToString(provider.timeCurrent),
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
              )
            else
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
                        merchantBloc.add(GetSynthesisReportEvent(
                            customerSyncId: Session.instance.connectDTO.id,
                            time: value.toString(),
                            bankId: provider.bankAccountDTO.bankId,
                            type: provider.type,
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
          ],
        ),
      );
    });
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

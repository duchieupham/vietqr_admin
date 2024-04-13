import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/statistic_provider.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../../models/DTO/api_service_dto.dart';
import '../../../../models/DTO/bank_account_dto.dart';
import '../../../../models/DTO/statistic_dto.dart';
import '../events/info_connect_event.dart';

class InformationPopup extends StatefulWidget {
  const InformationPopup({Key? key}) : super(key: key);

  @override
  State<InformationPopup> createState() => _InformationPopupState();
}

class _InformationPopupState extends State<InformationPopup> {
  ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
  late InfoConnectBloc infoConnectBloc;
  List<BankAccountDTO> result = [];
  StatisticDTO statisticDTO = const StatisticDTO();

  @override
  void initState() {
    infoConnectBloc = InfoConnectBloc()
      ..add(GetStatisticEvent(param: {
        'type': 9,
        'customerSyncId': Session.instance.connectDTO.id,
        'month': 0,
      }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            SizedBox(
              width: 600,
              child: _buildStatistic(),
            ),
            const SizedBox(
              width: 32,
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        );
      }),
    );
  }

  Widget _buildStatistic() {
    return BlocProvider<InfoConnectBloc>(
      create: (BuildContext context) => infoConnectBloc,
      child: BlocConsumer<InfoConnectBloc, InfoConnectState>(
          listener: (context, state) {
        if (state is GetStatisticSuccessState) {
          statisticDTO = state.dto;
        }
      }, builder: (context, state) {
        return ChangeNotifierProvider<StatisticProvider>(
          create: (context) => StatisticProvider(),
          child:
              Consumer<StatisticProvider>(builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thống kê lượng giao dịch',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.GREY_BG,
                        border:
                            Border.all(width: 0.5, color: AppColor.GREY_TEXT),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Lọc theo',
                            style: TextStyle(
                                fontSize: 11, color: AppColor.GREY_TEXT),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          DropdownButton<FilterStatistic>(
                            value: provider.valueFilter,
                            icon: const RotatedBox(
                              quarterTurns: 5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            onChanged: (FilterStatistic? value) {
                              provider.updateFilter(value!);
                              if (value.id == 0) {
                                infoConnectBloc.add(GetStatisticEvent(param: {
                                  'type': 0,
                                  'customerSyncId':
                                      Session.instance.connectDTO.id,
                                  'month': TimeUtils.instance
                                      .getFormatMonth(DateTime.now()),
                                }));
                              } else {
                                infoConnectBloc.add(GetStatisticEvent(param: {
                                  'type': 9,
                                  'customerSyncId':
                                      Session.instance.connectDTO.id,
                                  'month': 0,
                                }));
                              }
                            },
                            items: provider.listFilter
                                .map<DropdownMenuItem<FilterStatistic>>(
                                    (FilterStatistic value) {
                              return DropdownMenuItem<FilterStatistic>(
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
                    if (provider.valueFilter.id == 0) ...[
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () async {
                          final selected = await showMonthYearPicker(
                            context: context,
                            initialDate: provider.month,
                            firstDate: DateTime(2022),
                            lastDate: DateTime(20240),
                          );
                          provider.updateMonth(selected!);
                          infoConnectBloc.add(GetStatisticEvent(param: {
                            'type': 0,
                            'customerSyncId': Session.instance.connectDTO.id,
                            'month':
                                TimeUtils.instance.getFormatMonth(selected),
                          }));
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.GREY_BG,
                            border: Border.all(
                                width: 0.5, color: AppColor.GREY_TEXT),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Tháng',
                                style: TextStyle(
                                    fontSize: 11, color: AppColor.GREY_TEXT),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                TimeUtils.instance
                                    .formatMonthToString(provider.month),
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
                    ]
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildTemplateInfo('Tổng giao dịch',
                    statisticDTO.totalTrans.toString(), 'giao dịch'),
                _buildTemplateInfo('Giao dịch đến',
                    statisticDTO.totalTransC.toString(), 'giao dịch'),
                _buildTemplateInfo('Giao dịch đi',
                    statisticDTO.totalTransD.toString(), 'giao dịch'),
                _buildTemplateInfo(
                    'Tổng tiền',
                    StringUtils.formatAmount(
                        statisticDTO.totalCashOut + statisticDTO.totalCashIn),
                    'VND'),
                _buildTemplateInfo('Tổng tiền vào',
                    StringUtils.formatAmount(statisticDTO.totalCashIn), 'VND'),
                _buildTemplateInfo('Tổng tiền đi',
                    StringUtils.formatAmount(statisticDTO.totalCashOut), 'VND'),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _buildTemplateInfo(String title, String value, String subText) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.BANK_CARD_COLOR_3.withOpacity(0.15)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
              flex: 2,
              child: SelectableText(
                '$value      $subText',
                style: const TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
  }
}

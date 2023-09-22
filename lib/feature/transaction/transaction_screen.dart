import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/transaction/bloc/transaction_bloc.dart';
import 'package:vietqr_admin/feature/transaction/event/transaction_event.dart';
import 'package:vietqr_admin/feature/transaction/state/transaction_state.dart';
import 'package:vietqr_admin/feature/transaction/widget/transaction_detail.dart';
import 'package:vietqr_admin/models/transaction_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import 'provider/transaction_provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionProvider>(
        create: (context) => TransactionProvider(),
        child: const _TransactionScreen());
  }
}

class _TransactionScreen extends StatefulWidget {
  const _TransactionScreen({Key? key}) : super(key: key);

  @override
  State<_TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<_TransactionScreen> {
  StreamSubscription? _subscription;
  late TransactionBloc _bloc;
  final PageController pageViewController = PageController();
  List<TransactionDTO> transactionList = [];
  int offset = 0;
  ScrollController scrollControllerList = ScrollController();
  bool isCalling = true;
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<TransactionProvider>(context, listen: false);
    scrollControllerList.addListener(() {
      if (isCalling) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          Map<String, dynamic> param = {};
          offset = offset + 20;
          param['type'] = provider.valueFilter.id;
          if (provider.valueTimeFilter.id == 0 ||
              (provider.valueFilter.id != 0 && provider.valueFilter.id != 9)) {
            param['from'] = '0';
            param['to'] = '0';
          } else {
            param['from'] =
                TimeUtils.instance.getCurrentDate(provider.fromDate);
            param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
          }
          param['value'] = provider.keywordSearch;
          param['offset'] = offset;
          _bloc.add(TransactionGetListEvent(param: param, isLoadMore: true));
          isCalling = false;
        }
      }
    });
    Map<String, dynamic> param = {};
    param['type'] = 9;
    param['value'] = '';
    param['from'] = '0';
    param['to'] = '0';
    param['offset'] = 0;
    _bloc = TransactionBloc()
      ..add(TransactionGetListEvent(param: param, isLoadingPage: true));
    _subscription = eventBus.on<RefreshTransaction>().listen((data) {
      _bloc.add(TransactionGetListEvent(param: param, isLoadingPage: true));
      provider.resetFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => _bloc,
      child: Column(
        children: [
          _buildTitle(),
          Expanded(
              child: PageView(
            controller: pageViewController,
            children: [_buildListTransaction(), TransactionDetailScreen()],
          ))
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Consumer<TransactionProvider>(builder: (context, provider, child) {
        return Row(
          children: [
            if (provider.currentPage == 1)
              InkWell(
                onTap: () {
                  provider.updateCurrentPage(0);
                  pageViewController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.BLUE_TEXT,
                        size: 12,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Trở về',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.BLUE_TEXT),
                      ),
                    ],
                  ),
                ),
              ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giao dịch',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            if (provider.currentPage == 1) ...[
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColor.BLUE_TEXT,
                size: 20,
              ),
              const SizedBox(
                width: 24,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chi tiết giao dịch',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ] else
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
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
                              'Lọc theo',
                              style: TextStyle(
                                  fontSize: 11, color: AppColor.GREY_TEXT),
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
                      if (provider.valueFilter.id == 9 ||
                          provider.valueFilter.id == 0) ...[
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.GREY_BG,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Thời gian',
                                style: TextStyle(
                                    fontSize: 11, color: AppColor.GREY_TEXT),
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
                                },
                                items: provider.listTimeFilter.map<
                                        DropdownMenuItem<
                                            FilterTimeTransaction>>(
                                    (FilterTimeTransaction value) {
                                  return DropdownMenuItem<
                                      FilterTimeTransaction>(
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
                        if (provider.valueTimeFilter.id == 1) ...[
                          InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: provider.fromDate,
                                firstDate: DateTime(2022),
                                lastDate: DateTime.now(),
                              );
                              provider.updateFromDate(date ?? DateTime.now());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_BG,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Từ ngày',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    TimeUtils.instance
                                        .formatDateToString(provider.fromDate),
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
                          InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: provider.toDate,
                                firstDate: DateTime(2022),
                                lastDate: DateTime.now(),
                              );
                              provider.updateToDate(date ?? DateTime.now());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.GREY_BG,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Đến ngày',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    TimeUtils.instance
                                        .formatDateToString(provider.toDate),
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
                      ],
                      if (provider.valueFilter.id != 9)
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 180,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.GREY_BG,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            style: const TextStyle(fontSize: 12),
                            onChanged: (value) {
                              provider.updateKeyword(value);
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 18),
                                border: InputBorder.none,
                                hintText:
                                    'Tìm kiếm bằng ${provider.valueFilter.title.toLowerCase()}',
                                hintStyle: const TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT)),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          if (provider.fromDate.millisecondsSinceEpoch <=
                              provider.toDate.millisecondsSinceEpoch) {
                            Map<String, dynamic> param = {};
                            param['type'] = provider.valueFilter.id;
                            if (provider.valueTimeFilter.id == 0 ||
                                (provider.valueFilter.id != 0 &&
                                    provider.valueFilter.id != 9)) {
                              param['from'] = '0';
                              param['to'] = '0';
                            } else {
                              param['from'] = TimeUtils.instance
                                  .getCurrentDate(provider.fromDate);
                              param['to'] = TimeUtils.instance
                                  .getCurrentDate(provider.toDate);
                            }
                            param['value'] = provider.keywordSearch;
                            param['offset'] = 0;
                            _bloc.add(TransactionGetListEvent(param: param));
                          } else {
                            DialogWidget.instance.openMsgDialog(
                                title: 'Không hợp lệ',
                                msg:
                                    'Ngày bắt đầu không được lớn hơn ngày kết thúc');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Tìm kiếm',
                            style:
                                TextStyle(fontSize: 12, color: AppColor.WHITE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildListTransaction() {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
        if (state is TransactionGetListLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is TransactionGetListSuccessState) {
          if (state.isLoadMore) {
            transactionList.addAll(state.result);
            isCalling = true;
          } else {
            if (state.isPopLoading) {
              Navigator.pop(context);
            }
            transactionList = state.result;
          }
        }
      }, builder: (context, state) {
        if (state is TransactionLoadingState) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('Đang tải...')),
          );
        } else {
          if (transactionList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text('Không có dữ liệu')),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollControllerList,
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: constraints.maxWidth > 1350
                              ? constraints.maxWidth
                              : 1350,
                          child: Column(
                            children: [
                              _buildTitleItem(),
                              ...transactionList.map((e) {
                                int index = transactionList.indexOf(e) + 1;

                                return _buildItem(e, index);
                              }).toList(),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (state is TransactionGetListLoadingLoadMoreState)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Đang tải...'),
                  )
              ],
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
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'No.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 130,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Số TK',
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
              'Số tiền',
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
              'Order ID',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Mã GD (FT Code)',
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
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Nội dung',
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
              'TG tạo GD',
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
              'TG thanh toán',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12, left: 20, right: 20),
          child: Text(
            'Action',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(TransactionDTO dto, int index) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  '$index',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.bankAccount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.transType == 'D'
                      ? '- ${StringUtils.formatNumber(dto.amount.toString())}'
                      : '+ ${StringUtils.formatNumber(dto.amount.toString())}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.orderId.isNotEmpty ? dto.orderId : '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.referenceNumber.isNotEmpty ? dto.referenceNumber : '-',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.getStatus(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: dto.getStatusColor()),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.content,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.timeCreated == 0
                      ? '-'
                      : TimeUtils.instance
                          .formatTimeDateFromInt(dto.timeCreated),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.timePaid == 0
                      ? '-'
                      : TimeUtils.instance.formatTimeDateFromInt(dto.timePaid),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
            child: InkWell(
              onTap: () {
                Session.instance.updateTransactionId(dto.id);

                Provider.of<TransactionProvider>(context, listen: false)
                    .updateCurrentPage(1);

                pageViewController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              },
              child: const Text(
                'Chi tiết',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColor.BLUE_TEXT,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

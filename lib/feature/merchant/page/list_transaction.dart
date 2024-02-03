import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/month_calculator.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/text_field_custom.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/provider/merchant_provider.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';
import 'package:vietqr_admin/models/bank_account_dto.dart';
import 'package:vietqr_admin/models/transaction_merchant_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/constants/configurations/theme.dart';

class ListTransaction extends StatefulWidget {
  const ListTransaction({super.key});

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  List<TransactionMerchantDTO> listTransaction = [];
  MonthCalculator monthCalculator = MonthCalculator();
  late MerchantBloc merchantBloc;

  @override
  initState() {
    super.initState();
    merchantBloc = BlocProvider.of(context);
    init();
  }

  init() {
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = fromDate.subtract(const Duration(days: 7));

    fromDate = fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    Map<String, dynamic> param = {};
    param['merchantId'] = Session.instance.connectDTO.id;
    param['type'] = 9;
    param['value'] = '';
    param['from'] = TimeUtils.instance.getCurrentDate(endDate);
    param['to'] = TimeUtils.instance.getCurrentDate(fromDate);
    param['offset'] = 0;
    merchantBloc.add(
        GetListTransactionByMerchantEvent(param: param, isLoadingPage: true));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MerchantProvider>(
      create: (context) => MerchantProvider()..init(merchantBloc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildFilter(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocConsumer<MerchantBloc, MerchantState>(
                  listener: (context, state) {
                    if (state is MerchantLoadingListState) {
                      DialogWidget.instance.openLoadingDialog();
                    }
                    if (state is MerchantGetListByMerchantSuccessfulState) {
                      if (state.isLoadMore) {
                        listTransaction.addAll(state.list);
                        if (state.list.isNotEmpty) {
                          Provider.of<MerchantProvider>(context, listen: false)
                              .updateCallLoadMore(true);
                        }
                      } else {
                        if (!state.isLoadingPage) {
                          Navigator.pop(context);
                        }
                        listTransaction = state.list;
                      }
                    }

                    if (state is UpdateNoteMerchantFailedState) {
                      DialogWidget.instance
                          .openMsgDialog(title: 'Thông báo', msg: state.msg);
                    }

                    if (state is UpdateNoteState) {
                      onSearch(Provider.of<MerchantProvider>(context,
                          listen: false));
                    }
                  },
                  builder: (context, state) {
                    if (state is MerchantLoadingInitState) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      if (listTransaction.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(child: Text('Không có dữ liệu')),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                controller: Provider.of<MerchantProvider>(
                                        context,
                                        listen: false)
                                    .scrollControllerList,
                                child: ScrollConfiguration(
                                  behavior: MyCustomScrollBehavior(),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: constraints.maxWidth > 1360
                                          ? constraints.maxWidth
                                          : 1360,
                                      child: SelectionArea(
                                        child: Column(
                                          children: [
                                            _buildTitleItem(),
                                            ...listTransaction.map((e) {
                                              int index =
                                                  listTransaction.indexOf(e) +
                                                      1;

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
                            ),
                            if (state is MerchantLoadMoreListState)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()),
                              )
                          ],
                        );
                      }
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(TransactionMerchantDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '$index',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: Text(
              '${dto.bankAccount}\n${dto.bankShortName}',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 110,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.orderId.isNotEmpty ? dto.orderId : '-',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 140,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.referenceNumber.isNotEmpty ? dto.referenceNumber : '-',
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 150,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.transType == 'D'
                  ? '- ${StringUtils.formatNumber(dto.amount)} VND'
                  : '+ ${StringUtils.formatNumber(dto.amount)} VND',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
            ),
          ),
          Container(
            width: 110,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.getStatus(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
            ),
          ),
          Container(
            width: 120,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.timeCreated == 0
                  ? '-'
                  : TimeUtils.instance.formatTimeDateFromInt(dto.timeCreated),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 140,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.timePaid == 0
                  ? '-'
                  : TimeUtils.instance.formatTimeDateFromInt(dto.timePaid),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
              child: Text(
                dto.content,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.type == 0 ? 'Mã VietQR' : 'Khác',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Consumer<MerchantProvider>(
            builder: (context, provider, child) {
              String note = dto.note;

              return Container(
                width: 120,
                height: 50,
                padding: const EdgeInsets.only(left: 8, right: 4),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.GREY_BUTTON),
                        right: BorderSide(color: AppColor.GREY_BUTTON))),
                child: MTextFieldCustom(
                  hintText: '',
                  keyboardAction: TextInputAction.next,
                  value: dto.note,
                  enable: dto.isEdit,
                  onChange: (value) {
                    dto.note = value;
                  },
                  inputType: TextInputType.text,
                  isObscureText: false,
                  textAlign: TextAlign.center,
                  fontSize: 12,
                  fillColor: AppColor.TRANSPARENT,
                  suffixIcon: dto.isEdit
                      ? GestureDetector(
                          onTap: () {
                            dto.note = note;
                            setState(() {});
                          },
                          child: const Icon(Icons.clear, size: 12),
                        )
                      : null,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            },
          ),
          if (!dto.isEdit)
            GestureDetector(
              onTap: () {
                setState(() {
                  dto.isEdit = true;
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                dto.isEdit = false;
                Map<String, dynamic> body = {
                  'note': dto.note,
                  'id': dto.id,
                };
                merchantBloc.add(UpdateNoteMerchantEvent(body));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.done,
                  size: 20,
                  color: AppColor.BLUE_TEXT,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildItemTitle('No.',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Số TK',
              height: 50,
              width: 130,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Mã đơn hàng',
              height: 50,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Mã GD',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Số tiền',
              height: 50,
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Thời gian tạo GD',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Thời gian TT',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          Expanded(
            child: _buildItemTitle('Nội dung',
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center),
          ),
          _buildItemTitle('Loại GD',
              height: 50,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Ghi chú',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Icon(
              Icons.edit,
              color: Colors.transparent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Danh sách giao dịch',
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Consumer<MerchantProvider>(builder: (context, provider, child) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Container(
              width: 180,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
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
                      if (value.id.type == TypeFilter.ALL) {
                        onSearch(provider);
                      }
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
            // if (provider.valueFilter.id.type == TypeFilter.ALL ||
            //     provider.valueFilter.id.type == TypeFilter.BANK_NUMBER ||
            //     provider.valueFilter.id.type == TypeFilter.CODE_SALE) ...[
            //
            // ],
            Container(
              width: 200,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
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
                      if (value.id != TypeTimeFilter.PERIOD.id &&
                          provider.valueFilter.id.type !=
                              TypeFilter.CODE_SALE) {
                        onSearch(provider);
                      }
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
            if (provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id) ...[
              InkWell(
                onTap: () async {
                  DateTime? date = await showDateTimePicker(
                    context: context,
                    initialDate: provider.fromDate,
                    firstDate: DateTime(2021, 6),
                    lastDate: DateTime.now(),
                  );
                  int numberOfMonths = monthCalculator.calculateMonths(
                      date ?? DateTime.now(), provider.toDate);

                  if (numberOfMonths > 3) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg:
                            'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                  } else {
                    provider.updateFromDate(date ?? DateTime.now());
                  }
                },
                child: Container(
                  width: 210,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Từ ngày',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                  DateTime? date = await showDateTimePicker(
                    context: context,
                    initialDate: provider.toDate,
                    firstDate: DateTime(2021, 6),
                    lastDate: DateTime.now(),
                  );
                  int numberOfMonths = monthCalculator.calculateMonths(
                      provider.fromDate, date ?? DateTime.now());

                  if (numberOfMonths > 3) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg:
                            'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                  } else {
                    provider.updateToDate(date ?? DateTime.now());
                  }
                },
                child: Container(
                  width: 220,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Đến ngày',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        TimeUtils.instance.formatDateToString(provider.toDate),
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
            if (provider.valueFilter.id.type == TypeFilter.BANK_NUMBER) ...[
              Container(
                width: 200,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
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
            if (provider.valueFilter.id.type != TypeFilter.ALL &&
                provider.valueFilter.id.type != TypeFilter.BANK_NUMBER)
              Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                width: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  onChanged: (value) {
                    provider.updateKeyword(value);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 18),
                      border: InputBorder.none,
                      hintText:
                          'Tìm kiếm bằng ${provider.valueFilter.title.toLowerCase()}',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT)),
                ),
              ),
            if (provider.valueFilter.id.type != TypeFilter.ALL ||
                provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id)
              InkWell(
                onTap: () {
                  onSearch(provider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Tìm kiếm',
                    style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                  ),
                ),
              ),
            if (provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id ||
                (provider.valueFilter.id == 4 &&
                    provider.valueTimeFilter.id != 0))
              InkWell(
                onTap: () {
                  String link =
                      'https://api.vietqr.org/vqr/api/merchant/transactions-export?merchantId=${Session.instance.connectDTO.id}&type=${provider.valueFilter.id}&value=${provider.keywordSearch}&from=${TimeUtils.instance.formatDateToString(provider.fromDate, isExport: true)}&to=${TimeUtils.instance.formatDateToString(provider.toDate, isExport: true)}';
                  html.window.open(link, 'new tab');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREEN,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Xuất Excel',
                    style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                  ),
                ),
              ),
          ],
        );
      }),
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

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  void onSearch(MerchantProvider provider) {
    if (provider.fromDate.millisecondsSinceEpoch <=
        provider.toDate.millisecondsSinceEpoch) {
      Map<String, dynamic> param = {};
      provider.updateCallLoadMore(true);
      param['type'] = provider.valueFilter.id;
      // if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id ||
      //     (provider.valueFilter.id.type != TypeFilter.BANK_NUMBER &&
      //         provider.valueFilter.id.type != TypeFilter.ALL &&
      //         provider.valueFilter.id.type != TypeFilter.CODE_SALE)) {
      //   param['from'] = '0';
      //   param['to'] = '0';
      // } else {
      //   param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      //   param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      // }
      param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      param['value'] = provider.keywordSearch;

      param['offset'] = 0;
      param['merchantId'] = Session.instance.connectDTO.id;

      merchantBloc.add(GetListTransactionByMerchantEvent(param: param));
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không hợp lệ',
          msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
    }
  }
}

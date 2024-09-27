import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/item_title_widget.dart';
import 'package:vietqr_admin/View/InvoiceManage/Invoice/widgets/bank_account_item.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/constants/enum/view_status.dart';
import 'package:vietqr_admin/commons/constants/utils/month_calculator.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/button.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/data_filter_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_detail_dto.dart';
import 'package:vietqr_admin/models/DTO/invoice_dto.dart';

class PopupRemoveInvoiceDebtWidget extends StatefulWidget {
  final InvoiceItem dto;
  final Function(String) onPop;
  const PopupRemoveInvoiceDebtWidget(
      {super.key, required this.dto, required this.onPop});

  @override
  State<PopupRemoveInvoiceDebtWidget> createState() =>
      _PopupRemoveInvoiceDebtWidgetState();
}

class _PopupRemoveInvoiceDebtWidgetState
    extends State<PopupRemoveInvoiceDebtWidget> {
  late InvoiceViewModel _model;
  DataFilter _filterByTime = const DataFilter(id: 1, name: '7 ngày gần nhất');

  DateTime get now => DateTime.now();
  final monthCalculator = MonthCalculator();

  //khởi tạo thời gian 7 ngày
  DateTime _fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _toDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

  DateTime _formatFromDate(DateTime now) {
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    return fromDate.subtract(const Duration(days: 7));
  }

  // ignore: unused_element
  DateTime _formatEndDate(DateTime now) {
    DateTime fromDate = _formatFromDate(now);
    return fromDate
        .add(const Duration(days: 8))
        .subtract(const Duration(seconds: 1));
  }

  DateFormat get _format => DateFormat('dd/MM/yyyy HH:mm:ss');
  DateFormat get _format2 => DateFormat('yyyy/MM/dd HH:mm:ss');

  DateTime? selectFromDate;
  DateTime? selectToDate;
  int page = 1;
  int size = 5;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();

    // setState(() {
    //   _fromDate =
    //       DateTime.fromMillisecondsSinceEpoch(widget.dto.timeCreated * 1000);
    // });

    _model.getInvoiceDetail(widget.dto.invoiceId).then(
      (value) {
        _model.getTransactionInvoiceDebt(
            bankId: _model.bankId,
            fromDate: _format2.format(_fromDate),
            toDate: _format2.format(_toDate),
            page: page,
            size: size);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Stack(
          children: [
            Container(
              color: AppColor.WHITE,
              width: 1250,
              height: 850,
              padding: const EdgeInsets.all(20),
              child: ScopedModel<InvoiceViewModel>(
                model: _model,
                child: ScopedModelDescendant<InvoiceViewModel>(
                  builder: (context, child, model) {
                    bool isEnable = false;
                    if (model.listSelectInvoiceItemDebt.isNotEmpty &&
                        model.listSelectTransactionItemDebt.isNotEmpty) {
                      isEnable = model.listSelectInvoiceItemDebt
                              .any((x) => x.isSelect == true) &&
                          model.invoiceDetailDTO!.paymentRequestDTOS
                              .any((x) => x.isChecked) &&
                          model.listSelectTransactionItemDebt
                              .any((x) => x.isSelect == true);
                    }
                    if (model.invoiceDetailDTO == null) {
                      return const SizedBox.shrink();
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gạch nợ hóa đơn thủ công',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              _buildInvoiceDetailWidget(
                                  model.invoiceDetailDTO!),
                              const MySeparator(color: AppColor.GREY_DADADA),
                              const SizedBox(height: 20),
                              const Text(
                                'Danh mục hàng hoá / dịch vụ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              _buildInvoiceWidget(),
                              const SizedBox(height: 20),
                              const MySeparator(color: AppColor.GREY_DADADA),
                              _buildTransactionWidget(model, _filterByTime),
                              const SizedBox(height: 20),
                              _buildInvoiceWidget(),
                              _buildInvoiceWidget(),
                              _buildInvoiceWidget(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                        if (model.invoiceDetailDTO != null)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              color: AppColor.WHITE,
                              width: 1210,
                              height: 110,
                              child: _buildReqPayment(
                                  model.invoiceDetailDTO!.paymentRequestDTOS,
                                  isEnable),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }

  void updateFromDate(DateTime dateTime) {
    _fromDate = dateTime;
    selectFromDate = dateTime;
    updateState();
  }

  void updateToDate(DateTime dateTime) {
    _toDate = dateTime;
    selectToDate = dateTime;
    updateState();
  }

  void onChangeTimeFilter(DataFilter? value) {
    if (value == null) return;
    _filterByTime = value;
    updateState();
    DateTime endDate = DateTime(now.year, now.month, now.day);
    if (_filterByTime.id == TypeTimeFilter.TODAY.id ||
        _filterByTime.id == TypeTimeFilter.PERIOD.id) {
      DateTime fromDate = endDate;
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.SEVEN_LAST_DAY.id) {
      DateTime fromDate = endDate.subtract(const Duration(days: 7));

      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.THIRTY_LAST_DAY.id) {
      DateTime fromDate = endDate.subtract(const Duration(days: 30));
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    } else if (_filterByTime.id == TypeTimeFilter.THREE_MONTH_LAST_DAY.id) {
      // DateTime fromDate = Jiffy(endDate).subtract(months: 3).dateTime;
      DateTime fromDate =
          Jiffy.parseFromDateTime(endDate).subtract(months: 3).dateTime;
      endDate = endDate
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      updateFromDate(fromDate);
      updateToDate(endDate);
    }
  }

  Widget _buildReqPayment(List<PaymentRequestDTO> listReq, bool isEnable) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn giao dịch theo tài khoản',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectBankRecieveItem(
                        dto: listReq[index],
                        onChange: (value) {
                          _model.changePayment(index);
                          _model.changeBankId(index, _format.format(_fromDate),
                              _format.format(_toDate), page, size);
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
                    itemCount: listReq.length),
              ),
            ],
          ),
        ),
        MButtonWidget(
          colorDisableBgr: AppColor.GREY_DADADA,
          width: 300,
          height: 50,
          title: 'Xác nhận',
          isEnable: isEnable,
          margin: EdgeInsets.zero,
          onTap: isEnable
              ? () async {
                  _model
                      .mapInvoiceDebt(
                          invoiceId: widget.dto.invoiceId,
                          invoiceItemList: _model.listInvoiceItemDebtRequest,
                          transactionList: _model.listTransactionInvoiceDebt)
                      .then(
                    (value) {
                      if (value) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        toastification.show(
                          context: context,
                          type: ToastificationType.success,
                          style: ToastificationStyle.flat,
                          title: const Text(
                            'Gạch nợ thành công',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          showProgressBar: false,
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 5),
                          boxShadow: highModeShadow,
                          dragToClose: true,
                          pauseOnHover: true,
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildInvoiceWidget() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading &&
            model.request == InvoiceType.GET_INVOICE_DETAIL) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
        if (model.invoiceDetailDTO == null ||
            model.listInvoiceDetailItem.isEmpty) {
          return const SizedBox.shrink();
        }
        bool isAllSelectInvoice = model.listSelectInvoiceItemDebt
            .every((element) => element.isSelect == true);
        return SizedBox(
          width: 700,
          height: model.listSelectInvoice.length >= 4 ? 250 : 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: AppColor.BLUE_TEXT,
                            value: isAllSelectInvoice,
                            onChanged: (value) {
                              model.appliedAllTransactionDebt(value!);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color:
                                        AppColor.GREY_TEXT.withOpacity(0.3))),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tất cả',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const BuildItemlTitle(
                        title: 'STT',
                        textAlign: TextAlign.center,
                        width: 50,
                        height: 50,
                        alignment: Alignment.centerLeft),
                    const BuildItemlTitle(
                        title: 'Nội dung hoá đơn thanh toán',
                        height: 50,
                        width: 250,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 4),
                        textAlign: TextAlign.center),
                    const BuildItemlTitle(
                        title: 'Tổng tiền (VND)',
                        height: 50,
                        width: 150,
                        alignment: Alignment.centerLeft,
                        textAlign: TextAlign.center),
                    const BuildItemlTitle(
                        title: 'Trạng thái',
                        height: 50,
                        width: 120,
                        alignment: Alignment.centerLeft,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 700,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColor.GREY_DADADA, width: 1),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      // bool isAlreadyPay =
                      //     model.listInvoiceDetailItem[index].status == 1;
                      // if (isAlreadyPay) {
                      //   model.appliedInvoiceItem(isAlreadyPay, index);
                      // }
                      return _invoiceItemWidget(
                          index: index,
                          dto: model.listSelectInvoiceItemDebt[index],
                          model: model);
                    },
                    itemCount: model.listSelectInvoice.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _invoiceItemWidget(
      {required int index,
      required SelectInvoiceItemDebt dto,
      required InvoiceViewModel model}) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: 100,
            height: 50,
            child: Checkbox(
              activeColor: AppColor.BLUE_TEXT,
              value: dto.isSelect,
              onChanged: (value) {
                setState(() {
                  model.appliedInvoiceItemDebt(value!, index);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: AppColor.GREY_TEXT.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                (index + 1).toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 250,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.invoiceItemName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatNumberWithOutVND(
                    dto.invoiceItem.totalAmountAfterVat),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                dto.invoiceItem.status == 0
                    ? 'Chưa thanh toán'
                    : 'Đã thanh toán',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dto.invoiceItem.status == 0
                        ? AppColor.ORANGE
                        : AppColor.GREEN),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInvoiceDebt() {
    return ScopedModelDescendant<InvoiceViewModel>(
      builder: (context, child, model) {
        if (model.status == ViewStatus.Loading &&
            model.request == InvoiceType.GET_INVOICE_DETAIL) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
        if (model.listTransactionInvoice.isEmpty) {
          return const SizedBox.shrink();
        }
        bool isAllSelectInvoice = model.listSelectTransactionItemDebt
            .every((element) => element.isSelect == true);
        return SizedBox(
          width: 700,
          height: model.listSelectInvoice.length >= 4 ? 250 : 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: AppColor.BLUE_TEXT,
                            value: isAllSelectInvoice,
                            onChanged: (value) {
                              model.appliedAllItemDebt(value!);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color:
                                        AppColor.GREY_TEXT.withOpacity(0.3))),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tất cả',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const BuildItemlTitle(
                        title: 'STT',
                        textAlign: TextAlign.center,
                        width: 50,
                        height: 50,
                        alignment: Alignment.centerLeft),
                    const BuildItemlTitle(
                        title: 'Nội dung hoá đơn thanh toán',
                        height: 50,
                        width: 250,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 4),
                        textAlign: TextAlign.center),
                    const BuildItemlTitle(
                        title: 'Tổng tiền (VND)',
                        height: 50,
                        width: 150,
                        alignment: Alignment.centerLeft,
                        textAlign: TextAlign.center),
                    const BuildItemlTitle(
                        title: 'Trạng thái',
                        height: 50,
                        width: 120,
                        alignment: Alignment.centerLeft,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 700,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColor.GREY_DADADA, width: 1),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      // bool isAlreadyPay =
                      //     model.listInvoiceDetailItem[index].status == 1;
                      // if (isAlreadyPay) {
                      //   model.appliedInvoiceItem(isAlreadyPay, index);
                      // }
                      return _invoiceItemWidget(
                          index: index,
                          dto: model.listSelectInvoiceItemDebt[index],
                          model: model);
                    },
                    itemCount: model.listSelectInvoice.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInvoiceDetailWidget(InvoiceDetailDTO dto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _itemTitleWidget(),
        _invoiceDetailWidget(dto),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _invoiceDetailWidget(InvoiceDetailDTO dto) {
    Color color = AppColor.WHITE;
    String status = '';
    switch (dto.status) {
      case 0:
        status = 'Chưa thanh toán';
        color = AppColor.ORANGE_DARK;
        break;
      case 1:
        status = 'Đã thanh toán';
        color = AppColor.GREEN;

        break;
      case 3:
        status = 'Chưa TT hết';
        color = AppColor.GREEN_2D9D92;

        break;
      default:
        status;
        break;
    }
    return Container(
      color: AppColor.WHITE,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 260,
            padding: const EdgeInsets.only(right: 4),
            child: SelectionArea(
              child: Text(
                dto.invoiceName,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                widget.dto.billNumber,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(dto.totalAmountAfterVat),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN_2D9D92,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 100,
            child: SelectionArea(
              child: Text(
                widget.dto.vso.isNotEmpty ? widget.dto.vso : '-',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(dto.totalUnpaid),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.ORANGE_DARK,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                StringUtils.formatAmount(dto.totalPaid),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.GREEN,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                status,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColor.WHITE,
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_DADADA, width: 0.5))),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'Hoá đơn',
              textAlign: TextAlign.center,
              width: 260,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Mã hoá đơn',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tổng tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VSO',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chưa TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đã TT (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Trạng thái',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTransactionWidget(InvoiceViewModel model, DataFilter filterBy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          model.paymentRequestDTO != null
              ? 'Danh sách giao dịch đến thuộc ${model.paymentRequestDTO!.bankShortName} - ${model.paymentRequestDTO!.bankAccount}'
              : 'Danh sách giao dịch',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Tìm kiếm GD thanh toán',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                _itemPickTime(onTap: _pickFromDate, borderLeft: true),
                _itemPickTime(
                    title: 'Đến ngày', date: _toDate, onTap: _pickToDate),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: VietQRButton.gradient(
                  borderRadius: 100,
                  onPressed: () {
                    model.getTransactionInvoiceDebt(
                      bankId: model.bankId,
                      fromDate: _format2.format(_fromDate),
                      toDate: _format2.format(_toDate),
                      page: page,
                      size: size,
                    );
                  },
                  isDisabled: false,
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.zero,
                  child: const Center(
                      child: Icon(
                    Icons.search,
                    size: 15,
                    color: AppColor.WHITE,
                  ))),
            ),
          ],
        ),
      ],
    );
  }

  void _pickFromDate() async {
    DateTime? pickFromDate = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: _fromDate,
      firstDate:
          DateTime.fromMillisecondsSinceEpoch(widget.dto.timeCreated * 1000),
      lastDate: DateTime.now(),
    );
    setState(() {
      selectFromDate = pickFromDate;
    });
    int numberOfMonths = monthCalculator.calculateMonths(
        selectFromDate ?? DateTime.now(), _toDate);

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((selectFromDate ?? DateTime.now()).isAfter(_toDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateFromDate(selectFromDate ?? DateTime.now());
      // _onCallBack(fromDate: _fromDate);
    }
  }

  void _pickToDate() async {
    DateTime formattedDate =
        DateTime(_toDate.year, _toDate.month, _toDate.day, 23, 59, 59);
    DateTime? pickToDate = await TimeUtils.instance.showDateTimePicker(
      context: context,
      initialDate: formattedDate,
      firstDate:
          DateTime.fromMillisecondsSinceEpoch(widget.dto.timeCreated * 1000),
      lastDate: DateTime.now(),
    );
    setState(() {
      selectToDate = pickToDate;
    });
    int numberOfMonths = monthCalculator.calculateMonths(
        _fromDate, selectToDate ?? DateTime.now());

    if (numberOfMonths > 3) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo',
          msg: 'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
    } else if ((selectToDate ?? DateTime.now()).isBefore(_fromDate)) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
    } else {
      updateToDate(selectToDate ?? DateTime.now());
      // _onCallBack(toDate: _toDate);
    }
  }

  Widget _itemPickTime(
      {String? title,
      DateTime? date,
      GestureTapCallback? onTap,
      bool borderLeft = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Từ ngày',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 30,
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
              borderRadius: borderLeft
                  ? const BorderRadius.horizontal(left: Radius.circular(5))
                  : const BorderRadius.horizontal(right: Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _format.format(date ?? _fromDate),
                    style: const TextStyle(fontSize: 10, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

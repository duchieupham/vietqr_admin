import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/image_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/feature/transaction/bloc/transaction_bloc.dart';
import 'package:vietqr_admin/feature/transaction/event/transaction_event.dart';
import 'package:vietqr_admin/feature/transaction/state/transaction_state.dart';
import 'package:vietqr_admin/models/transaction_detail_dto.dart';
import 'package:vietqr_admin/models/transaction_log_dto.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

class TransactionDetailScreen extends StatelessWidget {
  TransactionDetailScreen({Key? key}) : super(key: key);

  TransactionDetailDTO transactionDetailDTO = const TransactionDetailDTO();
  List<TransactionLogDTO> listLog = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 20),
      child: _buildInfo(),
    );
  }

  Widget _buildInfo() {
    return BlocProvider<TransactionBloc>(
      create: (BuildContext context) => TransactionBloc()
        ..add(TransactionGetDetailEvent(id: Session.instance.transactionId)),
      child: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
        if (state is TransactionGetDetailSuccessState) {
          transactionDetailDTO = state.result;
          listLog = state.listLog;
        }
      }, builder: (context, state) {
        return Row(
          children: [
            Expanded(flex: 3, child: _buildInfoTransaction()),
            const Expanded(child: SizedBox.shrink()),
            Expanded(flex: 3, child: _buildInfoCustomer())
          ],
        );
      }),
    );
  }

  Widget _buildInfoTransaction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildItemTemplate('ID', transactionDetailDTO.id),
              _buildItemTemplate(
                  'Số tiền',
                  transactionDetailDTO.transType == 'D'
                      ? '- ${StringUtils.formatNumber(transactionDetailDTO.amount.toString())}'
                      : '+ ${StringUtils.formatNumber(transactionDetailDTO.amount.toString())}',
                  colorValue: transactionDetailDTO.getAmountColor()),
              _buildItemTemplate('Order ID', transactionDetailDTO.orderId),
              _buildItemTemplate(
                  'Mã giao dịch', transactionDetailDTO.referenceNumber),
              _buildItemTemplate('Trạng thái', transactionDetailDTO.getStatus(),
                  colorValue: transactionDetailDTO.getStatusColor()),
              _buildItemTemplate('Nội dung', transactionDetailDTO.content),
              _buildItemTemplate(
                  'Thời gian tạo',
                  TimeUtils.instance
                      .formatTimeDateFromInt(transactionDetailDTO.timeCreated)),
              _buildItemTemplate(
                  'Thời gian t.toán',
                  transactionDetailDTO.timePaid == 0
                      ? ''
                      : TimeUtils.instance.formatTimeDateFromInt(
                          transactionDetailDTO.timePaid)),
              _buildItemTemplate('Số Trace', transactionDetailDTO.traceId),
              _buildItemTemplate('Chữ kí', transactionDetailDTO.sign),
              _buildItemTemplate(
                  'Loại giao dịch', transactionDetailDTO.getTypeTrace()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin khách hàng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildItemTemplate(
                'Ngân hàng',
                '${transactionDetailDTO.bankCode} - ${transactionDetailDTO.bankName}',
                logo: Container(
                  height: 36,
                  width: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppColor.GREY_TEXT.withOpacity(0.5)),
                      image: DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(transactionDetailDTO.imgId))),
                ),
              ),
              _buildItemTemplate(
                'Số tài khoản',
                transactionDetailDTO.bankAccount,
              ),
              _buildItemTemplate(
                  'Chủ tải khoản', transactionDetailDTO.userBankName),
              _buildItemTemplate('Trạng thái',
                  transactionDetailDTO.sync ? 'Đã liên kết' : 'Chưa liên kết',
                  colorValue: transactionDetailDTO.sync
                      ? AppColor.BLUE_TEXT
                      : AppColor.BLACK),
              _buildItemTemplate(
                  'Đồng bộ',
                  transactionDetailDTO.flow == 0
                      ? 'Chưa đồng bộ Merchant'
                      : 'Luồng ${transactionDetailDTO.flow}',
                  colorValue: AppColor.BLUE_TEXT),
              const SizedBox(
                height: 40,
              ),
              if (listLog.isNotEmpty) _buildListLog()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Log callback',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 2,
        ),
        const Text(
          'Thông tin này chỉ ghi nhận khi tài khoản ngân hàng có đồng bộ với merchant',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 12,
        ),
        ...listLog.map((e) {
          return _buildItemLog(e);
        }).toList()
      ],
    );
  }

  Widget _buildItemLog(TransactionLogDTO dto) {
    return SelectionArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: dto.status == 'SUCCESS'
                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                : AppColor.RED_TEXT.withOpacity(0.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'URL callback: ',
                  style: TextStyle(fontSize: 12),
                ),
                Expanded(
                    child: Text(
                  dto.urlCallback,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.BLUE_TEXT,
                      decoration: TextDecoration.underline),
                ))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                const Text(
                  'Trạng thái: ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  dto.status == 'SUCCESS' ? 'Thành công' : 'Thất bại',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      color: dto.status == 'SUCCESS'
                          ? AppColor.BLUE_TEXT
                          : AppColor.RED_TEXT,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Thời gian: ${TimeUtils.instance.formatTimeDateFromInt(dto.time.toString().length >= 13 ? dto.time / 1000 : dto.time)}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text('Mô tả: ${dto.message}',
                style: const TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTemplate(String title, String value,
      {Color colorValue = AppColor.BLACK, Widget logo = const SizedBox()}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.GREY_TOP_TAB_BAR.withOpacity(0.3)),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
              child: SelectableText(value.isEmpty ? '-' : value,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: colorValue))),
          logo
        ],
      ),
    );
  }
}

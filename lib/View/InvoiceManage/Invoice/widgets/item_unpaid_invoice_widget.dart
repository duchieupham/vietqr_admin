import 'package:flutter/material.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';

class UnpaidInvoiceItemWidget extends StatefulWidget {
  final int index;
  final SelectUnpaidInvoiceItem dto;
  final InvoiceViewModel model;
  final Function() onTap;

  const UnpaidInvoiceItemWidget({
    super.key,
    required this.index,
    required this.dto,
    required this.model,
    required this.onTap,
  });

  @override
  State<UnpaidInvoiceItemWidget> createState() =>
      _UnpaidInvoiceItemWidgetState();
}

class _UnpaidInvoiceItemWidgetState extends State<UnpaidInvoiceItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              height: 50,
              child: Checkbox(
                activeColor: AppColor.BLUE_TEXT,
                value: widget.dto.isSelect,
                onChanged: (value) {
                  setState(() {
                    widget.model.appliedUnpaidInvoiceItem(value!, widget.index);
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
                  (widget.index + 1).toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 200,
              padding: const EdgeInsets.only(right: 4),
              child: SelectionArea(
                child: Text(
                  widget.dto.unpaidInvoiceItem.invoiceName,
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
              padding: const EdgeInsets.only(right: 4),
              child: SelectionArea(
                child: Text(
                  widget.dto.unpaidInvoiceItem.billNumber,
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
                    widget.dto.unpaidInvoiceItem.pendingAmount,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.GREEN,
                  ),
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
                  widget.dto.unpaidInvoiceItem.vso,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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
                    widget.dto.unpaidInvoiceItem.pendingAmount,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.ORANGE,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 100,
              child: SelectionArea(
                child: Text(
                  StringUtils.formatNumberWithOutVND(
                    widget.dto.unpaidInvoiceItem.completeAmount,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.GREEN,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 80,
              child: InkWell(
                onTap: widget.onTap,
                child: const Text(
                  'Chi tiết',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.BLUE_TEXT,
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

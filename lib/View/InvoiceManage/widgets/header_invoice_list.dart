import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';

class HeaderInvoiceList extends StatefulWidget {
  final Function() onCreateInvoice;
  const HeaderInvoiceList({super.key, required this.onCreateInvoice});

  @override
  State<HeaderInvoiceList> createState() => _HeaderInvoiceListState();
}

class _HeaderInvoiceListState extends State<HeaderInvoiceList> {
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<InvoiceViewModel>(
        model: _model,
        child: ScopedModelDescendant<InvoiceViewModel>(
          builder: (context, child, model) {
            if (model.pageType == PageInvoice.DETAIL) {
              return const Spacer();
            }
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "Quản lý hoá đơn",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        "   /   ",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        "Danh sách hoá đơn",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  Row(
                    children: [
                      MButtonWidget(
                        onTap: widget.onCreateInvoice,
                        title: 'Tạo mới hoá đơn',
                        isEnable: true,
                        margin: EdgeInsets.zero,
                        width: 150,
                        colorEnableBgr: AppColor.WHITE,
                        colorEnableText: AppColor.BLUE_TEXT,
                        border: Border.all(color: AppColor.BLUE_TEXT),
                        radius: 10,
                        height: 40,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}

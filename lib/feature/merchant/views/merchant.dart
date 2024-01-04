import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/feature/dashboard/widget/item_menu_top.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/widget/infomation_popup.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/page/bank_account_synchronized.dart';
import 'package:vietqr_admin/feature/merchant/page/info_service_port.dart';
import 'package:vietqr_admin/feature/merchant/page/list_transaction.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../page/bill.dart';
import '../page/service_charge.dart';
import '../page/synthesis_repor.dart';

class MerchantView extends StatefulWidget {
  const MerchantView({super.key});

  @override
  State<MerchantView> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantView> {
  final ScrollController scrollController = ScrollController();

  int offset = 0;
  int currentType = 0;
  bool isEnded = false;
  String nowMonth = '';

  late MerchantBloc merchantBloc;

  @override
  void initState() {
    super.initState();
    merchantBloc = MerchantBloc();
  }

  changePage(int page) {
    setState(() {
      currentType = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocProvider<MerchantBloc>(
      create: (context) => merchantBloc,
      child: SizedBox(
        width: width,
        height: height - 60,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.1),
              ),
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemMenuTop(
                    title: 'Thông tin đại lý',
                    isSelect: currentType == 0,
                    onTap: () {
                      changePage(0);
                    },
                  ),
                  ItemMenuTop(
                    title: 'Tài khoản đồng bộ',
                    isSelect: currentType == 1,
                    onTap: () {
                      changePage(1);
                    },
                  ),
                  ItemMenuTop(
                    title: 'Thống kê giao dịch',
                    isSelect: currentType == 2,
                    onTap: () {
                      changePage(2);
                      Map<String, dynamic> param = {};
                      param['merchantId'] = Session.instance.connectDTO.id;
                      param['type'] = 9;
                      param['value'] = '';
                      param['from'] = '0';
                      param['to'] = '0';
                      param['offset'] = 0;
                      merchantBloc.add(GetListTransactionByMerchantEvent(
                          param: param, isLoadingPage: true));
                    },
                  ),
                  ItemMenuTop(
                    title: 'Báo cáo tổng hợp',
                    isSelect: currentType == 3,
                    onTap: () {
                      changePage(3);
                      merchantBloc.add(GetSynthesisReportEvent(
                          customerSyncId: Session.instance.connectDTO.id,
                          type: 0,
                          time: DateTime.now().year.toString(),
                          isLoadingPage: true));
                    },
                  ),
                  ItemMenuTop(
                    title: 'Phí dịch vụ',
                    isSelect: currentType == 4,
                    onTap: () {
                      changePage(4);
                      if (currentType == 4) {
                        merchantBloc.add(GetMerchantFeeEvent(
                            customerSyncId: Session.instance.connectDTO.id,
                            year: DateTime.now().year.toString(),
                            status: 0,
                            isLoadingPage: true));
                      }
                    },
                  ),
                  ItemMenuTop(
                    title: 'Hóa đơn',
                    isSelect: currentType == 5,
                    onTap: () {
                      changePage(5);
                      if (currentType == 5) {
                        merchantBloc.add(GetMerchantFeeEvent(
                            customerSyncId: Session.instance.connectDTO.id,
                            year: DateTime.now().year.toString(),
                            status: 0,
                            isLoadingPage: true));
                      }
                    },
                  ),
                  ItemMenuTop(
                    title: 'API Service Port',
                    isSelect: currentType == 6,
                    onTap: () {
                      changePage(6);
                    },
                  ),
                  ItemMenuTop(
                    title: 'Bảng giá',
                    isSelect: currentType == 7,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Expanded(
                child: [
              const InformationPopup(),
              const ListBankAccountSync(),
              const ListTransaction(),
              const SynthesisReport(),
              const ServiceFee(),
              const Bill(),
              const InfoServicePort(),
            ][currentType])
          ],
        ),
      ),
    );
  }
}

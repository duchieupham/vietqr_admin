import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/mixin/events.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/top_up_phone/bloc/top_up_phone_bloc.dart';
import 'package:vietqr_admin/feature/top_up_phone/event/top_up_phone_event.dart';
import 'package:vietqr_admin/feature/top_up_phone/provider/top_up_phone_provider.dart';
import 'package:vietqr_admin/feature/top_up_phone/state/top_up_phone_state.dart';
import 'package:vietqr_admin/feature/top_up_phone/widget/qr_top_up.dart';
import 'package:vietqr_admin/models/transaction_vnpt_dto.dart';
import 'package:vietqr_admin/models/vnpt_transaction_static.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

class TopUpPhoneScreen extends StatelessWidget {
  const TopUpPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopUpPhoneProvider>(
        create: (context) => TopUpPhoneProvider(),
        child: const _TopUpPhoneScreen());
  }
}

class _TopUpPhoneScreen extends StatefulWidget {
  const _TopUpPhoneScreen({Key? key}) : super(key: key);

  @override
  State<_TopUpPhoneScreen> createState() => _TopUpPhoneScreenState();
}

class _TopUpPhoneScreenState extends State<_TopUpPhoneScreen> {
  late TopUpPhoneBloc _bloc;
  StreamSubscription? _subscription;
  List<TransactionVNPTDTO> listTransactionVNPTDTO = [];
  VNPTTransactionStaticDTO transactionStaticDTO =
      const VNPTTransactionStaticDTO();

  int offset = 0;

  @override
  void initState() {
    _bloc = TopUpPhoneBloc()
      ..add(
          const GetTransactionListEvent(initPage: true, status: 9, offset: 0));
    _subscription = eventBus.on<RefreshTransactionVNPTPage>().listen((data) {
      _bloc.add(
          const GetTransactionListEvent(initPage: true, status: 9, offset: 0));
      Provider.of<TopUpPhoneProvider>(context, listen: false).resetFilter();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopUpPhoneBloc>(
        create: (context) => _bloc,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(child: _buildListServicePack()),
            _buildCountPage()
          ],
        ));
  }

  Widget _buildListServicePack() {
    return LayoutBuilder(builder: (context, constraints) {
      return BlocConsumer<TopUpPhoneBloc, TopUpPhoneState>(
        listener: (context, state) {
          if (state is TopUpPhoneLoadingState ||
              state is TopUpPhoneLoadingLoadMoreState) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state is TopUpPhoneGetListTransactionSuccessState) {
            if (state.isLoadMore) {
              Navigator.pop(context);
            }
            listTransactionVNPTDTO = state.result;
            if (state.initPage) {
              transactionStaticDTO = state.transactionStaticDTO;
            }
          }
          if (state is TopUpPhoneCreateQRSuccessState) {
            Navigator.pop(context);
            DialogWidget.instance.openPopupCenter(
              child: QRTopUp(
                qrCodeTDTO: state.qrCodeTDTO,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TopUpPhoneLoadingGetListState) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text('Đang tải...'),
            );
          } else {
            if (listTransactionVNPTDTO.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text('Không có dữ liệu'),
              );
            }
            return SingleChildScrollView(
                child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: constraints.maxWidth > 1440
                          ? constraints.maxWidth
                          : 1440,
                      child: Column(
                        children: [
                          _buildTitleItem(),
                          ...listTransactionVNPTDTO.map((e) {
                            int index = listTransactionVNPTDTO.indexOf(e);
                            return _buildItem(e, index + 1);
                          }).toList(),
                        ],
                      ))),
            ));
          }
        },
      );
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
              'Số tiền',
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
              'Mã đơn hàng',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 170,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Khách hàng',
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
              'SĐT người tạo',
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
              'Nạp vàp SĐT',
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
              'Phương thức TT',
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
              'Thời gian tạo',
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
              'Thời gian TT',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12, left: 20, right: 20),
          child: Text(
            'Trạng thái',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(TransactionVNPTDTO dto, int index) {
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
                  StringUtils.formatNumber(dto.amount),
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
                  dto.billNumber,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 170,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 20),
              child: SelectionArea(
                child: Text(
                  dto.fullName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
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
                  dto.phoneNo.isEmpty ? '-' : dto.phoneNo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                  dto.phoneNorc.isEmpty ? '-' : dto.phoneNorc,
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
                  dto.paymentMethod == 0 ? 'VietQR' : 'Mã VietQR',
                  textAlign: TextAlign.center,
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
            child: Text(
              dto.getStatusText(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: dto.getStatusColor(),
              ),
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
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Row(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Giao dịch nạp tiền ĐT',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          Expanded(
              child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 24,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Trạng thái',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Consumer<TopUpPhoneProvider>(
                          builder: (context, provider, child) {
                        return DropdownButton<FilterStatus>(
                          value: provider.valueStatusFilter,
                          icon: const RotatedBox(
                            quarterTurns: 5,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          ),
                          underline: const SizedBox.shrink(),
                          onChanged: (FilterStatus? value) {
                            provider.changeFilter(value!);
                            _bloc.add(GetTransactionListEvent(
                                status: value.id, offset: 0));
                          },
                          items: provider.listStatusFilter
                              .map<DropdownMenuItem<FilterStatus>>(
                                  (FilterStatus value) {
                            return DropdownMenuItem<FilterStatus>(
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
                        );
                      }),
                    ],
                  ),
                ),
                BlocConsumer<TopUpPhoneBloc, TopUpPhoneState>(
                  listener: (context, state) {
                    if (state is TopUpPhoneGetStaticSuccessState) {
                      transactionStaticDTO = state.transactionStaticDTO;
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        _buildTemplateTotal('Tổng GD',
                            transactionStaticDTO.totalTrans.toString()),
                        const SizedBox(
                          width: 12,
                        ),
                        _buildTemplateTotal(
                            'Tổng số tiền',
                            StringUtils.formatNumber(
                                transactionStaticDTO.totalAmount.toString())),
                      ],
                    );
                  },
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ButtonWidget(
              width: 100,
              text: 'Nạp tiền QR',
              sizeTitle: 12,
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              borderRadius: 5,
              function: () {
                _bloc.add(const CreateQrEvent(amount: 5000000));
              },
            ),
          ),
          _buildTemplateTotal(
              'Số dư khả dụng',
              StringUtils.formatNumber(
                  Session.instance.balanceDTO.availableBalance),
              valueColor: AppColor.BLUE_TEXT),
        ],
      ),
    );
  }

  Widget _buildTemplateTotal(String title, String value, {Color? valueColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.GREY_BG,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 11, color: valueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCountPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SizedBox(
        height: 24,
        child:
            Consumer<TopUpPhoneProvider>(builder: (context, provider, child) {
          return Row(
            children: [
              const Text('Trang: '),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: provider.listPage.map((e) {
                    return InkWell(
                      onTap: () {
                        provider.choosePage(e);
                        _bloc.add(GetTransactionListEvent(
                            status: provider.valueStatusFilter.id,
                            offset: (e + 1) * 20,
                            isLoadMore: true));
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: provider.currentPage == e
                                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                                : AppColor.TRANSPARENT),
                        child: Text(
                          '${e + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

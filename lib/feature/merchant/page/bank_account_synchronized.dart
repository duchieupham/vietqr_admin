import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/time_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/blocs/info_connect_bloc.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/events/info_connect_event.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/provider/add_bank_provider.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/states/info_connect_state.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/widget/add_bank_popup.dart';
import 'package:vietqr_admin/feature/merchant/blocs/merchant_bloc.dart';
import 'package:vietqr_admin/feature/merchant/events/merchant_event.dart';
import 'package:vietqr_admin/feature/merchant/provider/merchant_provider.dart';
import 'package:vietqr_admin/feature/merchant/states/merchant_state.dart';
import 'package:vietqr_admin/feature/merchant/widget/choose_service_pack.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../models/DTO/api_service_dto.dart';
import '../../../models/DTO/bank_account_sync_dto.dart';

class ListBankAccountSync extends StatefulWidget {
  const ListBankAccountSync({super.key});

  @override
  State<ListBankAccountSync> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListBankAccountSync> {
  List<BankAccountSync> listBankSync = [];
  ApiServiceDTO apiServiceDTO = const ApiServiceDTO();
  late MerchantBloc merchantBloc;
  late InfoConnectBloc infoBloc;
  ScrollController scrollControllerList = ScrollController();
  int offset = 0;
  bool isLoadMoreCalling = true;

  @override
  initState() {
    super.initState();
    merchantBloc = BlocProvider.of(context);
    infoBloc = InfoConnectBloc()
      ..add(GetInfoConnectEvent(
          id: Session.instance.connectDTO.id,
          platform: Session.instance.connectDTO.platform));
    init();
  }

  init() {
    merchantBloc
        .add(GetListBankSyncEvent(Session.instance.connectDTO.id, offset));
    scrollControllerList.addListener(() {
      if (isLoadMoreCalling && listBankSync.length >= 20) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          offset = offset + 20;
          merchantBloc.add(GetListBankSyncEvent(
              Session.instance.connectDTO.id, offset,
              isLoadMore: true));
          isLoadMoreCalling = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoConnectBloc>(
      create: (BuildContext context) => infoBloc,
      child: BlocConsumer<InfoConnectBloc, InfoConnectState>(
          listener: (context, stateInfo) {
        if (stateInfo is RemoveBankConnectLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (stateInfo is AddBankConnectSuccessState) {
          merchantBloc
              .add(GetListBankSyncEvent(Session.instance.connectDTO.id, 0));
          Navigator.pop(context);
        }
        if (stateInfo is RemoveBankConnectSuccessState) {
          merchantBloc
              .add(GetListBankSyncEvent(Session.instance.connectDTO.id, 0));
          Navigator.pop(context);
        }
        if (stateInfo is InfoApiServiceConnectSuccessfulState) {
          apiServiceDTO = stateInfo.dto;
        }
      }, builder: (context, stateInfo) {
        return ChangeNotifierProvider<MerchantProvider>(
          create: (context) => MerchantProvider()..init(merchantBloc),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildTitle(),
              // _buildFilter(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return BlocConsumer<MerchantBloc, MerchantState>(
                      listener: (context, state) {
                        if (state is MerchantGetSyncBankSuccessfulState) {
                          if (state.isLoadMoreLoading) {
                            listBankSync.addAll(state.list);
                            isLoadMoreCalling = true;
                          } else {
                            listBankSync = state.list;
                          }
                        }
                        if (state is ChangeFlow1SuccessfulState) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            title: const Text(
                              'Chuyển luồng 1 thành công',
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
                          merchantBloc.add(GetListBankSyncEvent(
                              Session.instance.connectDTO.id, 0));
                          // Navigator.pop(context);
                        }
                        if (state is ChangeFlow2SuccessfulState) {
                          toastification.show(
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            title: const Text(
                              'Chuyển luồng 2 thành công',
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
                          merchantBloc.add(GetListBankSyncEvent(
                              Session.instance.connectDTO.id, 0));
                          // Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is MerchantGetSyncBankLoadingState) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is MerchantGetSyncBankFailedState) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(child: Text('Không có dữ liệu')),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: ButtonWidget(
                                height: 40,
                                width: 220,
                                text: 'Thêm ngân hàng đồng bộ mới',
                                borderRadius: 5,
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                function: () {
                                  DialogWidget.instance.openPopupCenter(
                                      child: ChangeNotifierProvider<
                                          AddBankProvider>(
                                    create: (context) => AddBankProvider(),
                                    child: AddBankPopup(
                                      customerSyncId:
                                          Session.instance.connectDTO.id,
                                      accountCustomerId:
                                          apiServiceDTO.accountCustomerId,
                                      bloc: infoBloc,
                                    ),
                                  ));
                                },
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollControllerList,
                                child: ScrollConfiguration(
                                  behavior: MyCustomScrollBehavior(),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: 1240,
                                      child: SelectionArea(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildTitleItem(),
                                            ...listBankSync.map((e) {
                                              int index =
                                                  listBankSync.indexOf(e) + 1;

                                              return _buildItem(e, index);
                                            }),
                                            const SizedBox(width: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (state is MerchantGetSyncBankLoadMoreState)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()),
                              )
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItem(BankAccountSync dto, int index) {
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
            alignment: Alignment.center,
            height: 50,
            width: 130,
            child: Text(
              '${dto.bankAccount}\n${dto.bankShortName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 160,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.customerBankName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 160,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.phoneAuthenticated,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 80,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.flow == 2 ? 'TF' : 'MF',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 80,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.serviceFeeId.isNotEmpty ? 'Có' : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 160,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.serviceFeeName.isNotEmpty ? dto.serviceFeeName : '-',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 160,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.nationalId,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 260,
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      DialogWidget.instance.openMsgDialogQuestion(
                          title: 'Xoá đồng bộ',
                          msg: 'Bạn có chắc chắn muốn xoá đồng bộ?',
                          onConfirm: () {
                            Map<String, dynamic> param = {};
                            param['bankId'] = dto.bankId;
                            param['customerSyncId'] = dto.customerSyncId;
                            infoBloc.add(RemoveBankConnectEvent(param: param));
                            Navigator.pop(context);
                          });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(color: AppColor.GREY_BUTTON))),
                      child: const Text(
                        'Xóa đồng bộ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColor.RED_TEXT,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Map<String, dynamic> param = {
                        'bankTypeId': dto.bankTypeId,
                        'bankAccount': dto.bankAccount,
                        'bankCode': dto.bankCode,
                        'bankAccountName': dto.customerBankName,
                        'userId': dto.userId,
                        'bankId': dto.bankId,
                        'nationalId': dto.nationalId,
                        'phoneAuthenticated': dto.phoneAuthenticated,
                      };
                      // merchantBloc.add(ChangeFlow1Event(param: param));
                      DialogWidget.instance.openMsgDialogQuestion(
                          title: 'Chuyển luồng',
                          msg: 'Bạn có chắc chắn muốn chuyển luồng?',
                          onConfirm: () {
                            if (dto.flow == 1) {
                              merchantBloc.add(ChangeFlow2Event(param: param));
                            } else if (dto.flow == 2) {
                              merchantBloc.add(ChangeFlow1Event(param: param));
                            }
                            Navigator.pop(context);
                          });

                      // if (dto.flow == 1) {
                      //   merchantBloc.add(ChangeFlow2Event(param: param));
                      // } else if (dto.flow == 2) {
                      //   merchantBloc.add(ChangeFlow1Event(param: param));
                      // }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(color: AppColor.GREY_BUTTON))),
                      child: const Text(
                        'Chuyển luồng',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColor.BLUE_TEXT,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    child: dto.serviceFeeId.isNotEmpty
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: () {
                              DialogWidget.instance.openPopupCustomWidget(
                                  width: 1080,
                                  child: ChooseServicePackPopup(
                                    bankAccount: dto.bankAccount,
                                    bankID: dto.bankId,
                                    onSuccess: () {
                                      merchantBloc.add(GetListBankSyncEvent(
                                          Session.instance.connectDTO.id, 0));
                                    },
                                  ));
                            },
                            child: const Text(
                              'Thêm gói DV',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColor.BLUE_TEXT,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                  ),
                ),
              ],
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
          _buildItemTitle('STT',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Số TK',
              height: 50,
              width: 130,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center),
          _buildItemTitle('Tên chủ TK',
              height: 50,
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('SĐT Xác thực',
              height: 50,
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Luồng',
              height: 50,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Phí DV',
              height: 50,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Tên gói DV',
              height: 50,
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('CCCD/MST',
              height: 50,
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Action',
              height: 50,
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              textAlign: TextAlign.center),
        ],
      ),
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
      param['type'] = provider.valueFilter.id;
      if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id ||
          (provider.valueFilter.id.type != TypeFilter.BANK_NUMBER &&
              provider.valueFilter.id.type != TypeFilter.ALL &&
              provider.valueFilter.id.type != TypeFilter.CODE_SALE)) {
        param['from'] = '0';
        param['to'] = '0';
      } else {
        param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
        param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      }
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

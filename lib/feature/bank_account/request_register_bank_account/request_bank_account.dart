import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/custom_scroll.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/bloc/service_pack_bloc.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/event/service_pack_event.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/state/rq_bank_account_state.dart';

import '../../../models/DTO/account_bank_rq_dto.dart';

class RequestBankAccountScreen extends StatefulWidget {
  const RequestBankAccountScreen({super.key});

  @override
  State<RequestBankAccountScreen> createState() =>
      _RequestBankAccountScreenState();
}

class _RequestBankAccountScreenState extends State<RequestBankAccountScreen> {
  late RQBankAccountBloc _bloc;

  List<AccountBankRQDTO> rqBankLit = [];
  @override
  void initState() {
    _bloc = RQBankAccountBloc()
      ..add(const RQBankAccountListEvent(initPage: true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RQBankAccountBloc>(
      create: (context) => _bloc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return BlocConsumer<RQBankAccountBloc, RQBankAccountState>(
                listener: (context, state) {
                  if (state is RQBankAccountLoadingState) {
                    DialogWidget.instance.openLoadingDialog();
                  }
                  if (state is RQBankAccountGetListSuccessState) {
                    if (!state.initPage) {
                      Navigator.pop(context);
                    }

                    rqBankLit = state.result;
                  }
                  if (state is RemoveBankAccountSuccessState) {
                    // Navigator.pop(context);
                    _bloc.add(const RQBankAccountListEvent(initPage: false));
                  }
                  if (state is RemoveBankAccountFailsState) {
                    Navigator.pop(context);
                    DialogWidget.instance.openMsgDialog(
                        title: 'Đã có lỗi xảy ra',
                        msg: ErrorUtils.instance
                            .getErrorMessage(state.dto.message));
                  }
                },
                builder: (context, state) {
                  if (rqBankLit.isEmpty) {
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
                            width: 1360,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTitleItem(),
                                ...rqBankLit.map((e) {
                                  int index = rqBankLit.indexOf(e);

                                  return _buildItem(e, index);
                                }).toList(),
                              ],
                            ))),
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(AccountBankRQDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      height: 50,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 50,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 120,
            child: SelectableText(
              dto.bankAccount,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              dto.bankCode,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 160,
            child: SelectableText(
              dto.userBankName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 120,
            child: SelectableText(
              dto.nationalId,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              dto.phoneAuthenticated,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              dto.requestType == 0 ? 'Cá nhân' : 'Doanh nghiệp',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 150,
            child: SelectableText(
              dto.timeCreated.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 160,
            child: SelectableText(
              '${dto.firstName} ${dto.middleName} ${dto.lastName}\n${dto.phoneNo}',
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 100,
            child: SelectableText(
              dto.isSync ? 'Đã đồng bộ' : 'Chưa',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            width: 200,
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      'Cập nhật',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: AppColor.BLUE_TEXT),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _bloc.add(RemoveRQBankAccountEvent(id: dto.id));
                    },
                    child: const Text(
                      'Xóa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: AppColor.RED_TEXT),
                    ),
                  ),
                )
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
        children: [
          _buildItemTitle('STT',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Số tài khoản',
              height: 50,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Ngân hàng',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Tên chủ TK',
              height: 50,
              width: 160,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('CCCD/MST',
              height: 50,
              width: 120,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('SDT Xác thực',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Loại TK',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Thời gian tạo',
              height: 50,
              width: 150,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Người tạo',
              height: 50,
              width: 160,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Đã đồng bộ',
              height: 50,
              width: 100,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
          _buildItemTitle('Action',
              height: 50,
              width: 180,
              alignment: Alignment.center,
              textAlign: TextAlign.center),
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
              'Yêu cầu mở TK',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          InkWell(
            onTap: () {
              // DialogWidget.instance.openPopupCenter(
              //     child: CreateServicePackPopup(
              //       servicePackBloc: _bloc,
              //     ));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Thêm mới',
                style: TextStyle(fontSize: 12, color: AppColor.WHITE),
              ),
            ),
          ),
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
}

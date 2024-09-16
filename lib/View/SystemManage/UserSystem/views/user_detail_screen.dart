import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/View/InvoiceCreateManage/InvoiceCreate/item_title_widget.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/string_utils.dart';
import 'package:vietqr_admin/commons/widget/separator_widget.dart';
import 'package:vietqr_admin/models/DTO/user_detail_dto.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  final Function() callback;
  const UserDetailScreen(
      {super.key, required this.userId, required this.callback});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late SystemViewModel _model;
  final controller1 = ScrollController();
  final controller2 = ScrollController();
  final controller3 = ScrollController();
  final controller4 = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = Get.find<SystemViewModel>();
    _model.getUserDetail(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return ScopedModelDescendant<SystemViewModel>(
        builder: (context, child, model) {
      if (model.userDetailDTO == null) {
        return const SizedBox.shrink();
      }
      return Expanded(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                // height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: widget.callback,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      'Chi tiết người dùng',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 1400,
                          child: Scrollbar(
                            controller: controller1,
                            child: SingleChildScrollView(
                              controller: controller1,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _itemTitleUserInfo(),
                                    _buildItemUserInfo(
                                        model.userDetailDTO!.userInfo)
                                    // ...model.userDetailDTO!.userInfo
                                    //     .asMap()
                                    //     .map(
                                    //       (index, e) => MapEntry(
                                    //         index,
                                    //        ,
                                    //       ),
                                    //     )
                                    //     .values
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildPointVietQr(model.userDetailDTO!),
                        const SizedBox(height: 30),
                        const MySeparator(
                          color: AppColor.GREY_DADADA,
                        ),
                        const SizedBox(height: 30),
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                          child: Text(
                            'Danh sách tài khoản ngân hàng',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 1330,
                          child: Scrollbar(
                            controller: controller2,
                            child: SingleChildScrollView(
                              controller: controller2,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _itemTitleBankInfo(),
                                    ...model.userDetailDTO!.bankInfo
                                        .asMap()
                                        .map(
                                          (index, e) => MapEntry(
                                            index,
                                            _buildItemBankInfo(e, index + 1),
                                          ),
                                        )
                                        .values
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const MySeparator(
                          color: AppColor.GREY_DADADA,
                        ),
                        const SizedBox(height: 30),
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                          child: Text(
                            'Danh sách tài khoản ngân hàng được chia sẻ',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 1330,
                          child: Scrollbar(
                            controller: controller3,
                            child: SingleChildScrollView(
                              controller: controller3,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _itemTitleBankInfo(),
                                    ...model.userDetailDTO!.bankShareInfo
                                        .asMap()
                                        .map(
                                          (index, e) => MapEntry(
                                            index,
                                            _buildItemBankShareInfo(
                                                e, index + 1),
                                          ),
                                        )
                                        .values
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const MySeparator(
                          color: AppColor.GREY_DADADA,
                        ),
                        const SizedBox(height: 30),
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                          child: Text(
                            'Danh sách mạng xã hội kết nối',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 650,
                          child: Scrollbar(
                            controller: controller4,
                            child: SingleChildScrollView(
                              controller: controller4,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    _itemTitleLinkedInfo(),
                                    ...model.userDetailDTO!.socalMedia
                                        .asMap()
                                        .map(
                                          (index, e) => MapEntry(
                                            index,
                                            _buildItemLinkedInfo(e, index + 1),
                                          ),
                                        )
                                        .values
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPointVietQr(UserDetailDTO dto) {
    return SizedBox(
      width: 300,
      child: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
                ),
              ),
              child: const Row(
                children: [
                  BuildItemlTitle(
                      title: 'Số dư (VQR)',
                      textAlign: TextAlign.center,
                      width: 150,
                      height: 50,
                      alignment: Alignment.centerLeft),
                  BuildItemlTitle(
                      title: 'Điểm thưởng',
                      height: 50,
                      width: 150,
                      alignment: Alignment.centerLeft,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 150,
                    child: SelectionArea(
                      child: Text(
                        StringUtils.formatNumberWithOutVND(dto.balance),
                        // textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 150,
                    child: SelectionArea(
                      child: Text(
                        '${dto.score}',
                        // textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemUserInfo(UserInfo dto) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.phoneNo,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.fullName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.email,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.nationalId,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.nationalDate,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.oldNationalId,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.gender == 0 ? 'Nam ' : 'Nữ',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                dto.address,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemLinkedInfo(SocialMedia dto, int index) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.platform,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                '${dto.accountConnected}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                dto.chatId,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemBankShareInfo(BankInfo dto, int index) {
    // Convert UNIX timestamp to DateTime (assuming the timestamp is in seconds)
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dto.fromDate * 1000);
    // Format DateTime to a string in dd/mm/yyyy format
    String formattedDateFrom = DateFormat('dd/MM/yyyy').format(date);
    DateTime dateTo = DateTime.fromMillisecondsSinceEpoch(dto.toDate * 1000);
    // Format DateTime to a string in dd/mm/yyyy format
    String formattedDateTo = DateFormat('dd/MM/yyyy').format(dateTo);
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '${dto.bankAccount}\n${dto.bankShortName}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.bankAccountName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                !dto.status ? 'Chưa liên kết' : 'Đã liên kết',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                !dto.mmsActive ? 'VietQR Plus' : 'VietQR Pro',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.phoneAuthenticated.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.phoneAuthenticated.isNotEmpty ? dto.nationalId : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.nationalId.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.nationalId.isNotEmpty ? dto.nationalId : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.activeService != 0
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                // '${dto.activeService} tháng',
                dto.activeService != 0 ? '${dto.activeService} tháng' : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.fromDate != 0 ? formattedDateFrom : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.toDate != 0 ? formattedDateTo : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemBankInfo(BankInfo dto, int index) {
    // Convert UNIX timestamp to DateTime (assuming the timestamp is in seconds)
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dto.fromDate * 1000);
    // Format DateTime to a string in dd/mm/yyyy format
    String formattedDateFrom = DateFormat('dd/MM/yyyy').format(date);
    DateTime dateTo = DateTime.fromMillisecondsSinceEpoch(dto.toDate * 1000);
    // Format DateTime to a string in dd/mm/yyyy format
    String formattedDateTo = DateFormat('dd/MM/yyyy').format(dateTo);
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                index.toString(),
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                '${dto.bankAccount}\n${dto.bankShortName}',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 200,
            child: SelectionArea(
              child: Text(
                dto.bankAccountName,
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                !dto.isAuthenticated ? 'Chưa liên kết' : 'Đã liên kết',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                !dto.mmsActive ? 'VietQR Plus' : 'VietQR Pro',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.phoneAuthenticated.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.phoneAuthenticated.isNotEmpty
                    ? dto.phoneAuthenticated
                    : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.nationalId.isNotEmpty
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 150,
            child: SelectionArea(
              child: Text(
                dto.nationalId.isNotEmpty ? dto.nationalId : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: dto.activeService != 0
                ? Alignment.centerLeft
                : Alignment.center,
            height: 50,
            width: 120,
            child: SelectionArea(
              child: Text(
                // '${dto.activeService} tháng',
                dto.activeService != 0 ? '${dto.activeService} tháng' : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.fromDate != 0 ? formattedDateFrom : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
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
                dto.toDate != 0 ? formattedDateTo : '-',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTitleUserInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'Tài khoản VietQR',
              textAlign: TextAlign.center,
              width: 150,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Họ tên',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Email',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'CCCD',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Ngày cấp CCCD',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'CMND (cũ)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Giới tính',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Địa chỉ',
              height: 50,
              width: 300,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _itemTitleBankInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Số tài khoản',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Chủ TK',
              height: 50,
              width: 200,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Trạng thái',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Luồng dịch vụ',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'SĐT xác thực',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'CCCD/MST',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Kích hoạt DV',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Từ ngày',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đến ngày',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _itemTitleLinkedInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: const Row(
        children: [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Nền tảng',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Tài khoản kết nối',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Webhook/Chat ID',
              height: 50,
              width: 300,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

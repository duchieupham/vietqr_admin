import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';

import '../../../../ViewModel/invoice_viewModel.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widget/separator_widget.dart';
import '../../InvoiceCreate/widgets/item_title_widget.dart';

class InvoiceEditScreen extends StatefulWidget {
  const InvoiceEditScreen({super.key});

  @override
  State<InvoiceEditScreen> createState() => _InvoiceEditScreenState();
}

class _InvoiceEditScreenState extends State<InvoiceEditScreen> {
  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      bottomNavigationBar: _bottomData(),
      body: ScopedModel(
        model: _model,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWidget(),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [_bodyWidget()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomData() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColor.BLACK, width: 1),
          ),
          color: AppColor.WHITE),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Tổng tiền hàng',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
                Text(
                  '300,000 VND',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'VAT',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 10),
                Text(
                  '24,000 VND',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tổng tiền thanh toán (bao gồm VAT)',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  '324,000 VND',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLUE_TEXT,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 350,
              height: 50,
              child: InkWell(
                onTap: () {},
                child: MButtonWidget(
                  title: 'Cập nhật thông tin',
                  isEnable: true,
                  margin: EdgeInsets.zero,
                  width: 350,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 30),
                const Text(
                  'Chỉnh sửa hoá đơn',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 20,
            child: const Text(
              'Thông tin khách hàng thanh toán',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Row(
              children: [
                SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 20,
                        child: Text(
                          'Tên hoá đơn*',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white, // Changed to white background
                          border: Border.all(
                            color: Colors.grey, // Gray border
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                controller: TextEditingController(
                                    text:
                                        'Hoá đơn thu phí dịch vụ phần mềm VietQR'),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập tên hoá đơn',
                                  hintStyle: TextStyle(
                                      color: AppColor.GREY_TEXT, fontSize: 15),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        height: 20,
                        child: Text(
                          'Mô tả hoá đơn',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: InputBorder.none,
                            hintText: 'Nhập thông tin mô tả hoá đơn ở đây',
                            hintStyle: TextStyle(
                                fontSize: 15, color: AppColor.GREY_TEXT),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          Container(
            height: 30,
            width: 250,
            margin: const EdgeInsets.only(top: 30),
            child: const Text(
              'Thông tin khách hàng thanh toán',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Đối tượng*',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 400,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'Đại lý',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'SAB',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 350,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Tài khoản ngân hàng*',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'MBBank - 0541103612005',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Chủ tài khoản',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Cong Ty Co Phan Dau Tu Hang dau viet nam quoc te',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Tài khoản VietQR',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '093 186 5469',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Email',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'admin@sab.vn',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Luồng kết nối',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'VietQR Pro',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Gói dịch vụ',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            color: AppColor.GREY_DADADA),
                        child: Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'VQR5_PT',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 250,
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'VAT (%)',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white, // Changed to white background
                          border: Border.all(
                            color: Colors.grey, // Gray border
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                controller: TextEditingController(text: '8'),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập VAT',
                                  hintStyle: TextStyle(
                                      color: AppColor.GREY_TEXT, fontSize: 15),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 20,
            child: const Text(
              'Danh mục hàng hoá / dịch vụ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 1360,
            child: Column(
              children: [
                _itemTitlePaymentInfo(),
                _buildItemPaymentInfo(),
                _buildItemPaymentInfo(),
                _buildItemPaymentInfo(),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _itemTitlePaymentInfo() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1),
        ),
      ),
      child: Row(
        children: const [
          BuildItemlTitle(
              title: 'STT',
              textAlign: TextAlign.center,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft),
          BuildItemlTitle(
              title: 'Nội dung hoá đơn thanh toán',
              height: 50,
              width: 300,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn vị tính',
              height: 50,
              width: 120,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Số lượng',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Đơn giá (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'Thành tiền (VND)',
              height: 50,
              width: 150,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: '% VAT',
              height: 50,
              width: 100,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
          BuildItemlTitle(
              title: 'VAT (VND)',
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
              title: 'Thao tác',
              height: 50,
              width: 90,
              alignment: Alignment.centerLeft,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildItemPaymentInfo() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.GREY_DADADA))),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 50,
            child: SelectionArea(
              child: Text(
                '1',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: 300,
            child: SelectionArea(
              child: Text(
                'Phí giao dịch phần mềm VietQR tháng 03/2024',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                'Tháng',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '1',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '100,000',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '100,000',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '8',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '8,000',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
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
                '108,000',
                // textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 90,
            child: SelectionArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.RED_TEXT.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        size: 12,
                        color: AppColor.RED_TEXT,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 10),
      width: MediaQuery.of(context).size.width * 0.32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Danh sách hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "/",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Chỉnh sửa hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

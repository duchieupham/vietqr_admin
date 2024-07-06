import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vietqr_admin/ViewModel/invoice_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/text_field_custom.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';

class PopupEditVsoWidget extends StatefulWidget {
  final String vso;
  final String merchant;
  final String email;
  final String bankAccount;
  final String bankShortName;

  const PopupEditVsoWidget({
    super.key,
    required this.vso,
    required this.email,
    required this.merchant,
    required this.bankAccount,
    required this.bankShortName,
  });

  @override
  State<PopupEditVsoWidget> createState() => _PopupEditVsoWidgetState();
}

class _PopupEditVsoWidgetState extends State<PopupEditVsoWidget> {
  final _vsoController = TextEditingController();
  final _emailController = TextEditingController();
  final _merchantController = TextEditingController();

  late InvoiceViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.find<InvoiceViewModel>();
    init();
  }

  void init() {
    _vsoController.text = widget.vso;
    _emailController.text = widget.email;
    _merchantController.text = widget.merchant;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          width: 400,
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: AppColor.WHITE, borderRadius: BorderRadius.circular(10)),
          child: ScopedModel<InvoiceViewModel>(
            model: _model,
            child: ScopedModelDescendant<InvoiceViewModel>(
              builder: (context, child, model) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 1200,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cập nhật thông tin',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'VSO*',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            await FlutterClipboard.copy(_vsoController.text)
                                .then(
                              (value) => Fluttertoast.showToast(
                                msg: 'Đã sao chép',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColor.WHITE,
                                textColor: AppColor.BLACK,
                                fontSize: 15,
                                webBgColor: 'rgba(255, 255, 255)',
                                webPosition: 'center',
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 15,
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColor.GREY_DADADA))),
                      child: MTextFieldCustom(
                          contentPadding: EdgeInsets.zero,
                          controller: _vsoController,
                          hintText:
                              _vsoController.text.isEmpty ? 'Nhập vso' : '',
                          keyboardAction: TextInputAction.done,
                          onChange: (value) {},
                          inputType: TextInputType.text,
                          isObscureText: false),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Email*',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            await FlutterClipboard.copy(_emailController.text)
                                .then(
                              (value) => Fluttertoast.showToast(
                                msg: 'Đã sao chép',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColor.WHITE,
                                textColor: AppColor.BLACK,
                                fontSize: 15,
                                webBgColor: 'rgba(255, 255, 255)',
                                webPosition: 'center',
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 15,
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColor.GREY_DADADA))),
                      child: MTextFieldCustom(
                          contentPadding: EdgeInsets.zero,
                          controller: _emailController,
                          hintText:
                              _emailController.text.isEmpty ? 'Nhập email' : '',
                          keyboardAction: TextInputAction.done,
                          onChange: (value) {},
                          inputType: TextInputType.text,
                          isObscureText: false),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Đại lý*',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            await FlutterClipboard.copy(
                                    _merchantController.text)
                                .then(
                              (value) => Fluttertoast.showToast(
                                msg: 'Đã sao chép',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColor.WHITE,
                                textColor: AppColor.BLACK,
                                fontSize: 15,
                                webBgColor: 'rgba(255, 255, 255)',
                                webPosition: 'center',
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 15,
                            color: AppColor.BLUE_TEXT,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColor.GREY_DADADA))),
                      child: MTextFieldCustom(
                          contentPadding: EdgeInsets.zero,
                          controller: _merchantController,
                          hintText: _merchantController.text.isEmpty
                              ? 'Nhập đại lý'
                              : '',
                          keyboardAction: TextInputAction.done,
                          onChange: (value) {},
                          inputType: TextInputType.text,
                          isObscureText: false),
                    ),
                    const SizedBox(height: 10),
                    MButtonWidget(
                      colorEnableBgr: AppColor.BLUE_TEXT,
                      isEnable: true,
                      title: 'Xác nhận',
                      colorEnableText: AppColor.WHITE,
                      width: double.infinity,
                      height: 50,
                      onTap: () async {
                        await _model
                            .updateInfo(context,
                                bankAccount: widget.bankAccount,
                                bankShortName: widget.bankShortName,
                                email: _emailController.text,
                                vso: _vsoController.text,
                                midName: _merchantController.text)
                            .then(
                          (value) {
                            if (value == true) {
                              Navigator.of(context).pop();
                            } else {}
                          },
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

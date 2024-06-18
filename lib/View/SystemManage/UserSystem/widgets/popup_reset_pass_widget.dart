import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vietqr_admin/ViewModel/root_viewModel.dart';
import 'package:vietqr_admin/ViewModel/system_viewModel.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/encrypt_utils.dart';
import 'package:vietqr_admin/commons/widget/m_button_widget.dart';
import 'package:vietqr_admin/commons/widget/pin_widget.dart';
import 'package:vietqr_admin/models/DTO/user_system_dto.dart';

class PopupResetPassWidget extends StatefulWidget {
  final UserSystemDTO dto;
  const PopupResetPassWidget({super.key, required this.dto});

  @override
  State<PopupResetPassWidget> createState() => _PopupResetPassWidgetState();
}

class _PopupResetPassWidgetState extends State<PopupResetPassWidget> {
  final FocusNode focusNode = FocusNode();

  bool isEnterPass = false;
  bool isError = false;

  String pass = '';

  @override
  void initState() {
    super.initState();
    Get.find<RootViewModel>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(20),
          ),
          width: 450,
          height: 450,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đặt lại mật khẩu cho người dùng\ncho tài khoản ${widget.dto.phoneNo}\n${widget.dto.fullName}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: isEnterPass
                              ? isError
                                  ? AppColor.RED_TEXT
                                  : AppColor.BLUE_TEXT
                              : AppColor.GREY_DADADA),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: PinWidget(
                        width: double.infinity,
                        pinSize: 15,
                        pinLength: 6,
                        focusNode: focusNode,
                        onDone: (i) {
                          if (i.isEmpty) {
                            isEnterPass = false;
                          } else {
                            if (i.length >= 6) {
                              isEnterPass = true;
                            }
                          }
                          pass = i;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  MButtonWidget(
                      isEnable: isEnterPass,
                      onTap: isEnterPass
                          ? () async {
                              await Get.find<SystemViewModel>()
                                  .changePass(
                                widget.dto.phoneNo,
                                EncryptUtils.instance.encrypted(
                                  widget.dto.phoneNo,
                                  pass,
                                ),
                              )
                                  .then(
                                (value) {
                                  if (value == true) {
                                    Navigator.of(context).pop();
                                  } else {
                                    isError = true;
                                    setState(() {});
                                  }
                                },
                              );
                            }
                          : null,
                      width: double.infinity,
                      height: 50,
                      colorDisableBgr: AppColor.GREY_DADADA,
                      colorEnableBgr: AppColor.BLUE_TEXT,
                      title: 'Xác nhận')
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

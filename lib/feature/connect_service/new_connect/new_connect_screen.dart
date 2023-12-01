import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/type_menu_home.dart';
import 'package:vietqr_admin/commons/constants/utils/error_utils.dart';
import 'package:vietqr_admin/commons/widget/border_layout.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/textfield_widget.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';

import 'bloc/new_connect_bloc.dart';
import 'event/new_connect_event.dart';
import 'provider/new_connect_provider.dart';
import 'state/new_connect_state.dart';

class NewConnectScreen extends StatelessWidget {
  const NewConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<NewConnectBloc>(
      create: (BuildContext context) => NewConnectBloc(),
      child: BlocConsumer<NewConnectBloc, NewConnectState>(
          listener: (context, state) {
        if (state is AddCustomerLoadingState) {
          DialogWidget.instance.openLoadingDialog();
        }
        if (state is AddCustomerSuccessfulState) {
          Navigator.pop(context);
          Provider.of<MenuProvider>(context, listen: false)
              .selectSubMenu(SubMenuType.LIST_CONNECT);
        }
        if (state is AddCustomerFailedState) {
          Navigator.pop(context);

          DialogWidget.instance.openMsgDialog(
              title: 'Đã có lỗi xảy ra',
              msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
        }
      }, builder: (context, state) {
        return SizedBox(
          width: width,
          child: ChangeNotifierProvider<NewConnectProvider>(
            create: (context) => NewConnectProvider(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin khách hàng cung cấp',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(child: _buildAddressConnect())
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin hệ thống khởi tạo',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(child: _buildBasicAuthen()),
                        Consumer<NewConnectProvider>(
                            builder: (context, provider, child) {
                          return ButtonWidget(
                            height: 40,
                            text: 'Tạo kết nối',
                            borderRadius: 5,
                            sizeTitle: 12,
                            textColor: AppColor.WHITE,
                            bgColor: AppColor.BLUE_TEXT,
                            function: () {
                              provider.checkValidate();

                              if (provider.customerName.isEmpty) {
                                DialogWidget.instance.openMsgDialog(
                                    title: 'Thông tin không hợp lệ',
                                    msg: 'Vui lòng lấy thông tin kết nối');
                              } else if (provider.isValidate()) {
                                Map<String, dynamic> param = {};
                                param['merchantName'] = provider.merchant;
                                param['url'] = provider.urlConnect;
                                param['ip'] = provider.ipConnect;
                                param['port'] = provider.portConnect;
                                param['suffixUrl'] = provider.suffixConnect;
                                param['address'] = provider.address;
                                param['bankAccount'] = provider.bankAccount;
                                param['userBankName'] = provider.userBankName;
                                param['customerUsername'] = provider.username;
                                param['customerPassword'] = provider.password;
                                param['systemUsername'] = provider.customerName;
                                BlocProvider.of<NewConnectBloc>(context)
                                    .add(AddCustomerSyncEvent(param: param));
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAddressConnect() {
    return BlocProvider<NewConnectBloc>(
      create: (BuildContext context) => NewConnectBloc(),
      child: Consumer<NewConnectProvider>(builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Text(
              'Thông tin đại lý',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: provider.errorMerchant,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText: 'Merchant Name\u002A (VIẾT HOA, không khoảng trắng)',
                // controller: TextEditingController(),
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                inputFormatter: [
                  UpperCaseTextFormatter(),
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateMerchant(value as String);
                },
              ),
            ),
            if (provider.errorMerchant) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Text(
                  'Địa chỉ kết nối',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(
                  width: 20,
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Radio<int>(
                      value: 0,
                      activeColor: AppColor.BLUE_TEXT,
                      groupValue: provider.valueTypeConnect,
                      onChanged: (value) {
                        provider.changeTypeConnect(value ?? 0);
                      }),
                ),
                const Text(
                  'URL',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(
                  width: 28,
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Radio<int>(
                      value: 1,
                      activeColor: AppColor.BLUE_TEXT,
                      groupValue: provider.valueTypeConnect,
                      onChanged: (value) {
                        provider.changeTypeConnect(value ?? 0);
                      }),
                ),
                const Text(
                  'IP + PORT',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (provider.valueTypeConnect == 0)
              BorderLayout(
                height: 50,
                isError: false,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  disableBorder: true,
                  hintText: 'URL kết nối',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onTapOutside: (value) {},
                  onChange: (value) {
                    provider.updateUrlConnect(value as String);
                  },
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: BorderLayout(
                      height: 50,
                      isError: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        isObscureText: false,
                        maxLines: 1,
                        disableBorder: true,
                        hintText: 'IP',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onTapOutside: (value) {},
                        onChange: (value) {
                          provider.updateIpConnect(value as String);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: BorderLayout(
                      height: 50,
                      isError: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        isObscureText: false,
                        maxLines: 1,
                        disableBorder: true,
                        hintText: 'PORT',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onTapOutside: (value) {},
                        onChange: (value) {
                          provider.updatePortConnect(value as String);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: false,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText: 'URL Path',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateSuffixConnect(value as String);
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: provider.errorAddress,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText:
                    'Địa chỉ KH\u002A (Không dấu, chi tiết để tránh trùng lặp)',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateAddress(value as String);
                },
              ),
            ),
            if (provider.errorAddress) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BorderLayout(
                        height: 50,
                        isError: provider.errorBankAccount,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFieldWidget(
                          isObscureText: false,
                          maxLines: 1,
                          disableBorder: true,
                          hintText: 'Số Tài khoản MB Bank\u002A',
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onTapOutside: (value) {},
                          onChange: (value) {
                            provider.updateBankAccount(value as String);
                          },
                        ),
                      ),
                      if (provider.errorBankAccount) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Số tài khoản không đúng định dạng',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.RED_TEXT),
                          ),
                        )
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BorderLayout(
                        height: 50,
                        isError: provider.errorUserBankName,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFieldWidget(
                          isObscureText: false,
                          maxLines: 1,
                          controller: provider.accountName,
                          disableBorder: true,
                          hintText: 'Tên chủ TK\u002A (Không dấu)',
                          inputType: TextInputType.text,
                          keyboardAction: TextInputAction.next,
                          onTapOutside: (value) {},
                          onChange: (value) {
                            provider.updateUserBankName(value as String);
                          },
                        ),
                      ),
                      if (provider.errorUserBankName) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Không được để trống',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.RED_TEXT),
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Basic Authentication',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: provider.errorUsername,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText: 'Username\u002A',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateUsername(value as String);
                },
              ),
            ),
            if (provider.errorUsername) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: provider.errorPassword,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText: 'Password\u002A',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updatePassword(value as String);
                },
              ),
            ),
            if (provider.errorPassword) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: UnconstrainedBox(
                child: ButtonWidget(
                  height: 32,
                  width: 150,
                  text: 'Test Get Token của KH',
                  borderRadius: 5,
                  sizeTitle: 12,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () {
                    if (provider.ipConnect.isEmpty &&
                        provider.urlConnect.isEmpty &&
                        provider.portConnect.isEmpty) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Thông tin không hợp lệ',
                          msg: 'Vui lòng nhập thông tin url hoặc ip và port');
                    } else {
                      if (provider.username.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không hợp lệ',
                            msg: 'Vui lòng nhập thông tin username');
                      } else if (provider.password.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không hợp lệ',
                            msg: 'Vui lòng nhập thông tin password');
                      } else {
                        Map<String, dynamic> param = {};
                        param['url'] = provider.getUrl();
                        param['username'] = provider.username;
                        param['password'] = provider.password;
                        BlocProvider.of<NewConnectBloc>(context)
                            .add(GetTokenEvent(param: param));
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<NewConnectBloc, NewConnectState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is NewConnectGetTokenLoadingState) {
                  return const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetTokenSuccessfulState) {
                  return InkWell(
                    onTap: () async {
                      await FlutterClipboard.copy(state.dto.message).then(
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
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thành công!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.BLUE_TEXT),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.dto.message,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.BLUE_TEXT),
                            )
                          ],
                        )),
                  );
                }
                if (state is GetTokenFailedState) {
                  return InkWell(
                    onTap: () async {
                      await FlutterClipboard.copy(state.dto.message).then(
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
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.RED_TEXT.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thất bại!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.RED_TEXT),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              errorText(state.dto.message),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.RED_TEXT),
                            )
                          ],
                        )),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBasicAuthen() {
    return BlocProvider<NewConnectBloc>(
      create: (BuildContext context) => NewConnectBloc(),
      child: Consumer<NewConnectProvider>(builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Text(
              'Basic Authentication',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: UnconstrainedBox(
                child: ButtonWidget(
                  height: 32,
                  width: 150,
                  text: 'Lấy thông tin kết nối',
                  borderRadius: 5,
                  sizeTitle: 12,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () {
                    if (provider.merchant.isEmpty) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Thông tin không hợp lệ',
                          msg: 'Vui lòng nhập tên Merchant');
                    } else {
                      Map<String, dynamic> param = {};
                      param['merchantName'] = provider.merchant;
                      BlocProvider.of<NewConnectBloc>(context)
                          .add(GetPassSystemEvent(param: param));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<NewConnectBloc, NewConnectState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is NewConnectGetPassLoadingState) {
                  return const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetPassSystemSuccessfulState) {
                  provider.updateCustomerName(state.dto.username);
                  return Column(
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.GREY_BUTTON),
                          child: Row(
                            children: [
                              const SelectableText(
                                'Username: ',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              Expanded(
                                child: Text(
                                  state.dto.username,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                          state.dto.username)
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
                                child: const Text(
                                  'Sao chép',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.GREY_BUTTON),
                          child: Row(
                            children: [
                              const SelectableText(
                                'Mật khẩu: ',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              Expanded(
                                child: Text(
                                  state.dto.password,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                          state.dto.password)
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
                                child: const Text(
                                  'Sao chép',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              )
                            ],
                          ))
                    ],
                  );
                }
                if (state is GetPassSystemFailedState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.GREY_BUTTON),
                          child: Row(
                            children: const [
                              Text(
                                'Mật khẩu: ',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              SizedBox()
                            ],
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'Đã có lỗi xảy ra',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                      )
                    ],
                  );
                }
                return Column(
                  children: [
                    Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.GREY_BUTTON),
                        child: Row(
                          children: const [
                            Text(
                              'Username: ',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                            Spacer()
                          ],
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.GREY_BUTTON),
                        child: Row(
                          children: const [
                            Text(
                              'Mật khẩu: ',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                            Spacer()
                          ],
                        )),
                  ],
                );
              },
            ),
          ],
        );
      }),
    );
  }

  String errorText(String message) {
    if (message.contains('E82')) {
      return 'Không tìm thấy field "access_token" trong Response Body thuộc API get Token của khách hàng.';
    } else {
      return 'Lỗi không xác định $message';
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
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
import 'package:vietqr_admin/feature/new_connect/bloc/new_connect_bloc.dart';
import 'package:vietqr_admin/feature/new_connect/event/new_connect_event.dart';
import 'package:vietqr_admin/feature/new_connect/provider/new_connect_provider.dart';
import 'package:vietqr_admin/feature/new_connect/state/new_connect_state.dart';
import 'package:vietqr_admin/service/shared_references/provider/env_provider.dart';

import '../../commons/constants/env/env_config.dart';

class NewConnectScreen extends StatelessWidget {
  const NewConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
          height: height - 60,
          width: width,
          child: Column(
            children: [
              ChangeNotifierProvider(
                create: (context) => EnvProvider(),
                child:
                    Consumer<EnvProvider>(builder: (context, provider, child) {
                  return Container(
                    color: DefaultTheme.BLUE_TEXT.withOpacity(0.2),
                    height: 68,
                    width: width,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text('Môi trường'),
                        const SizedBox(
                          width: 24,
                        ),
                        InkWell(
                          onTap: () {
                            EnvConfig.instance.updateEnv(EnvType.DEV);
                            // BlocProvider.of<EnvProvider>(context)
                            //     .add(ListConnectGetListEvent());
                            provider.updateENV(0);
                          },
                          child: Container(
                            height: 35,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: provider.environment == 0
                                  ? DefaultTheme.BLUE_TEXT.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Test',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: provider.environment == 0
                                      ? DefaultTheme.BLUE_TEXT
                                      : DefaultTheme.BLACK),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            EnvConfig.instance.updateEnv(EnvType.GOLIVE);
                            // BlocProvider.of<ListConnectBloc>(context)
                            //     .add(ListConnectGetListEvent());
                            provider.updateENV(1);
                          },
                          child: Container(
                            height: 35,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: provider.environment == 1
                                  ? DefaultTheme.BLUE_TEXT.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'GoLive',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: provider.environment == 1
                                      ? DefaultTheme.BLUE_TEXT
                                      : DefaultTheme.BLACK),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Expanded(
                child: ChangeNotifierProvider<NewConnectProvider>(
                  create: (context) => NewConnectProvider(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
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
                                  textColor: DefaultTheme.WHITE,
                                  bgColor: DefaultTheme.BLUE_TEXT,
                                  function: () {
                                    provider.checkValidate();
                                    if (provider.isValidate()) {
                                      Map<String, dynamic> param = {};
                                      param['merchantName'] = provider.merchant;
                                      param['url'] = provider.urlConnect;
                                      param['ip'] = provider.ipConnect;
                                      param['port'] = provider.portConnect;
                                      param['suffixUrl'] =
                                          provider.suffixConnect;
                                      param['address'] = provider.address;
                                      param['bankAccount'] =
                                          provider.bankAccount;
                                      param['userBankName'] =
                                          provider.userBankName;
                                      param['customerUsername'] =
                                          provider.username;
                                      param['customerPassword'] =
                                          provider.password;
                                      param['systemUsername'] =
                                          provider.customerName;
                                      BlocProvider.of<NewConnectBloc>(context)
                                          .add(AddCustomerSyncEvent(
                                              param: param));
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
              ),
            ],
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
              'Địa chỉ kết nối(Nhập URL hoặc nhập IP + PORT)',
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
                  style: TextStyle(fontSize: 12, color: DefaultTheme.RED_TEXT),
                ),
              )
            ],
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
                hintText: 'URL kết nối',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateUrlConnect(value as String);
                },
              ),
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
                hintText: 'IP',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateIpConnect(value as String);
                },
              ),
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
                hintText: 'PORT',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updatePortConnect(value as String);
                },
              ),
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
                hintText: 'Suffix URL',
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
                  style: TextStyle(fontSize: 12, color: DefaultTheme.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Row(
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
                            'Không được để trống',
                            style: TextStyle(
                                fontSize: 12, color: DefaultTheme.RED_TEXT),
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
                                fontSize: 12, color: DefaultTheme.RED_TEXT),
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
                  style: TextStyle(fontSize: 12, color: DefaultTheme.RED_TEXT),
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
                  style: TextStyle(fontSize: 12, color: DefaultTheme.RED_TEXT),
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
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.BLUE_TEXT,
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
                          backgroundColor: DefaultTheme.WHITE,
                          textColor: DefaultTheme.BLACK,
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
                            color: DefaultTheme.BLUE_TEXT.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thành công!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: DefaultTheme.BLUE_TEXT),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.dto.message,
                              style: const TextStyle(
                                  fontSize: 12, color: DefaultTheme.BLUE_TEXT),
                            )
                          ],
                        )),
                  );
                }
                if (state is GetTokenFailedState) {
                  return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: DefaultTheme.RED_TEXT.withOpacity(0.3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thất bại!',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: DefaultTheme.RED_TEXT),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            errorText(state.dto.message),
                            style: const TextStyle(
                                fontSize: 12, color: DefaultTheme.RED_TEXT),
                          )
                        ],
                      ));
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
            BorderLayout(
              height: 50,
              isError: provider.errorCustomerName,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                hintText:
                    'System username\u002A (đặt theo format customer-tenkhachang-user23XX)',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateCustomerName(value as String);
                },
              ),
            ),
            if (provider.errorCustomerName) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: DefaultTheme.RED_TEXT),
                ),
              )
            ],
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
                  return Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: DefaultTheme.GREY_BUTTON),
                      child: Row(
                        children: [
                          const SelectableText(
                            'Mật khẩu: ',
                            style: TextStyle(
                                fontSize: 12, color: DefaultTheme.GREY_TEXT),
                          ),
                          Expanded(
                            child: Text(
                              state.dto.message,
                              style: const TextStyle(
                                  fontSize: 12, color: DefaultTheme.GREY_TEXT),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await FlutterClipboard.copy(state.dto.message)
                                  .then(
                                (value) => Fluttertoast.showToast(
                                  msg: 'Đã sao chép',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: DefaultTheme.WHITE,
                                  textColor: DefaultTheme.BLACK,
                                  fontSize: 15,
                                  webBgColor: 'rgba(255, 255, 255)',
                                  webPosition: 'center',
                                ),
                              );
                            },
                            child: const Text(
                              'Sao chép',
                              style: TextStyle(
                                  fontSize: 12, color: DefaultTheme.BLUE_TEXT),
                            ),
                          )
                        ],
                      ));
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
                              color: DefaultTheme.GREY_BUTTON),
                          child: Row(
                            children: const [
                              Text(
                                'Mật khẩu: ',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: DefaultTheme.GREY_TEXT),
                              ),
                              SizedBox()
                            ],
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        state.dto.message,
                        style: const TextStyle(
                            fontSize: 12, color: DefaultTheme.RED_TEXT),
                      )
                    ],
                  );
                }
                return Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: DefaultTheme.GREY_BUTTON),
                    child: Row(
                      children: const [
                        Text(
                          'Mật khẩu: ',
                          style: TextStyle(
                              fontSize: 12, color: DefaultTheme.GREY_TEXT),
                        ),
                        Spacer()
                      ],
                    ));
              },
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
                  text: 'Lấy mật khẩu',
                  borderRadius: 5,
                  sizeTitle: 12,
                  textColor: DefaultTheme.WHITE,
                  bgColor: DefaultTheme.BLUE_TEXT,
                  function: () {
                    if (provider.customerName.isEmpty) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Thông tin không hợp lệ',
                          msg: 'Vui lòng nhập thông tin Username');
                    } else {
                      BlocProvider.of<NewConnectBloc>(context).add(
                          GetPassSystemEvent(userName: provider.customerName));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
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

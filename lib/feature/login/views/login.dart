import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vietqr_admin/commons/constants/configurations/app_image.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/encrypt_utils.dart';
import 'package:vietqr_admin/commons/widget/button_widget.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/textfield_widget.dart';
import 'package:vietqr_admin/feature/login/blocs/login_bloc.dart';
import 'package:vietqr_admin/feature/login/states/login_state.dart';

import '../events/login_event.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final LoginBloc _loginBloc = LoginBloc();
  bool errUserName = false;
  bool errPass = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: DefaultTheme.GREY_BG,
      body: BlocProvider<LoginBloc>(
        create: (BuildContext context) => _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: ((context, state) {
            if (state is LoginLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is LoginSuccessfulState) {
              // _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
              //pop loading dialog
              Navigator.of(context).pop();

              context.push('/dashboard');
            }
            if (state is LoginFailedState) {
              FocusManager.instance.primaryFocus?.unfocus();
              //pop loading dialog
              Navigator.of(context).pop();

              //show msg dialog
              DialogWidget.instance.openMsgDialog(
                title: 'Đăng nhập không thành công',
                msg: 'Tài khoản đăng nhập hoặc mật khẩu không hợp lệ',
              );
            }
          }),
          child: _buildWidget1(
            width: width,
          ),
        ),
      ),
    );
  }

  Widget _buildWidget1({required double width}) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 550,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.icVietQrAdmin,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
              width: width,
              isObscureText: false,
              autoFocus: true,
              hintText: 'Tên đăng nhâp',
              controller: userNameController,
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              textStyle: const TextStyle(fontSize: 12),
              onChange: (value) {
                if (errUserName) {
                  setState(() {
                    errUserName = false;
                  });
                }
              },
            ),
            if (errUserName)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 12),
                ),
              ),
            const SizedBox(
              height: 4,
            ),
            TextFieldWidget(
              width: width,
              isObscureText: false,
              autoFocus: true,
              hintText: 'Mật khẩu',
              textStyle: const TextStyle(fontSize: 12),
              controller: passController,
              inputType: TextInputType.text,
              keyboardAction: TextInputAction.next,
              onChange: (value) {
                if (errPass) {
                  setState(() {
                    errPass = false;
                  });
                }
              },
            ),
            if (errPass)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(color: DefaultTheme.RED_TEXT, fontSize: 12),
                ),
              ),
            const Padding(padding: EdgeInsets.only(top: 80)),
            ButtonWidget(
              width: width,
              height: 40,
              text: 'Đăng nhập',
              borderRadius: 5,
              textColor: DefaultTheme.WHITE,
              bgColor: DefaultTheme.BLUE_TEXT,
              function: () {
                if (userNameController.text.isEmpty) {
                  setState(() {
                    errUserName = true;
                  });
                } else if (passController.text.isEmpty) {
                  setState(() {
                    errPass = true;
                  });
                } else {
                  Map<String, dynamic> param = {};
                  param['username'] = userNameController.text;
                  param['password'] = EncryptUtils.instance.encrypted(
                    userNameController.text,
                    passController.text,
                  );
                  _loginBloc.add(LoginEventLogin(param: param));
                }
              },
            ),
            const SizedBox(
              height: 240,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/utils/platform_utils.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/commons/widget/header.dart';
import 'package:vietqr_admin/commons/widget/web_mobile_blank_widget.dart';
import 'package:vietqr_admin/feature/dashboard/bloc/token_bloc.dart';
import 'package:vietqr_admin/feature/dashboard/event/token_event.dart';
import 'package:vietqr_admin/feature/dashboard/state/token_state.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

class FrameViewWidget extends StatefulWidget {
  final Widget title;
  final Widget menu;
  final Widget child;
  const FrameViewWidget({
    super.key,
    required this.title,
    required this.menu,
    required this.child,
  });

  @override
  State<FrameViewWidget> createState() => _FrameViewWidgetState();
}

class _FrameViewWidgetState extends State<FrameViewWidget> {
  late TokenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TokenBloc()..add(const TokenEventCheckValid());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider<TokenBloc>(
      create: (context) => _bloc,
      child: BlocListener<TokenBloc, TokenState>(
        listener: (context, state) {
          if (state.typeToken == TokenType.Internet ||
              state.typeToken == TokenType.InValid ||
              state.typeToken == TokenType.Expired ||
              state.typeToken == TokenType.MainSystem) {
            DialogWidget.instance.openMsgDialog(
                title: 'Phiên đăng nhập hết hạn',
                msg: 'Vui lòng đăng nhập lại ứng dụng',
                function: () async {
                  Navigator.pop(context);
                  UserInformationHelper.instance.removeAdmin();
                  context.go('/login');
                });
          } else if (state.typeToken == TokenType.Logout) {
            context.go('/login');
          }
        },
        child: Material(
          child: Container(
            width: width,
            height: height - 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.WHITE,
                  AppColor.BLUE_LIGHT,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: (PlatformUtils.instance.resizeWhen(width, 650))
                ? Column(
                    children: [
                      const Header(),
                      Expanded(
                        child: Row(
                          children: [
                            widget.menu,
                            Expanded(child: widget.child),
                          ],
                        ),
                      ),
                      // const FooterWeb(),
                    ],
                  )
                : const WebMobileBlankWidget(),
          ),
        ),
      ),
    );
  }
}

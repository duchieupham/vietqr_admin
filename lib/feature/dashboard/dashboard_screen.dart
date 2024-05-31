import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_admin/View/TransStatistics/SystemTransStatistics/system_transaction_screen.dart';
import 'package:vietqr_admin/View/TransManage/UserRecharge/user_recharge_screen.dart';
import 'package:vietqr_admin/commons/constants/enum/check_type.dart';
import 'package:vietqr_admin/commons/widget/dialog_widget.dart';
import 'package:vietqr_admin/feature/bank_account/request_register_bank_account/request_bank_account.dart';
import 'package:vietqr_admin/feature/config/config_screen.dart';
import 'package:vietqr_admin/feature/dashboard/bloc/token_bloc.dart';
import 'package:vietqr_admin/feature/dashboard/event/token_event.dart';
import 'package:vietqr_admin/feature/dashboard/provider/menu_provider.dart';
import 'package:vietqr_admin/feature/list_merchant/list_connect/list_connect_screen.dart';
import 'package:vietqr_admin/feature/log/log_screen.dart';
import 'package:vietqr_admin/View/SettingManage/ServicePack/service_pack_screen.dart';
import 'package:vietqr_admin/feature/surplus/epay_screen.dart';
import 'package:vietqr_admin/View/TransManage/SysTrans/transaction_screen.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import '../../View/FeeManage/AnnualFeeAfter/annual_fee_after_screen.dart';
import '../../View/SettingManage/SettingEnv/environment_setting_screen.dart';
import '../../View/FeeManage/ServiceFee/service_fee_screen.dart';
import '../../View/TransStatistics/MerchantTrans/merchant_transaction_screen.dart';
import 'state/token_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashBroadScreenState();
}

class _DashBroadScreenState extends State<DashboardScreen> {
  List<Widget> pages = [];
  List<Widget> menus = [];
  late TokenBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = TokenBloc()..add(const TokenEventCheckValid());
    // menus = [
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    //   const SizedBox.shrink(),
    // ];

    pages = [
      const EPayScreen(),
      const ListConnectScreen(),
      // const IntegrationConnectivityScreen(),
      const ServicePackScreen(),
      const EnvironmentSettingScreen(),
      const ServiceFeeScreen(),
      const AnnualFeeAfterScreen(),
      const UserRechargeScreen(),
      const SysTransactionScreen(),
      const MerchantTransactionScreen(),
      const SystemTransStatisticsScreen(),
      const LogScreen(),
      const ConfigScreen(),
      const RequestBankAccountScreen(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<TokenBloc>(
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
          child: ChangeNotifierProvider(
            create: (context) => MenuProvider(),
            child: Consumer<MenuProvider>(
              builder: (context, provider, child) {
                return Container();
                // return DashboardFrame(
                //   page: pages[provider.initMenuPage],
                //   menu: const MenuLeft(),
                // );
              },
            ),
          ),
        ),
      ),
    );
  }
}

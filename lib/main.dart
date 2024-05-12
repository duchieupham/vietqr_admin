import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/setup.dart';
import 'package:vietqr_admin/feature/login/views/login.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

import 'View/FeeManage/fee_manage_screen.dart';
import 'View/InvoiceManage/invoice_manage_screen.dart';
import 'View/MerchantManage/merchant_manage_screen.dart';
import 'View/SettingManage/setting_env_screen.dart';
import 'View/TransManage/trans_manage_screen.dart';
import 'View/TransStatistics/trans_statistics_screen.dart';
import 'View/ValueAddedService/vas_screen.dart';
import 'feature/dashboard/provider/menu_provider.dart';

//Share Preferences
late SharedPreferences sharedPrefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.setString('TOKEN_FREE', '');
  setUrlStrategy(PathUrlStrategy());
  Session.load;
  createRouteBindings();
  // LOG.verbose('Config Environment: ${EnvConfig.getEnv()}');
  runApp(const VietQRAdmin());
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

CustomTransitionPage<Widget> buildPageWithoutAnimation({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<Widget>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child);
}

// final isLoggedIn = UserInformationHelper.instance.getUserId().trim().isNotEmpty;
// final String authenticatedRedirect = (isLoggedIn) ? '/home' : '/login';
String get userId => UserInformationHelper.instance.getAdminId().trim();

final GoRouter _router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return userId.isNotEmpty ? '/vnpt-epay' : '/login';
      },
    ),
    GoRoute(
      path: '/login',
      redirect: (context, state) => userId.isNotEmpty ? '/vnpt-epay' : '/login',
      builder: (BuildContext context, GoRouterState state) => const Login(),
    ),
    GoRoute(
      path: '/vnpt-epay',
      redirect: (context, state) => userId.isNotEmpty ? '/vnpt-epay' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const VasScreen(type: VasType.VNPT_EPAY),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const VasScreen(type: VasType.VNPT_EPAY));
      },
    ),
    GoRoute(
      path: '/merchant-list',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/merchant-list' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const MerchantManageScreen(type: MerchantType.MERCHANT_LIST),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child:
                const MerchantManageScreen(type: MerchantType.MERCHANT_LIST));
      },
    ),
    GoRoute(
      path: '/api-service',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/api-service' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const MerchantManageScreen(type: MerchantType.API_SERVICE),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const MerchantManageScreen(type: MerchantType.API_SERVICE));
      },
    ),
    GoRoute(
      path: '/test-callback',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/test-callback' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const MerchantManageScreen(type: MerchantType.TEST_CALLBACK),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child:
                const MerchantManageScreen(type: MerchantType.TEST_CALLBACK));
      },
    ),
    GoRoute(
      path: '/sys-trans',
      redirect: (context, state) => userId.isNotEmpty ? '/sys-trans' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const TransManageScreen(type: Transtype.SYS_TRANS),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const TransManageScreen(type: Transtype.SYS_TRANS));
      },
    ),
    GoRoute(
      path: '/user-recharge',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/user-recharge' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const TransManageScreen(type: Transtype.RECHARGE_TRANS),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const TransManageScreen(type: Transtype.RECHARGE_TRANS));
      },
    ),
    GoRoute(
      path: '/sys-trans-statistics',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/sys-trans-statistics' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const TransStatisticsScreen(
              type: TransStatistics.SYS_TRANS_STATISTICS),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const TransStatisticsScreen(
                type: TransStatistics.SYS_TRANS_STATISTICS));
      },
    ),
    GoRoute(
      path: '/merchant-trans',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/merchant-trans' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const TransStatisticsScreen(
              type: TransStatistics.MERCHANT_TRANS_STATISTICS),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const TransStatisticsScreen(
                type: TransStatistics.MERCHANT_TRANS_STATISTICS));
      },
    ),
    GoRoute(
      path: '/trans-fee',
      redirect: (context, state) => userId.isNotEmpty ? '/trans-fee' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const FeeManageScreen(type: TransFee.FEE_TRANS),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const FeeManageScreen(type: TransFee.FEE_TRANS));
      },
    ),
    GoRoute(
      path: '/annual-fee',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/annual-fee' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const FeeManageScreen(type: TransFee.ANNUAL_FEE),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const FeeManageScreen(type: TransFee.ANNUAL_FEE));
      },
    ),
    GoRoute(
      path: '/invoice-list',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/invoice-list' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const InvoiceManageScreen(type: Invoice.LIST),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const InvoiceManageScreen(type: Invoice.LIST));
      },
    ),
    GoRoute(
      path: '/create-invoice',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/create-invoice' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const InvoiceManageScreen(type: Invoice.CREATE),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const InvoiceManageScreen(type: Invoice.CREATE));
      },
    ),
    GoRoute(
      path: '/setting-fee',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/setting-fee' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingEnvScreen(type: SettingEnv.FEE),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const SettingEnvScreen(type: SettingEnv.FEE));
      },
    ),
    GoRoute(
      path: '/setting-env',
      redirect: (context, state) =>
          userId.isNotEmpty ? '/setting-env' : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingEnvScreen(type: SettingEnv.ENV),
      pageBuilder: (context, state) {
        return buildPageWithoutAnimation(
            context: context,
            state: state,
            child: const SettingEnvScreen(type: SettingEnv.ENV));
      },
    ),
  ],
);

class VietQRAdmin extends StatefulWidget {
  const VietQRAdmin({super.key});

  @override
  State<StatefulWidget> createState() => _VietQRAdmin();
}

class _VietQRAdmin extends State<VietQRAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MenuProvider()),
        ],
        child: MaterialApp.router(
          onGenerateTitle: (context) => 'VietQR VN - Admin',
          routerConfig: _router,
          themeMode: ThemeMode.light,
          darkTheme: DefaultThemeData(context: context).darkTheme,
          theme: DefaultThemeData(context: context).lightTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
          ],
          supportedLocales: const [
            //  Locale('en'), // English
            Locale('vi'), // Vietnamese
          ],
        ),
      ),
    );
  }
}

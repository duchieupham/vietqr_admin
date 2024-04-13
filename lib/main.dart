import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietqr_admin/commons/constants/configurations/theme.dart';
import 'package:vietqr_admin/commons/constants/utils/setup.dart';
import 'package:vietqr_admin/feature/dashboard/dashboard_screen.dart';
import 'package:vietqr_admin/feature/login/views/login.dart';
import 'package:vietqr_admin/service/shared_references/session.dart';
import 'package:vietqr_admin/service/shared_references/user_information_helper.dart';

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

// final isLoggedIn = UserInformationHelper.instance.getUserId().trim().isNotEmpty;
// final String authenticatedRedirect = (isLoggedIn) ? '/home' : '/login';

final GoRouter _router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        return (UserInformationHelper.instance.getAdminId().trim().isNotEmpty)
            ? '/dashboard'
            : '/login';
      },
    ),
    GoRoute(
      path: '/login',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getAdminId().trim().isNotEmpty)
              ? '/dashboard'
              : '/login',
      builder: (BuildContext context, GoRouterState state) => const Login(),
    ),
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) =>
          (UserInformationHelper.instance.getAdminId().trim().isNotEmpty)
              ? '/dashboard'
              : '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const DashboardScreen(),
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
    );
  }
}

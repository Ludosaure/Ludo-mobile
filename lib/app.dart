import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/pages/home_page.dart';
import 'package:ludo_mobile/ui/pages/landing_page.dart';
import 'package:ludo_mobile/ui/router/app_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/custom_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  bool _isLogged = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return ResponsiveWrapper.builder(
          ClampingScrollWrapper.builder(context, widget!),
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
        );
      },
      title: 'Ludosaure',
      theme: ThemeData(
        backgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomTheme.primary,
          secondary: CustomTheme.primaryLight,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
      home: SafeArea(
        child: _homePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _homePage() {
    return _isLogged ? const HomePage() : const LandingPage();
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    final String? accessToken = localStorage.getString('token');

      setState(() {
        _isLogged = accessToken != null;
      });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ludo_mobile/ui/router/app_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'domain/use_cases/session/session_cubit.dart';
import 'injection.dart';
import 'utils/custom_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = locator<AppRouter>();
  // https://pub.dev/packages/easy_localization/example

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<SessionCubit>())
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.router.routerDelegate,
        routeInformationParser: _appRouter.router.routeInformationParser,
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
          colorScheme: ColorScheme.fromSwatch().copyWith(
            background: Colors.white,
            primary: CustomTheme.primary,
            secondary: CustomTheme.primaryLight,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/home_page.dart';
import 'package:ludo_mobile/ui/pages/login_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_success_page.dart';
import 'package:ludo_mobile/ui/pages/terms_and_conditions_page.dart';

import '../pages/landing_page.dart';

class AppRouter {
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _loginBloc,
            child: const HomePage(),
          ),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _loginBloc,
            child: const LoginPage(),
          ),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _registerBLoc,
            child: const RegisterPage(),
          ),
        );
      case '/register-success':
        return MaterialPageRoute(
          builder: (_) => const RegisterSuccessPage(),
        );
      case '/terms-and-conditions':
        return MaterialPageRoute(builder: (_) => TermsAndConditionsPage());
      default:
        return MaterialPageRoute(builder: (_) => const LandingPage());
    }
  }

  void dispose() {
    _loginBloc.close();
    _registerBLoc.close();
  }
}

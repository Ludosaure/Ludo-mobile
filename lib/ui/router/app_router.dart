import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/game/add_game_page.dart';
import 'package:ludo_mobile/ui/pages/admin_dashboard_page.dart';
import 'package:ludo_mobile/ui/pages/game/game_details_page.dart';
import 'package:ludo_mobile/ui/pages/game/game_favorites_page.dart';
import 'package:ludo_mobile/ui/pages/home/admin_home_page.dart';
import 'package:ludo_mobile/ui/pages/home/user_home_page.dart';
import 'package:ludo_mobile/ui/pages/inbox_page.dart';
import 'package:ludo_mobile/ui/pages/landing_page.dart';
import 'package:ludo_mobile/ui/pages/login_page.dart';
import 'package:ludo_mobile/ui/pages/profile_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_success_page.dart';
import 'package:ludo_mobile/ui/pages/terms_and_conditions_page.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class AppRouter {
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();
  final GetGamesCubit _getGamesCubit = locator<GetGamesCubit>();

  GoRouter get router => _router;

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.landing.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LandingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.home.path,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _loginBloc,
              ),
              BlocProvider.value(
                value: _getGamesCubit,
              ),
            ],
            child: UserHomePage(
              connectedUser: state.extra != null ? state.extra as User : null,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.homeAdmin.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _loginBloc,
            child: const AdminHomePage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.login.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _loginBloc,
            child: const LoginPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.register.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _registerBLoc,
            child: const RegisterPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: Routes.success.path,
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const RegisterSuccessPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.terms.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: TermsAndConditionsPage(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.game.path,
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: BlocProvider.value(
                value: _getGamesCubit,
                child: GameDetailsPage(
                  game: state.extra as Game,
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.addGame.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AddGamePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.favorites.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const GameFavoritesPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.inbox.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const InboxPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.logout.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LandingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.profile.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: Routes.adminDashboard.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AdminDashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
    ],
    // redirect: (state) {
    //   return '/';
    // },
    // refreshListenable: GoRouterRefreshStream(),
  );

  void dispose() {
    _loginBloc.close();
    _registerBLoc.close();
    _getGamesCubit.close();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/list_all_reservations/list_all_reservations_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/cart/cart_page.dart';
import 'package:ludo_mobile/ui/pages/game/add_game_page.dart';
import 'package:ludo_mobile/ui/pages/admin_dashboard_page.dart';
import 'package:ludo_mobile/ui/pages/game/favorite/favorite_games_page.dart';
import 'package:ludo_mobile/ui/pages/game/detail/game_details_page.dart';
import 'package:ludo_mobile/ui/pages/home/admin_home_page.dart';
import 'package:ludo_mobile/ui/pages/home/user_home_page.dart';
import 'package:ludo_mobile/ui/pages/inbox_page.dart';
import 'package:ludo_mobile/ui/pages/landing_page.dart';
import 'package:ludo_mobile/ui/pages/login_page.dart';
import 'package:ludo_mobile/ui/pages/profile_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_success_page.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_detail_page.dart';
import 'package:ludo_mobile/ui/pages/terms_and_conditions_page.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class AppRouter {
  final SessionCubit _sessionCubit;
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();
  final GetGameCubit _getGameCubit = locator<GetGameCubit>();
  final GetGamesCubit _getGamesCubit = locator<GetGamesCubit>();
  final CartCubit _cartBloc = locator<CartCubit>();
  final ListAllReservationsCubit _listAllReservationsCubit =
      locator<ListAllReservationsCubit>();
  final FavoriteGamesCubit _getFavoriteGamesCubit =
      locator<FavoriteGamesCubit>();

  late User? connectedUser;

  AppRouter(this._sessionCubit);

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
              connectedUser: connectedUser,
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
            value: _listAllReservationsCubit,
            child: AdminHomePage(
              user: connectedUser!,
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
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: "${Routes.game.path}/:id",
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: locator<
                    GetGameCubit>(), //TODO vérifier les fuites mémoire -> close
              ),
              BlocProvider.value(
                value: _cartBloc,
              ),
              BlocProvider.value(
                value: _getFavoriteGamesCubit,
              ),
            ],
            child: GameDetailsPage(
              gameId: state.params['id']!,
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
        path: Routes.addGame.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: AddGamePage(
            user: connectedUser!,
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
        path: '${Routes.reservations.path}/:id',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ReservationDetailsPage(),
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
          child: BlocProvider.value(
            value: _getFavoriteGamesCubit,
            child: FavoriteGamesPage(
              user: connectedUser!,
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
        path: Routes.inbox.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: InboxPage(
            user: connectedUser!,
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
          child: AdminDashboardPage(
            user: connectedUser!,
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
        path: Routes.cart.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _cartBloc,
            child: const CartPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
    ],
    redirect: _redirect,
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
  );

  String? _redirect(GoRouterState state) {
    connectedUser = null;
    if (_sessionCubit.state is UserLoggedIn) {
      connectedUser = (_sessionCubit.state as UserLoggedIn).user;

      final bool isAdminRoute = state.location == Routes.homeAdmin.path ||
          state.location == Routes.addGame.path ||
          state.location == Routes.reservations.path ||
          state.location == Routes.adminDashboard.path;

      // guard admin ou auto-login client
      if (isAdminRoute && !connectedUser!.isAdmin() ||
          state.location == Routes.landing.path &&
              !connectedUser!.isAdmin()) {
        return Routes.home.path;
      }

      // auto-login admin
      if (connectedUser!.isAdmin() && state.location == Routes.landing.path) {
        return Routes.homeAdmin.path;
      }
    }

    RegExp gameDetailsRoute = AppConstants.UUID_V4;
    gameDetailsRoute.hasMatch(state.location);
    final bool isUnauthenticatedRoute = state.location == Routes.login.path ||
        state.location == Routes.register.path ||
        state.location == Routes.terms.path ||
        state.location == Routes.home.path ||
        state.location == Routes.landing.path ||
        gameDetailsRoute.hasMatch(state.location);

    if (connectedUser == null && !isUnauthenticatedRoute) {
      return Routes.login.path;
    }

    return null;
  }

  void dispose() {
    _sessionCubit.close();
    _loginBloc.close();
    _registerBLoc.close();
    _getGamesCubit.close();
    _listAllReservationsCubit.close();
    _getFavoriteGamesCubit.close();
    _getGameCubit.close();
    _cartBloc.close();
  }
}

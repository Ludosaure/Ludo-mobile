import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/create_game/create_game_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/delete_game/delete_game_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_categories/get_categories_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_reservation/get_reservation_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/invoice/download_invoice_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/list_all_reservations/list_all_reservations_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_game/update_game_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/cart/cart_page.dart';
import 'package:ludo_mobile/ui/pages/game/add_game_page.dart';
import 'package:ludo_mobile/ui/pages/admin_dashboard_page.dart';
import 'package:ludo_mobile/ui/pages/game/admin_game_page.dart';
import 'package:ludo_mobile/ui/pages/game/favorite/favorite_games_page.dart';
import 'package:ludo_mobile/ui/pages/game/detail/game_details_page.dart';
import 'package:ludo_mobile/ui/pages/game/update_game_page.dart';
import 'package:ludo_mobile/ui/pages/home/admin_home_page.dart';
import 'package:ludo_mobile/ui/pages/home/user_home_page.dart';
import 'package:ludo_mobile/ui/pages/messages/conversation_page.dart';
import 'package:ludo_mobile/ui/pages/messages/inbox_page.dart';
import 'package:ludo_mobile/ui/pages/landing_page.dart';
import 'package:ludo_mobile/ui/pages/login_page.dart';
import 'package:ludo_mobile/ui/pages/profile/profile_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_success_page.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_detail_page.dart';
import 'package:ludo_mobile/ui/pages/reservation/user_reservations_page.dart';
import 'package:ludo_mobile/ui/pages/terms_and_conditions_page.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class AppRouter {
  final SessionCubit _sessionCubit;
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();
  final GetGamesCubit _getGamesCubit = locator<GetGamesCubit>();
  final CartCubit _cartBloc = locator<CartCubit>();
  final ListAllReservationsCubit _listAllReservationsCubit =
      locator<ListAllReservationsCubit>();
  final FavoriteGamesCubit _getFavoriteGamesCubit =
      locator<FavoriteGamesCubit>();
  final ListReductionPlanCubit _listReductionPlanCubit =
      locator<ListReductionPlanCubit>();
  final DeleteGameCubit _deleteGameCubit = locator<DeleteGameCubit>();
  final DownloadInvoiceCubit _downloadInvoiceCubit =
      locator<DownloadInvoiceCubit>();
  final CreateGameBloc _createGameBloc = locator<CreateGameBloc>();
  final UpdateGameBloc _updateGameBloc = locator<UpdateGameBloc>();
  final GetCategoriesCubit _getCategoriesCubit = locator<GetCategoriesCubit>();

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
              BlocProvider.value(
                value: _listReductionPlanCubit,
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
                //TODO vérifier les fuites mémoire -> close
                value: locator<GetGameCubit>(),
              ),
              BlocProvider.value(
                value: _cartBloc,
              ),
              BlocProvider.value(
                value: _getFavoriteGamesCubit,
              ),
              BlocProvider.value(
                value: _listReductionPlanCubit,
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _createGameBloc,
              ),
              BlocProvider.value(
                value: _getCategoriesCubit,
              ),
            ],
            child: AddGamePage(
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
        path: '${Routes.game.path}/:id/${Routes.updateGame.path}',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _updateGameBloc,
              ),
              BlocProvider.value(
                value: _getCategoriesCubit,
              ),
            ],
            child: UpdateGamePage(
              game: state.extra! as Game,
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
        path: '${Routes.reservations.path}/:id',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: locator<GetReservationCubit>(),
              ),
              BlocProvider.value(
                value: locator<UserReservationsCubit>(),
              ),
              BlocProvider.value(
                value: _downloadInvoiceCubit,
              ),
            ],
            child: ReservationDetailsPage(
              reservationId: state.params['id']!,
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
        path: "${Routes.inbox.path}/:conversationId",
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ConversationPage(
            conversationId: state.params['conversationId']!,
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _sessionCubit,
              ),
            ],
            child: ProfilePage(
              connectedUser: connectedUser!,
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
        path: Routes.userReservations.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: locator<UserReservationsCubit>(),
            child: const UserReservationsPage(),
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
      GoRoute(
        path: Routes.adminGames.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _getGamesCubit,
              ),
              BlocProvider.value(
                value: _deleteGameCubit,
              ),
            ],
            child: AdminGamesPage(
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
    ],
    redirect: _redirect,
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
  );

  String? _redirect(GoRouterState state) {
    connectedUser = null;
    if (_sessionCubit.state is UserLoggedIn) {
      connectedUser = (_sessionCubit.state as UserLoggedIn).user;

      final bool isAdminRoute = _isAdminRoute(state.location);

      // guard admin ou auto-login client
      if (isAdminRoute && !connectedUser!.isAdmin() ||
          state.location == Routes.landing.path && !connectedUser!.isAdmin()) {
        return Routes.home.path;
      }

      // auto-login admin
      if (connectedUser!.isAdmin() && state.location == Routes.landing.path) {
        return Routes.homeAdmin.path;
      }
    }

    final bool isUnauthenticatedRoute = _isUnauthenticatedRoute(state.location);

    if (connectedUser == null && !isUnauthenticatedRoute) {
      return Routes.login.path;
    }

    return null;
  }

  bool _isAdminRoute(String route) {
    return route == Routes.homeAdmin.path ||
        route == Routes.addGame.path ||
        route == Routes.reservations.path ||
        route == Routes.adminDashboard.path ||
        route == Routes.adminGames.path;
  }

  bool _isUnauthenticatedRoute(String route) {
    RegExp gameDetailsRoute = AppConstants.UUID_V4;

    return route == Routes.login.path ||
        route == Routes.register.path ||
        route == Routes.registerSuccess.path ||
        route == Routes.terms.path ||
        route == Routes.home.path ||
        route == Routes.landing.path ||
        gameDetailsRoute.hasMatch(route);
  }

  void dispose() {
    _sessionCubit.close();
    _loginBloc.close();
    _registerBLoc.close();
    _getGamesCubit.close();
    _listAllReservationsCubit.close();
    _getFavoriteGamesCubit.close();
    _cartBloc.close();
    _listReductionPlanCubit.close();
    _downloadInvoiceCubit.close();
    _deleteGameCubit.close();
    _createGameBloc.close();
    _updateGameBloc.close();
    _getCategoriesCubit.close();
  }
}

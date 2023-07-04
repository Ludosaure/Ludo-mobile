import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/create_game/create_game_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/create_plan/create_plan_bloc.dart';
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
import 'package:ludo_mobile/domain/use_cases/review_game/review_game_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/unavailabilities/game_unavailabilities_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_game/update_game_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/update_plan/update_plan_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/update_user/update_user_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/cart/cart_page.dart';
import 'package:ludo_mobile/ui/pages/categories/category_list_page.dart';
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
import 'package:ludo_mobile/ui/pages/plans/create_plan_page.dart';
import 'package:ludo_mobile/ui/pages/plans/plan_list_page.dart';
import 'package:ludo_mobile/ui/pages/plans/update_plan_page.dart';
import 'package:ludo_mobile/ui/pages/profile/profile_page.dart';
import 'package:ludo_mobile/ui/pages/profile/update_profile_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_page.dart';
import 'package:ludo_mobile/ui/pages/register/register_success_page.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_detail_page.dart';
import 'package:ludo_mobile/ui/pages/reservation/user_reservations_page.dart';
import 'package:ludo_mobile/ui/pages/terms_and_conditions_page.dart';
import 'package:ludo_mobile/ui/pages/unavailability/game_unavailabilities_page.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class AppRouter {
  final SessionCubit _sessionCubit;
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();
  final GetGamesCubit _getGamesCubit = locator<GetGamesCubit>();
  final CartCubit _cartCubit = locator<CartCubit>();
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
  final CreatePlanBloc _createPlanBloc = locator<CreatePlanBloc>();
  final UpdatePlanBloc _updatePlanBloc = locator<UpdatePlanBloc>();
  final UpdateUserBloc _updateUserBloc = locator<UpdateUserBloc>();
  final GetCategoriesCubit _getCategoriesCubit = locator<GetCategoriesCubit>();
  final ReviewGameCubit _reviewGameCubit = locator<ReviewGameCubit>();

  late User? connectedUser;

  AppRouter(this._sessionCubit);

  GoRouter get router => _router;

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.landing.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LandingPage(),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.home.path,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: _userHome(),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.homeAdmin.path,
        pageBuilder: (context, state) => CustomTransitionPage(
            child: _adminHome(), transitionsBuilder: _getTransition),
      ),
      GoRoute(
        path: Routes.login.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _loginBloc,
            child: const LoginPage(),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.register.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _registerBLoc,
            child: const RegisterPage(),
          ),
          transitionsBuilder: _getTransition,
        ),
        routes: [
          GoRoute(
            path: Routes.success.path,
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const RegisterSuccessPage(),
              transitionsBuilder: _getTransition,
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.terms.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: TermsAndConditionsPage(),
          transitionsBuilder: _getTransition,
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
                value: _cartCubit,
              ),
              BlocProvider.value(
                value: _getFavoriteGamesCubit,
              ),
              BlocProvider.value(
                value: _listReductionPlanCubit,
              ),
              BlocProvider.value(
                value: _reviewGameCubit,
              ),
            ],
            child: GameDetailsPage(
              user: connectedUser,
              gameId: state.params['id']!,
            ),
          ),
          transitionsBuilder: _getTransition,
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
              BlocProvider.value(
                value: _getGamesCubit,
              ),
            ],
            child: AddGamePage(
              user: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.createPlan.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _createPlanBloc,
              ),
              BlocProvider.value(
                value: _listReductionPlanCubit,
              ),
            ],
            child: CreatePlanPage(),
          ),
          transitionsBuilder: _getTransition,
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
              BlocProvider.value(
                value: _deleteGameCubit,
              ),
              BlocProvider.value(
                value: _getGamesCubit,
              ),
            ],
            child: UpdateGamePage(
              game: state.extra! as Game,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: '${Routes.plan.path}/:id/${Routes.updatePlan.path}',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _updatePlanBloc,
              ),
              BlocProvider.value(
                value: _listReductionPlanCubit,
              ),
            ],
            child: UpdatePlanPage(
              plan: state.extra! as Plan,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: '${Routes.game.path}/:id/${Routes.gameUnavailabilities.path}',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: locator<GameUnavailabilitiesCubit>(),
              ),
            ],
            child: GameUnavailabilitiesPage(
              game: state.extra! as Game,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: '${Routes.profile.path}/${Routes.updateProfile.path}',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _updateUserBloc,
              ),
              BlocProvider.value(
                value: _sessionCubit,
              ),
            ],
            child: UpdateProfilePage(
              user: state.extra! as User,
            ),
          ),
          transitionsBuilder: _getTransition,
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
              user: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.favorites.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _getFavoriteGamesCubit,
              ),
              BlocProvider.value(
                value: _cartCubit,
              ),
            ],
            child: FavoriteGamesPage(
              user: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.inbox.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _cartCubit,
              ),
            ],
            child: InboxPage(
              user: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: "${Routes.inbox.path}/:conversationId",
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ConversationPage(
            conversationId: state.params['conversationId']!,
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.logout.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LandingPage(),
          transitionsBuilder: _getTransition,
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
              BlocProvider.value(
                value: _cartCubit,
              ),
            ],
            child: ProfilePage(
              connectedUser: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.userReservations.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: locator<UserReservationsCubit>(),
            child: const UserReservationsPage(),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.adminDashboard.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: AdminDashboardPage(
            user: connectedUser!,
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.cart.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _cartCubit,
            child: CartPage(
              user: connectedUser!,
            ),
          ),
          transitionsBuilder: _getTransition,
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
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.categoryList.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _getCategoriesCubit,
            child: const CategoryListPage(),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
      GoRoute(
        path: Routes.planList.path,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider.value(
            value: _listReductionPlanCubit,
            child: const PlanListPage(),
          ),
          transitionsBuilder: _getTransition,
        ),
      ),
    ],
    redirect: _redirect,
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
    errorBuilder: (context, state) {
      return connectedUser!.isAdmin()
          ? _adminHome()
          : UserHomePage(connectedUser: connectedUser!);
    },
  );

  String? _redirect(GoRouterState state) {
    connectedUser = null;
    if (_sessionCubit.state is UserLoggedIn) {
      connectedUser = (_sessionCubit.state as UserLoggedIn).user;

      final bool isAdminRoute = _isAdminRoute(state.location);
      print("is admin route: $isAdminRoute");

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
    RegExp updateGameRoute = AppConstants.GAME_UPDATE_REGEX;

    return route == Routes.homeAdmin.path ||
        route == Routes.addGame.path ||
        updateGameRoute.hasMatch(route) ||
        route == Routes.createPlan.path ||
        route == Routes.updatePlan.path ||
        route == Routes.reservations.path ||
        route == Routes.adminDashboard.path ||
        route == Routes.adminGames.path ||
        route == Routes.planList.path ||
        route == Routes.categoryList.path ||
        route == Routes.gameUnavailabilities.path;
  }

  bool _isUnauthenticatedRoute(String route) {
    RegExp gameDetailsRoute = AppConstants.GAME_DETAILS_REGEX;

    return route == Routes.login.path ||
        route == Routes.register.path ||
        route == Routes.registerSuccess.path ||
        route == Routes.terms.path ||
        route == Routes.home.path ||
        route == Routes.landing.path ||
        gameDetailsRoute.hasMatch(route);
  }

  FadeTransition _getTransition(context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  _userHome() {
    return MultiBlocProvider(
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
        BlocProvider.value(
          value: _cartCubit,
        ),
      ],
      child: UserHomePage(
        connectedUser: connectedUser,
      ),
    );
  }

  BlocProvider<ListAllReservationsCubit> _adminHome() {
    return BlocProvider.value(
      value: _listAllReservationsCubit,
      child: AdminHomePage(
        user: connectedUser!,
      ),
    );
  }

  void dispose() {
    _sessionCubit.close();
    _loginBloc.close();
    _registerBLoc.close();
    _getGamesCubit.close();
    _listAllReservationsCubit.close();
    _getFavoriteGamesCubit.close();
    _cartCubit.close();
    _listReductionPlanCubit.close();
    _downloadInvoiceCubit.close();
    _deleteGameCubit.close();
    _createGameBloc.close();
    _updateGameBloc.close();
    _createPlanBloc.close();
    _updatePlanBloc.close();
    _updateUserBloc.close();
    _getCategoriesCubit.close();
    _reviewGameCubit.close();
  }
}

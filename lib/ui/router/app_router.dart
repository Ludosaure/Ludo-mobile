import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/pages/add_game_page.dart';
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

class AppRouter {
  final LoginBloc _loginBloc = locator<LoginBloc>();
  final RegisterBloc _registerBLoc = locator<RegisterBloc>();
  final GetGamesCubit _getGamesCubit = locator<GetGamesCubit>();

  GoRouter get router => _router;

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MultiBlocProvider(
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
      ),
      GoRoute(
        path: '/home/admin',
        builder: (context, state) => BlocProvider.value(
          value: _loginBloc,
          child: const AdminHomePage(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider.value(
          value: _loginBloc,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider.value(
          value: _registerBLoc,
          child: const RegisterPage(),
        ),
        routes: [
          GoRoute(
            path: 'terms',
            builder: (context, state) => TermsAndConditionsPage(),
          ),
          GoRoute(
            path: 'success',
            builder: (context, state) => const RegisterSuccessPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/game',
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => BlocProvider.value(
              value: _getGamesCubit,
              child: GameDetailsPage(
                game: state.extra as Game,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/game-add',
        builder: (context, state) => const AddGamePage(),
      ),
      GoRoute(
        path: '/game-favorites',
        builder: (context, state) => const GameFavoritesPage(),
      ),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const InboxPage(),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminDashboardPage(),
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

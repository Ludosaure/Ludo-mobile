enum Routes {
  landing,
  home,
  homeAdmin,
  login,
  logout,
  register,
  registerSuccess,
  profile,
  game,
  addGame,
  updateGame,
  gameUnavailabilities,
  updateProfile,
  adminGames,
  inbox,
  terms,
  favorites,
  adminDashboard,
  reservations,
  success,
  cart,
  userReservations,
  planList,
  categoryList,
}

extension RoutesExtension on Routes {
  String get path {
    switch (this) {
      case Routes.landing:
        return '/';
      case Routes.home:
        return '/home';
      case Routes.homeAdmin:
        return '/home/admin';
      case Routes.login:
        return '/login';
      case Routes.logout:
        return '/logout';
      case Routes.register:
        return '/register';
      case Routes.registerSuccess:
        return '/register/success';
      case Routes.terms:
        return '/terms';
      case Routes.profile:
        return '/profile';
      case Routes.game:
        return '/game';
      case Routes.addGame:
        return '/game-add';
      case Routes.updateGame:
        return 'edit';
      case Routes.gameUnavailabilities:
        return 'unavailabilities';
      case Routes.updateProfile:
        return 'edit';
      case Routes.adminGames:
        return '/games';
      case Routes.inbox:
        return '/inbox';
      case Routes.favorites:
        return '/favorites';
      case Routes.adminDashboard:
        return '/dashboard';
      case Routes.reservations:
        return '/admin/reservations';
      case Routes.success:
        return 'success';
      case Routes.cart:
        return '/cart';
      case Routes.userReservations:
        return '/reservations';
      case Routes.planList:
        return '/plans';
      case Routes.categoryList:
        return '/categories';
    }
  }
}


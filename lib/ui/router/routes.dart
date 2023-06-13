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
  inbox,
  terms,
  favorites,
  adminDashboard,
  reservations,
  success,
  cart,
  userReservations,
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
    }
  }
}

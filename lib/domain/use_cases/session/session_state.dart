
part of 'session_cubit.dart';

@immutable
abstract class SessionState {}

class SessionInitial extends SessionState {}

class UserLoggedIn extends SessionState {
  final User user;

  UserLoggedIn({required this.user});
}

class UserNotLogged extends SessionState {}
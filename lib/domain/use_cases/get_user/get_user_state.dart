part of 'get_user_cubit.dart';

@immutable
abstract class GetUserState {
  const GetUserState();
}

class GetUserInitial extends GetUserState {}

class GetUserLoading extends GetUserState {}

class GetUserSuccess extends GetUserState {
  final User user;

  const GetUserSuccess({required this.user});
}

class GetUserError extends GetUserState {
  final String message;
  const GetUserError({required this.message});
}

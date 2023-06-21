part of 'get_categories_cubit.dart';

@immutable
abstract class GetCategoriesState {
  final List<GameCategory> categories;

  const GetCategoriesState({
    required this.categories,
  });
}

class GetCategoriesInitial extends GetCategoriesState {
  GetCategoriesInitial() : super(categories: List.empty());
}

class GetCategoriesLoading extends GetCategoriesState {
  GetCategoriesLoading() : super(categories: List.empty());
}

class GetCategoriesSuccess extends GetCategoriesState {
  const GetCategoriesSuccess({required List<GameCategory> categories})
      : super(categories: categories);
}

class GetCategoriesError extends GetCategoriesState {
  final String message;

  GetCategoriesError({required this.message}) : super(categories: List.empty());
}

class UserNotLogged extends GetCategoriesState {
  UserNotLogged() : super(categories: List.empty());
}

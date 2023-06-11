part of 'list_conversations_cubit.dart';

@immutable
abstract class ListConversationsState {
  final List<Conversation> conversations;
  const ListConversationsState({
    this.conversations = const [],
  });
}

class ListConversationsInitial extends ListConversationsState {
  const ListConversationsInitial() : super();
}

class ListConversationsLoading extends ListConversationsState {
  const ListConversationsLoading() : super();
}

class ListConversationsSuccess extends ListConversationsState {
  const ListConversationsSuccess({required List<Conversation> conversations})
      : super(conversations: conversations);
}

class ListConversationsError extends ListConversationsState {
  final String message;
  const ListConversationsError({required this.message}) : super();
}

class UserMustLogError extends ListConversationsInitial {
  final String message;
  const UserMustLogError({required this.message}) : super();
}

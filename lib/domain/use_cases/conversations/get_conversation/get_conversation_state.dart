part of 'get_conversation_cubit.dart';

@immutable
abstract class GetConversationState {
  const GetConversationState();
}

class GetConversationInitial extends GetConversationState {}

class GetConversationLoading extends GetConversationState {}

class GetConversationSuccess extends GetConversationState {
  final Conversation conversation;

  const GetConversationSuccess({required this.conversation});
}

class GetConversationError extends GetConversationState {
  final String message;
  const GetConversationError({required this.message});
}

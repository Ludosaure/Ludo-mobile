import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/messages_repository.dart';
import 'package:ludo_mobile/domain/models/conversation.dart';
import 'package:meta/meta.dart';

part 'list_conversations_state.dart';

@injectable
class ListConversationsCubit extends Cubit<ListConversationsState> {
  final MessagesRepository _messagesRepository;

  ListConversationsCubit(this._messagesRepository)
      : super(const ListConversationsInitial());

  void listConversations() async {
    emit(const ListConversationsLoading());

    try {
      final conversations = await _messagesRepository.getMyConversations();
      emit(ListConversationsSuccess(conversations: conversations));
    } catch (exception) {
      if (
        exception is UserNotLoggedInException ||
        exception is ForbiddenException
      ) {
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );
        return;
      }

      emit(
        ListConversationsError(message: exception.toString()),
      );
    }
  }
}
